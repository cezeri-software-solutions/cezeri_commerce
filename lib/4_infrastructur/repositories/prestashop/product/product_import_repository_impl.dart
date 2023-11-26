import 'package:cezeri_commerce/3_domain/entities/product/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

import '../../../../1_presentation/core/functions/check_internet_connection.dart';
import '../../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../../3_domain/entities/product/product_marketplace.dart';
import '../../../../3_domain/entities/settings/main_settings.dart';
import '../../../../3_domain/entities_presta/product_presta.dart';
import '../../../../3_domain/repositories/firebase/product_repository.dart';
import '../../../../3_domain/repositories/prestashop/product/product_import_repository.dart';
import '../../../../core/abstract_failure.dart';
import '../../../../core/firebase_failures.dart';
import '../../../../core/presta_failure.dart';
import '../../firebase/repository_impl_helper.dart';
import '../../prestashop_api/prestashop_api.dart';

class ProductImportRepositoryImpl implements ProductImportRepository {
  final FirebaseFirestore db;
  final FirebaseAuth firebaseAuth;
  final ProductRepository productRepository;

  ProductImportRepositoryImpl({required this.db, required this.firebaseAuth, required this.productRepository});

  @override
  Future<Either<PrestaFailure, List<ProductPresta>>> getAllProductsFromPrestashop() async {
    // try {
    //   final response = await http.get(
    //     Uri.parse('https://ccf-autopflege.at/api/products?ws_key=L2YILL715KNNT469R5L1GU9MMLAVNGYG'),
    //     headers: {'Content-Type': 'application/xml'},
    //   );

    //   final document = XmlDocument.parse(response.body);
    //   final productsXml = document.findAllElements('product');

    //   List<ProductPrestaOld> products = [];
    //   for (int i = 0; i < 20; i++) {
    //     final href = productsXml.elementAt(i).getAttribute('xlink:href') ?? '';
    //     print('Produktdetails URL: $href');
    //     final productDetails = await fetchDetailsOfMultipleProducts('$href&ws_key=L2YILL715KNNT469R5L1GU9MMLAVNGYG');

    //     products.add(productDetails);
    //   }
    //   return right(products);
    // } catch (e) {
    //   print(e);
    //   return left(PrestaGeneralFailure());
    // }
    throw UnimplementedError();
  }

  @override
  Future<Either<AbstractFailure, List<int>>> getToLoadProductsFromMarketplace(Marketplace marketplace, bool onlyActive) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());
    final logger = Logger();

    try {
      List<int> listOfToLoadAppointmentsFromMarketplace = [];

      final api = PrestashopApi(Client(), PrestashopApiConfig(apiKey: marketplace.key, webserviceUrl: marketplace.fullUrl));

      if (marketplace.marketplaceType == MarketplaceType.prestashop) {
        final productIdsPresta = switch (onlyActive) {
          false => await api.getProductIds(),
          true => await api.getProductIdsOnlyActive(),
        };
        final allProductIds = productIdsPresta.map((e) => e.id).toList();
        allProductIds.sort((a, b) => a.compareTo(b));

        listOfToLoadAppointmentsFromMarketplace.addAll(allProductIds);
      }
      return right(listOfToLoadAppointmentsFromMarketplace);
    } catch (e) {
      logger.e('Fehler beim laden der zu ladenden Produkte von Marktplätzen: $e');
      return left(MixedFailure(errorMessage: 'Fehler beim laden der zu ladenden Produkte von Marktplätzen: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, ProductPresta>> loadProductFromMarketplace(int productId, Marketplace marketplace) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());
    final logger = Logger();

    final api = PrestashopApi(Client(), PrestashopApiConfig(apiKey: marketplace.key, webserviceUrl: marketplace.fullUrl));

    try {
      final optionalProductPresta = await api.getProduct(productId, marketplace);
      if (optionalProductPresta.isNotPresent) {
        logger.e('Fehler beim Laden des Artikels aus Prestashop');
        return left(PrestaGeneralFailure(errorMessage: 'Fehler beim Laden der Artikels aus Prestashop'));
      }
      final productPresta = optionalProductPresta.value;

      return right(productPresta);
    } catch (e) {
      logger.e('Fehler beim laden des Artikels mit der ID ($productId) vom Marktplatz: $e');
      return left(PrestaGeneralFailure(errorMessage: 'Fehler beim laden des Artikels vom Marktplatz: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, Product?>> uploadLoadedProductToFirestore(
    ProductPresta productPresta,
    Marketplace marketplace,
    MainSettings mainSettings,
  ) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());
    final logger = Logger();

    try {
      final productFirestore = await getProductFromFirestoreIfExists(
        productPresta.reference,
        productPresta.ean13,
        productPresta.name!,
        marketplace,
        mainSettings,
        productRepository,
      );

      Product? newCreatedOrUpdatedProduct;

      if (productFirestore == null) {
        final createdProductFirestore = await createProductInFirestore(
          Product.fromProductPresta(
            productPresta: productPresta,
            marketplace: marketplace,
            mainSettings: mainSettings,
          ),
          productPresta,
          marketplace,
          mainSettings,
          productRepository,
        );
        if (createdProductFirestore == null) return left(GeneralFailure as FirebaseFailure);
        newCreatedOrUpdatedProduct = createdProductFirestore;
      } else {
        if (!productFirestore.productMarketplaces.any((e) => e.idMarketplace == marketplace.id)) {
          final productMarketplace = ProductMarketplace.fromProductPresta(productPresta, marketplace);
          List<ProductMarketplace> productMarketplaces = List.from(productFirestore.productMarketplaces);
          productMarketplaces.add(productMarketplace);
          final updatedProduct = productFirestore.copyWith(productMarketplaces: productMarketplaces);
          newCreatedOrUpdatedProduct = updatedProduct;

          await productRepository.updateProduct(updatedProduct);
        }
      }

      return right(newCreatedOrUpdatedProduct);
    } catch (e) {
      logger.e('Fehler beim hochladen des Artikels zu Firestore: $e');
      return left(PrestaGeneralFailure(errorMessage: 'Fehler beim hochladen des Artikels zu Firestore: $e'));
    }
  }

  @override
  Future<Either<PrestaFailure, ProductPresta>> getProductByIdFromPrestashopAsJson(int id, Marketplace marketplace) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(PrestaGeneralFailure());
    final logger = Logger();

    final api = PrestashopApi(Client(), PrestashopApiConfig(apiKey: marketplace.key, webserviceUrl: marketplace.fullUrl));

    try {
      final optionalProductPresta = await api.getProduct(id, marketplace);
      if (optionalProductPresta.isNotPresent) return left(PrestaGeneralFailure());
      final productPresta = optionalProductPresta.value;

      return right(productPresta);
    } catch (e) {
      logger.e(e);
      return left(PrestaGeneralFailure());
    }
  }
}


  //   final uri = '${marketplace.fullUrl}products/$id';
  //   // final uriStock = '${marketplace.fullUrl}stocks?filter[id_product]=$id&ws_key=${marketplace.key}:';
  //   // final uriStock = 'https://ccf-autopflege.at/api/stocks/?filter[id_product]=$id';
  //   // final uriStock = 'https://ccf-autopflege.at/api/stocks?filter[id_product]=$id';
  //   // final uriStock = '${marketplace.fullUrl}stock_availables?filter[id_product]=$id';
  //   final uriStock = '${marketplace.fullUrl}stock_availables/8264';
  //   // final uriStock = '${marketplace.fullUrl}images/products/$id';