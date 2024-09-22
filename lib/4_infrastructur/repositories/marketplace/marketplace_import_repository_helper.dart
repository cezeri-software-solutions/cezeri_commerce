import 'package:dartz/dartz.dart';

import '/1_presentation/core/core.dart';
import '../../../3_domain/entities/marketplace/marketplace_presta.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/entities/product/product_id_with_quantity.dart';
import '../../../3_domain/entities/product/product_presta.dart';
import '../../../3_domain/entities/settings/main_settings.dart';
import '../../../3_domain/repositories/database/marketplace_repository.dart';
import '../../../3_domain/repositories/database/product_repository.dart';
import '../../../constants.dart';
import '../../../failures/abstract_failure.dart';
import '../database/functions/product_import.dart';
import '../database/functions/product_repository_helper.dart';
import '../prestashop_api/prestashop_repository_get.dart';
import '../shopify_api/shopify.dart';

Future<Either<AbstractFailure, Product?>> createOrUpdateProductFromMarketplacePresta({
  required String marketplaceId,
  required String ownerId,
  required ProductPresta productPresta,
  required MainSettings mainSettings,
  required ProductRepository productRepository,
  required MarketplaceRepository marketplaceRepository,
}) async {
  final fosMarketplace = await marketplaceRepository.getMarketplace(marketplaceId);
  if (fosMarketplace.isLeft()) return Left(fosMarketplace.getLeft());
  final marketplace = fosMarketplace.getRight() as MarketplacePresta;

  Product? newCreatedOrUpdatedProduct;

  //* Wenn Set-Artikel werden auch die Einzelartikel des Sets mitgeladen
  if (productPresta.type == 'pack' &&
      productPresta.associations!.associationsProductBundle != null &&
      productPresta.associations!.associationsProductBundle!.isNotEmpty) {
    final List<ProductIdWithQuantity> listOfProductIdWithQuantity = [];
    final List<Product> listOfSetPartProducts = [];
    for (final partProductPrestaId in productPresta.associations!.associationsProductBundle!) {
      final fosProductPresta = await PrestashopRepositoryGet(marketplace).getProduct(int.parse(partProductPrestaId.id));
      if (fosProductPresta.isLeft()) {
        logger.e('Artikel aus Bestellung konnte beim Bestellimport nicht aus Marktplatz geladen werden');
        return left(MixedFailure(errorMessage: 'Artikel aus Bestellung konnte beim Bestellimport nicht aus Marktplatz geladen werden'));
      }
      final loadedProductPresta = ProductPresta.fromProductRawPresta(fosProductPresta.getRight());
      final fosLoadedOrCreatedProduct = await getOrCreateProductFromMarketplaceOnImportProduct(
        marketplaceProduct: loadedProductPresta,
        marketplace: marketplace,
        mainSettings: mainSettings,
        productRepository: productRepository,
        listOfProductIdWithQuantity: null,
      );
      fosLoadedOrCreatedProduct.fold(
        (failure) => left(failure),
        (locProduct) {
          listOfSetPartProducts.add(locProduct);
          listOfProductIdWithQuantity.add(ProductIdWithQuantity(productId: locProduct.id, quantity: partProductPrestaId.quantity.toMyInt()));
        },
      );
    }
    final fosToImportProduct = await getOrCreateProductFromMarketplaceOnImportProduct(
      marketplaceProduct: productPresta,
      marketplace: marketplace,
      mainSettings: mainSettings,
      productRepository: productRepository,
      listOfProductIdWithQuantity: listOfProductIdWithQuantity,
    );
    fosToImportProduct.fold(
      (failure) => left(failure),
      (appProduct) => newCreatedOrUpdatedProduct = appProduct,
    );

    await addSetProductIdToPartProducts(
      ownerId: ownerId,
      setProduct: newCreatedOrUpdatedProduct!,
      listOfSetPartProducts: listOfSetPartProducts,
    );
  } else {
    final fosToImportProduct = await getOrCreateProductFromMarketplaceOnImportProduct(
      marketplaceProduct: productPresta,
      marketplace: marketplace,
      mainSettings: mainSettings,
      productRepository: productRepository,
      listOfProductIdWithQuantity: null,
    );
    return fosToImportProduct.fold(
      (failure) => Left(failure),
      (appProduct) => Right(appProduct),
    );
  }

  return Right(newCreatedOrUpdatedProduct);
}

