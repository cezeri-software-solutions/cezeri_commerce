// ignore_for_file: unnecessary_cast

import 'package:cezeri_commerce/1_presentation/core/core.dart';
import 'package:dartz/dartz.dart';

import '/3_domain/entities/product/product.dart';
import '/3_domain/entities/product/product_marketplace.dart';
import '/3_domain/entities/settings/main_settings.dart';
import '../../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../../3_domain/entities/marketplace/marketplace_presta.dart';
import '../../../../3_domain/entities/marketplace/marketplace_shopify.dart';
import '../../../../3_domain/entities/product/marketplace_product.dart';
import '../../../../3_domain/entities/product/product_id_with_quantity.dart';
import '../../../../3_domain/entities/product/product_presta.dart';
import '../../../../3_domain/repositories/database/product_repository.dart';
import '../../../../constants.dart';
import '../../../../failures/abstract_failure.dart';
import '../../../../failures/firebase_failures.dart';
import '../../prestashop_api/models/order_presta.dart';
import '../../prestashop_api/prestashop_repository_get.dart';
import '../../shopify_api/shopify.dart';
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

Future<Either<AbstractFailure, Product>> getOrCreateProductFromPrestaOnImportAppointment({
  required OrderProductPresta orderProductPresta,
  required int quantity,
  required MarketplacePresta marketplace,
  required MainSettings mainSettings,
  required ProductRepository productRepository,
  required List<ProductIdWithQuantity>? listOfProductIdWithQuantity,
}) async {
  Product? newCreatedOrUpdatedProduct;

  final productFromDatabase = await getProductFromFirestoreIfExists(
    articleNumber: orderProductPresta.productReference,
    ean: orderProductPresta.productEan13,
    name: orderProductPresta.productName,
    productRepository: productRepository,
  );
  if (productFromDatabase == null) {
    final fosProductPresta = await PrestashopRepositoryGet(marketplace).getProduct(int.parse(orderProductPresta.productId));
    if (fosProductPresta.isLeft()) {
      logger.e('Artikel aus Bestellung konnte beim Bestellimport nicht aus Marktplatz geladen werden');
      return left(MixedFailure(errorMessage: 'Artikel aus Bestellung konnte beim Bestellimport nicht aus Marktplatz geladen werden'));
    }
    final productPresta = ProductPresta.fromProductRawPresta(fosProductPresta.getRight());

    final phToCreateProduct = Product.fromMarketplaceProduct(
      marketplaceProduct: productPresta,
      marketplace: marketplace,
      mainSettings: mainSettings,
      listOfProductIdWithQuantity: listOfProductIdWithQuantity,
    );
    final toCreateProduct = phToCreateProduct.copyWith(
      warehouseStock: phToCreateProduct.warehouseStock + quantity,
      availableStock: phToCreateProduct.availableStock + quantity,
    );
    final fosProduct = await productRepository.createProduct(toCreateProduct, productPresta);

    if (fosProduct.isLeft()) {
      logger.e('Artikel: ${productPresta.name} konte nicht in der Datenbank angelegt werden. \n Error: ${fosProduct.getLeft()}');
      return Left(GeneralFailure(customMessage: 'Artikel: ${productPresta.name} konnte nicht in der Datenbank angelegt werden'));
    }

    newCreatedOrUpdatedProduct = fosProduct.getRight();
    return Right(newCreatedOrUpdatedProduct);
  } else {
    //* Wenn dieser Marktplatz in Cezeri-Commerce diesem Artikel nicht zugeordnet ist
    if (!productFromDatabase.productMarketplaces.any((e) => e.idMarketplace == marketplace.id)) {
      final fosProductPresta = await PrestashopRepositoryGet(marketplace).getProduct(int.parse(orderProductPresta.productId));
      if (fosProductPresta.isLeft()) {
        logger.e('Artikel aus Bestellung konnte beim Bestellimport nicht aus Marktplatz geladen werden');
        return left(MixedFailure(errorMessage: 'Artikel aus Bestellung konnte beim Bestellimport nicht aus Marktplatz geladen werden'));
      }
      final productPresta = fosProductPresta.getRight();

      final productMarketplace = ProductMarketplace.fromMarketplaceProduct(ProductPresta.fromProductRawPresta(productPresta), marketplace);
      List<ProductMarketplace> productMarketplaces = List.from(productFromDatabase.productMarketplaces);
      productMarketplaces.add(productMarketplace);
      final updatedProduct = productFromDatabase.copyWith(productMarketplaces: productMarketplaces);
      newCreatedOrUpdatedProduct = updatedProduct;

      await productRepository.updateProductAndSets(updatedProduct);
    } else {
      newCreatedOrUpdatedProduct = productFromDatabase;
    }
    return Right(newCreatedOrUpdatedProduct);
  }
}

Future<Either<AbstractFailure, Product>> getOrCreateProductFromShopifyOnImportAppointment({
  required ProductShopify productShopify,
  required int quantity,
  required MarketplaceShopify marketplace,
  required MainSettings mainSettings,
  required ProductRepository productRepository,
  required List<ProductIdWithQuantity>? listOfProductIdWithQuantity,
}) async {
  Product? newCreatedOrUpdatedProduct;

  final productFromDatabase = await getProductFromFirestoreIfExists(
    articleNumber: productShopify.variants.first.sku,
    ean: productShopify.variants.first.barcode ?? '',
    name: productShopify.title,
    productRepository: productRepository,
  );
  if (productFromDatabase == null) {
    final phToCreateProduct = Product.fromMarketplaceProduct(
      marketplaceProduct: productShopify,
      marketplace: marketplace,
      mainSettings: mainSettings,
      listOfProductIdWithQuantity: listOfProductIdWithQuantity,
    );
    final toCreateProduct = phToCreateProduct.copyWith(
      warehouseStock: phToCreateProduct.warehouseStock + quantity,
      availableStock: phToCreateProduct.availableStock + quantity,
    );

    final fosProduct = await productRepository.createProduct(toCreateProduct, productShopify);
    if (fosProduct.isLeft()) {
      logger.e('Artikel: ${productShopify.title} konte nicht in der Datenbank angelegt werden. \n Error: ${fosProduct.getLeft()}');
      return left(GeneralFailure(customMessage: 'Artikel: ${productShopify.title} konnte nicht in der Datenbank angelegt werden'));
    }
    final createdProductDatabase = fosProduct.getRight();

    newCreatedOrUpdatedProduct = createdProductDatabase;
    return Right(newCreatedOrUpdatedProduct);
  } else {
    //* Wenn dieser Marktplatz in Cezeri-Commerce diesem Artikel nicht zugeordnet ist
    if (!productFromDatabase.productMarketplaces.any((e) => e.idMarketplace == marketplace.id)) {
      final productMarketplace = ProductMarketplace.fromMarketplaceProduct(productShopify, marketplace);
      List<ProductMarketplace> productMarketplaces = List.from(productFromDatabase.productMarketplaces);
      productMarketplaces.add(productMarketplace);
      final updatedProduct = productFromDatabase.copyWith(productMarketplaces: productMarketplaces);
      newCreatedOrUpdatedProduct = updatedProduct;

      await productRepository.updateProductAndSets(updatedProduct);
    } else {
      newCreatedOrUpdatedProduct = productFromDatabase;
    }
    return Right(newCreatedOrUpdatedProduct);
  }
}
