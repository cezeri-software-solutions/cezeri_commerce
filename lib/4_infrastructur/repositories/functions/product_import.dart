// ignore_for_file: unnecessary_cast

import 'package:dartz/dartz.dart';

import '/3_domain/entities/product/product.dart';
import '/3_domain/entities/product/product_marketplace.dart';
import '/3_domain/entities/settings/main_settings.dart';
import '/3_domain/repositories/firebase/product_repository.dart';
import '../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../3_domain/entities/marketplace/marketplace_presta.dart';
import '../../../3_domain/entities/marketplace/marketplace_shopify.dart';
import '../../../3_domain/entities/product/marketplace_product.dart';
import '../../../3_domain/entities/product/product_id_with_quantity.dart';
import '../../../3_domain/entities/product/product_presta.dart';
import '../../../constants.dart';
import '../../../failures/abstract_failure.dart';
import '../../../failures/firebase_failures.dart';
import '../prestashop_api/models/order_presta.dart';
import '../prestashop_api/prestashop_api.dart';
import '../shopify_api/shopify.dart';
import 'get_or_create_product_from_firestore.dart';

Future<Either<AbstractFailure, Product>> getOrCreateProductFromMarketplaceOnImportProduct({
  required MarketplaceProduct marketplaceProduct,
  required AbstractMarketplace marketplace,
  required MainSettings mainSettings,
  required ProductRepository productRepository,
  required List<ProductIdWithQuantity>? listOfProductIdWithQuantity,
}) async {
  Product? newCreatedOrUpdatedProduct;

  final productData = switch (marketplaceProduct.marketplaceType) {
    MarketplaceType.prestashop => (
        articleNumber: (marketplaceProduct as ProductPresta).reference,
        ean: (marketplaceProduct).ean13,
        name: (marketplaceProduct as ProductPresta).name ?? '',
      ),
    MarketplaceType.shopify => (
        articleNumber: (marketplaceProduct as ProductShopify).variants.first.sku,
        ean: (marketplaceProduct).variants.first.barcode ?? '',
        name: (marketplaceProduct as ProductShopify).title,
      ),
    MarketplaceType.shop => (articleNumber: '', ean: '', name: ''),
  };

  final productFirestore = await getProductFromFirestoreIfExists(
    articleNumber: productData.articleNumber,
    ean: productData.ean,
    name: productData.name,
    productRepository: productRepository,
  );

  if (productFirestore == null) {
    final fosProduct = await productRepository.createProduct(
      Product.fromMarketplaceProduct(
        marketplaceProduct: marketplaceProduct,
        marketplace: marketplace,
        mainSettings: mainSettings,
        listOfProductIdWithQuantity: listOfProductIdWithQuantity,
      ),
      marketplaceProduct,
    );
    return fosProduct.fold(
      (failure) {
        logger.e('Artikel: ${productData.name} konte nicht in der Firestore Datenbank angelegt werden. \n Error: $failure');
        return Left(GeneralFailure(customMessage: 'Artikel: ${productData.name} konnte nicht in der Datenbank angelegt werden'));
      },
      (productFirestore) => Right(productFirestore),
    );
  } else {
    if (!productFirestore.productMarketplaces.any((e) => e.idMarketplace == marketplace.id)) {
      final productMarketplace = ProductMarketplace.fromMarketplaceProduct(marketplaceProduct, marketplace);
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
    articleNumber: orderProductPresta.productReference,
    ean: orderProductPresta.productEan13,
    name: orderProductPresta.productName,
    productRepository: productRepository,
  );
  if (productFirestore == null) {
    final optionalProductPresta = await api.getProduct(int.parse(orderProductPresta.productId), marketplace);
    if (optionalProductPresta.isNotPresent) {
      logger.e('Artikel aus Bestellung konnte beim Bestellimport nicht aus Marktplatz geladen werden');
      return left(MixedFailure(errorMessage: 'Artikel aus Bestellung konnte beim Bestellimport nicht aus Marktplatz geladen werden'));
    }
    final productPresta = ProductPresta.fromProductRawPresta(optionalProductPresta.value);

    Product? createdProductFirestore;
    final fosProduct = await productRepository.createProduct(
      Product.fromMarketplaceProduct(
        marketplaceProduct: productPresta,
        marketplace: marketplace,
        mainSettings: mainSettings,
        listOfProductIdWithQuantity: listOfProductIdWithQuantity,
      ),
      productPresta,
    );
    fosProduct.fold(
      (failure) {
        logger.e('Artikel: ${productPresta.name} konte nicht in der Firestore Datenbank angelegt werden. \n Error: $failure');
        return left(GeneralFailure(customMessage: 'Artikel: ${productPresta.name} konnte nicht in der Datenbank angelegt werden'));
      },
      (productFirestore) => createdProductFirestore = productFirestore,
    );
    if (createdProductFirestore == null) return left(GeneralFailure());
    await productRepository.updateWarehouseQuantityOfNewProductOnImportIncremental(createdProductFirestore!, quantity);
    newCreatedOrUpdatedProduct = createdProductFirestore;
    return right(newCreatedOrUpdatedProduct!);
  } else {
    if (!productFirestore.productMarketplaces.any((e) => e.idMarketplace == marketplace.id)) {
      final optionalProductPresta = await api.getProduct(int.parse(orderProductPresta.productId), marketplace);
      if (optionalProductPresta.isNotPresent) {
        logger.e('Artikel aus Bestellung konnte beim Bestellimport nicht aus Marktplatz geladen werden');
        return left(MixedFailure(errorMessage: 'Artikel aus Bestellung konnte beim Bestellimport nicht aus Marktplatz geladen werden'));
      }
      final productPresta = optionalProductPresta.value;
      final productMarketplace =
          ProductMarketplace.fromMarketplaceProduct(ProductPresta.fromProductRawPresta(productPresta), marketplace); //TODO: Shopify
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
    return Right(newCreatedOrUpdatedProduct);
  }
}

Future<Either<AbstractFailure, Product>> getOrCreateProductFromShopifyOnImportAppointment(
  ProductShopify productShopify,
  int quantity,
  MarketplaceShopify marketplace,
  MainSettings mainSettings,
  ProductRepository productRepository,
  List<ProductIdWithQuantity>? listOfProductIdWithQuantity,
) async {
  Product? newCreatedOrUpdatedProduct;

  final productFirestore = await getProductFromFirestoreIfExists(
    articleNumber: productShopify.variants.first.sku,
    ean: productShopify.variants.first.barcode ?? '',
    name: productShopify.title,
    productRepository: productRepository,
  );
  if (productFirestore == null) {
    Product? createdProductFirestore;
    final fosProduct = await productRepository.createProduct(
      Product.fromMarketplaceProduct(
        marketplaceProduct: productShopify,
        marketplace: marketplace,
        mainSettings: mainSettings,
        listOfProductIdWithQuantity: listOfProductIdWithQuantity,
      ),
      productShopify,
    );
    fosProduct.fold(
      (failure) {
        logger.e('Artikel: ${productShopify.title} konte nicht in der Datenbank angelegt werden. \n Error: $failure');
        return left(GeneralFailure(customMessage: 'Artikel: ${productShopify.title} konnte nicht in der Datenbank angelegt werden'));
      },
      (productFirestore) => createdProductFirestore = productFirestore,
    );
    if (createdProductFirestore == null) return left(GeneralFailure());
    await productRepository.updateWarehouseQuantityOfNewProductOnImportIncremental(createdProductFirestore!, quantity);
    newCreatedOrUpdatedProduct = createdProductFirestore;
    return right(newCreatedOrUpdatedProduct!);
  } else {
    if (!productFirestore.productMarketplaces.any((e) => e.idMarketplace == marketplace.id)) {
      final productMarketplace = ProductMarketplace.fromMarketplaceProduct(productShopify, marketplace);
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
    return Right(newCreatedOrUpdatedProduct);
  }
}