Future<Either<AbstractFailure, Product?>> createOrUpdateProductFromMarketplaceShopify({
  required String marketplaceId,
  required ProductShopify productShopify,
  required MainSettings mainSettings,
  required ProductRepository productRepository,
  required MarketplaceRepository marketplaceRepository,
}) async {
  final fosMarketplace = await marketplaceRepository.getMarketplace(marketplaceId);
  if (fosMarketplace.isLeft()) return Left(fosMarketplace.getLeft());
  final marketplace = fosMarketplace.getRight() as MarketplacePresta;

  Product? newCreatedOrUpdatedProduct;

  //* Wenn Set-Artikel werden auch die Einzelartikel des Sets mitgeladen
  // if (productShopify.type == 'pack' &&
  //     productShopify.associations!.associationsProductBundle != null &&
  //     productShopify.associations!.associationsProductBundle!.isNotEmpty) {
  //   final List<ProductIdWithQuantity> listOfProductIdWithQuantity = [];
  //   final List<Product> listOfSetPartProducts = [];
  //   for (final partProductPrestaId in productShopify.associations!.associationsProductBundle!) {
  //     final optionalProductPresta = await api.getProduct(int.parse(partProductPrestaId.id), marketplace);
  //     if (optionalProductPresta.isNotPresent) {
  //       logger.e('Artikel aus Bestellung konnte beim Bestellimport nicht aus Marktplatz geladen werden');
  //       return left(MixedFailure(errorMessage: 'Artikel aus Bestellung konnte beim Bestellimport nicht aus Marktplatz geladen werden'));
  //     }
  //     final loadedProductPresta = ProductPresta.fromProductRawPresta(optionalProductPresta.value);
  //     final fosLoadedOrCreatedProduct = await getOrCreateProductFromPrestaOnImportProduct(
  //       loadedProductPresta,
  //       marketplace,
  //       mainSettings,
  //       productRepository,
  //       null,
  //     );
  //     fosLoadedOrCreatedProduct.fold(
  //       (failure) => left(failure),
  //       (locProduct) {
  //         listOfSetPartProducts.add(locProduct);
  //         listOfProductIdWithQuantity.add(ProductIdWithQuantity(productId: locProduct.id, quantity: partProductPrestaId.quantity.toMyInt()));
  //       },
  //     );
  //   }
  //   final fosToImportProduct = await getOrCreateProductFromPrestaOnImportProduct(
  //     productShopify,
  //     marketplace,
  //     mainSettings,
  //     productRepository,
  //     listOfProductIdWithQuantity,
  //   );
  //   fosToImportProduct.fold(
  //     (failure) => left(failure),
  //     (appProduct) => newCreatedOrUpdatedProduct = appProduct,
  //   );

  //   await addSetProductIdToPartProducts(
  //     db: db,
  //     currentUserUid: currentUserUid,
  //     transaction: null,
  //     setProduct: newCreatedOrUpdatedProduct!,
  //     listOfSetPartProducts: listOfSetPartProducts,
  //   );
  // } else {
  final fosToImportProduct = await getOrCreateProductFromMarketplaceOnImportProduct(
    marketplaceProduct: productShopify,
    marketplace: marketplace,
    mainSettings: mainSettings,
    productRepository: productRepository,
    listOfProductIdWithQuantity: null,
  );
  fosToImportProduct.fold(
    (failure) => left(failure),
    (appProduct) => newCreatedOrUpdatedProduct = appProduct,
  );
  // }

  return Right(newCreatedOrUpdatedProduct);
}
