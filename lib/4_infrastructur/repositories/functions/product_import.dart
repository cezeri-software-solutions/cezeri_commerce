import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../../../3_domain/entities/product/product_id_with_quantity.dart';
import '../../../3_domain/entities_presta/order_presta.dart';
import '../../../core/abstract_failure.dart';
import '../../../core/firebase_failures.dart';
import '../prestashop_api/prestashop_api.dart';
import '../../../3_domain/entities/marketplace/marketplace_presta.dart';
import '/3_domain/entities/product/product.dart';
import '/3_domain/entities/product/product_marketplace.dart';
import '/3_domain/entities/settings/main_settings.dart';
import '/3_domain/entities_presta/product_presta.dart';
import '/3_domain/repositories/firebase/product_repository.dart';
import 'get_or_create_product_from_firestore.dart';

final logger = Logger();

Future<Either<AbstractFailure, Product>> getOrCreateProductFromPrestaOnImportProduct(
  ProductPresta productPresta,
  MarketplacePresta marketplace,
  MainSettings mainSettings,
  ProductRepository productRepository,
  List<ProductIdWithQuantity>? listOfProductIdWithQuantity,
) async {
  Product? newCreatedOrUpdatedProduct;

  final productFirestore = await getProductFromFirestoreIfExists(
    productPresta.reference,
    productPresta.ean13,
    productPresta.name!,
    marketplace,
    mainSettings,
    productRepository,
  );

  if (productFirestore == null) {
    final createdProductFirestore = await createProductInFirestore(
      Product.fromProductPresta(
        productPresta: productPresta,
        marketplace: marketplace,
        mainSettings: mainSettings,
        listOfProductIdWithQuantity: listOfProductIdWithQuantity,
      ),
      productPresta,
      marketplace,
      mainSettings,
      productRepository,
      listOfProductIdWithQuantity,
    );
    if (createdProductFirestore == null) {
      logger.e('Artikel konnte nicht in der Datenbank angelegt werden');
      return left(GeneralFailure(customMessage: 'Artikel konnte nicht in der Datenbank angelegt werden'));
    }
    newCreatedOrUpdatedProduct = createdProductFirestore;
    return right(newCreatedOrUpdatedProduct);
  } else {
    if (!productFirestore.productMarketplaces.any((e) => e.idMarketplace == marketplace.id)) {
      final productMarketplace = ProductMarketplace.fromProductPresta(productPresta, marketplace);
      List<ProductMarketplace> productMarketplaces = List.from(productFirestore.productMarketplaces);
      productMarketplaces.add(productMarketplace);
      final updatedProduct = productFirestore.copyWith(productMarketplaces: productMarketplaces);
      newCreatedOrUpdatedProduct = updatedProduct;

      await productRepository.updateProductAndSets(updatedProduct);

      return right(newCreatedOrUpdatedProduct);
    } else {
      newCreatedOrUpdatedProduct = productFirestore;
      return right(newCreatedOrUpdatedProduct);
    }
  }
}

Future<Either<AbstractFailure, Product>> getOrCreateProductFromPrestaOnImportAppointment(
  OrderProductPresta orderProductPresta,
  int quantity,
  MarketplacePresta marketplace,
  MainSettings mainSettings,
  ProductRepository productRepository,
  PrestashopApi api,
  List<ProductIdWithQuantity>? listOfProductIdWithQuantity,
) async {
  Product? newCreatedOrUpdatedProduct;

  final productFirestore = await getProductFromFirestoreIfExists(
    orderProductPresta.productReference,
    orderProductPresta.productEan13,
    orderProductPresta.productName,
    marketplace,
    mainSettings,
    productRepository,
  );
  if (productFirestore == null) {
    final optionalProductPresta = await api.getProduct(int.parse(orderProductPresta.productId), marketplace);
    if (optionalProductPresta.isNotPresent) {
      logger.e('Artikel aus Bestellung konnte beim Bestellimport nicht aus Marktplatz geladen werden');
      return left(MixedFailure(errorMessage: 'Artikel aus Bestellung konnte beim Bestellimport nicht aus Marktplatz geladen werden'));
    }
    final productPresta = optionalProductPresta.value;

    final createdProductFirestore = await createProductInFirestore(
      Product.fromProductPresta(
        productPresta: productPresta,
        marketplace: marketplace,
        mainSettings: mainSettings,
        listOfProductIdWithQuantity: listOfProductIdWithQuantity,
      ),
      productPresta,
      marketplace,
      mainSettings,
      productRepository,
      listOfProductIdWithQuantity,
    );
    if (createdProductFirestore == null) return left(GeneralFailure as FirebaseFailure);
    await productRepository.updateWarehouseQuantityOfNewProductOnImportIncremental(createdProductFirestore, quantity);
    newCreatedOrUpdatedProduct = createdProductFirestore;
    return right(newCreatedOrUpdatedProduct);
  } else {
    if (!productFirestore.productMarketplaces.any((e) => e.idMarketplace == marketplace.id)) {
      final optionalProductPresta = await api.getProduct(int.parse(orderProductPresta.productId), marketplace);
      if (optionalProductPresta.isNotPresent) {
        logger.e('Artikel aus Bestellung konnte beim Bestellimport nicht aus Marktplatz geladen werden');
        return left(MixedFailure(errorMessage: 'Artikel aus Bestellung konnte beim Bestellimport nicht aus Marktplatz geladen werden'));
      }
      final productPresta = optionalProductPresta.value;
      final productMarketplace = ProductMarketplace.fromProductPresta(productPresta, marketplace);
      List<ProductMarketplace> productMarketplaces = List.from(productFirestore.productMarketplaces);
      productMarketplaces.add(productMarketplace);
      final updatedProduct = productFirestore.copyWith(productMarketplaces: productMarketplaces);
      newCreatedOrUpdatedProduct = updatedProduct;

      await productRepository.updateProductAndSets(updatedProduct);
      await productRepository.updateAvailableQuantityOfProductInremental(updatedProduct, quantity * -1, null);
    } else {
      newCreatedOrUpdatedProduct = productFirestore;
      await productRepository.updateAvailableQuantityOfProductInremental(productFirestore, quantity * -1, null);
    }
    return right(newCreatedOrUpdatedProduct);
  }
}
