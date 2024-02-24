import 'package:cezeri_commerce/1_presentation/core/extensions/string_to_int.dart';
import 'package:cezeri_commerce/3_domain/entities/marketplace/marketplace_shopify.dart';
import 'package:cezeri_commerce/3_domain/entities/product/product.dart';
import 'package:cezeri_commerce/3_domain/entities_presta/category_presta.dart';
import 'package:cezeri_commerce/4_infrastructur/repositories/shopify_api/models/products/product_shopify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

import '../../../../1_presentation/core/functions/check_internet_connection.dart';
import '../../../../3_domain/entities/settings/main_settings.dart';
import '../../../../3_domain/entities_presta/product_presta.dart';
import '../../../../3_domain/repositories/firebase/product_repository.dart';
import '../../../../3_domain/repositories/marketplace/marketplace_import_repository.dart';
import '../../../../core/abstract_failure.dart';
import '../../../../core/firebase_failures.dart';
import '../../../../core/presta_failure.dart';
import '../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../3_domain/entities/marketplace/marketplace_presta.dart';
import '../../../3_domain/entities/product/product_id_with_quantity.dart';
import '../functions/product_import.dart';
import '../functions/product_repository_helper.dart';
import '../prestashop_api/prestashop_api.dart';

final logger = Logger();

class MarketplaceImportRepositoryImpl implements MarketplaceImportRepository {
  final FirebaseFirestore db;
  final FirebaseAuth firebaseAuth;
  final ProductRepository productRepository;

  MarketplaceImportRepositoryImpl({required this.db, required this.firebaseAuth, required this.productRepository});

  @override
  Future<Either<AbstractFailure, List<int>>> getToLoadProductsFromMarketplace(MarketplacePresta marketplace, bool onlyActive) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    try {
      List<int> listOfToLoadAppointmentsFromMarketplace = [];

      final api = PrestashopApi(Client(), PrestashopApiConfig(apiKey: marketplace.key, webserviceUrl: marketplace.fullUrl));

      switch (marketplace.marketplaceType) {
        case MarketplaceType.prestashop:
          {
            final productIdsPresta = switch (onlyActive) {
              false => await api.getProductIds(),
              true => await api.getProductIdsOnlyActive(),
            };
            final allProductIds = productIdsPresta.map((e) => e.id).toList();
            allProductIds.sort((a, b) => a.compareTo(b));

            listOfToLoadAppointmentsFromMarketplace.addAll(allProductIds);
          }
        case MarketplaceType.shopify:
          {
            throw Exception('SHOPIFY not implemented');
          }
        case MarketplaceType.shop:
          {
            throw Exception('SHOP not implemented');
          }
      }
      return right(listOfToLoadAppointmentsFromMarketplace);
    } catch (e) {
      logger.e('Fehler beim laden der zu ladenden Produkte von Marktplätzen: $e');
      return left(MixedFailure(errorMessage: 'Fehler beim laden der zu ladenden Produkte von Marktplätzen: $e'));
    }
  }

  @override
  Future<Either<AbstractFailure, ProductPresta>> loadProductFromMarketplace(int productId, MarketplacePresta marketplace) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

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
  Future<Either<AbstractFailure, Product?>> uploadLoadedProductToFirestore(ProductPresta productPresta, String marketplaceId) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;

    final docRefMarketplace = db.collection('Marketetplaces').doc(currentUserUid).collection('Marketetplaces').doc(marketplaceId);
    final docRefSettings = db.collection('Settings').doc(currentUserUid).collection('Settings').doc(currentUserUid);

    try {
      final marketplaceDs = await docRefMarketplace.get();
      if (!marketplaceDs.exists) return left(GeneralFailure());
      final marketplace = MarketplacePresta.fromJson(marketplaceDs.data()!);

      final settingsDs = await docRefSettings.get();
      if (!settingsDs.exists) return left(GeneralFailure());
      final mainSettings = MainSettings.fromJson(settingsDs.data()!);

      final api = PrestashopApi(Client(), PrestashopApiConfig(apiKey: marketplace.key, webserviceUrl: marketplace.fullUrl));

      Product? newCreatedOrUpdatedProduct;

      //* Wenn Set-Artikel werden auch die Einzelartikel des Sets mitgeladen
      if (productPresta.type == 'pack' &&
          productPresta.associations.associationsProductBundle != null &&
          productPresta.associations.associationsProductBundle!.isNotEmpty) {
        final List<ProductIdWithQuantity> listOfProductIdWithQuantity = [];
        final List<Product> listOfSetPartProducts = [];
        for (final partProductPrestaId in productPresta.associations.associationsProductBundle!) {
          final optionalProductPresta = await api.getProduct(int.parse(partProductPrestaId.id), marketplace);
          if (optionalProductPresta.isNotPresent) {
            logger.e('Artikel aus Bestellung konnte beim Bestellimport nicht aus Marktplatz geladen werden');
            return left(MixedFailure(errorMessage: 'Artikel aus Bestellung konnte beim Bestellimport nicht aus Marktplatz geladen werden'));
          }
          final loadedProductPresta = optionalProductPresta.value;
          final fosLoadedOrCreatedProduct = await getOrCreateProductFromPrestaOnImportProduct(
            loadedProductPresta,
            marketplace,
            mainSettings,
            productRepository,
            null,
          );
          fosLoadedOrCreatedProduct.fold(
            (failure) => left(failure),
            (locProduct) {
              listOfSetPartProducts.add(locProduct);
              listOfProductIdWithQuantity.add(ProductIdWithQuantity(productId: locProduct.id, quantity: partProductPrestaId.quantity.toMyInt()));
            },
          );
        }
        final fosToImportProduct = await getOrCreateProductFromPrestaOnImportProduct(
          productPresta,
          marketplace,
          mainSettings,
          productRepository,
          listOfProductIdWithQuantity,
        );
        fosToImportProduct.fold(
          (failure) => left(failure),
          (appProduct) => newCreatedOrUpdatedProduct = appProduct,
        );

        await addSetProductIdToPartProducts(
          db: db,
          currentUserUid: currentUserUid,
          transaction: null,
          setProduct: newCreatedOrUpdatedProduct!,
          listOfSetPartProducts: listOfSetPartProducts,
        );
      } else {
        final fosToImportProduct = await getOrCreateProductFromPrestaOnImportProduct(
          productPresta,
          marketplace,
          mainSettings,
          productRepository,
          null,
        );
        fosToImportProduct.fold(
          (failure) => left(failure),
          (appProduct) => newCreatedOrUpdatedProduct = appProduct,
        );
      }

      return right(newCreatedOrUpdatedProduct);
    } catch (e) {
      logger.e('Fehler beim hochladen des Artikels zu Firestore: $e');
      return left(PrestaGeneralFailure(errorMessage: 'Fehler beim hochladen des Artikels zu Firestore: $e'));
    }
  }

  @override
  Future<Either<PrestaFailure, ProductPresta>> loadProductByIdFromPrestashopAsJson(int id, MarketplacePresta marketplace) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(PrestaGeneralFailure());

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

  @override
  Future<Either<PrestaFailure, List<ProductShopify>>> loadProductByArticleNumberFromShopify(String articleNumber, MarketplaceShopify marketplace) {
    // TODO: implement loadProductByArticleNumberFromShopify
    throw UnimplementedError();
  }

  @override
  Future<Either<PrestaFailure, List<CategoryPresta>>> getAllPrestaCategories(MarketplacePresta marketplace) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(PrestaGeneralFailure());

    final api = PrestashopApi(Client(), PrestashopApiConfig(apiKey: marketplace.key, webserviceUrl: marketplace.fullUrl));

    try {
      final categoriesPresta = await api.getCategories();

      return right(categoriesPresta);
    } catch (e) {
      logger.e(e);
      return left(PrestaGeneralFailure());
    }
  }

  
}
