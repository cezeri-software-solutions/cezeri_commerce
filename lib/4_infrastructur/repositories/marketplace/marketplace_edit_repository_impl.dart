import 'package:cezeri_commerce/3_domain/repositories/database/marketplace_repository.dart';
import 'package:cezeri_commerce/4_infrastructur/repositories/prestashop_api/prestashop_repository_get.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';

import '/1_presentation/core/core.dart';
import '/3_domain/entities/carrier/parcel_tracking.dart';
import '/3_domain/entities/marketplace/abstract_marketplace.dart';
import '/3_domain/entities/marketplace/marketplace_presta.dart';
import '/3_domain/entities/marketplace/marketplace_shopify.dart';
import '/3_domain/entities/product/product.dart';
import '/3_domain/entities/product/product_image.dart';
import '/3_domain/entities/product/product_marketplace.dart';
import '/3_domain/entities/product/product_presta.dart';
import '/3_domain/enums/enums.dart';
import '/3_domain/repositories/marketplace/marketplace_edit_repository.dart';
import '/constants.dart';
import '/failures/failures.dart';
import '../../../3_domain/repositories/database/product_repository.dart';
import '../database/functions/repository_functions.dart';
import '../prestashop_api/models/product_raw_presta.dart';
import '../prestashop_api/prestashop_repository_delete.dart';
import '../prestashop_api/prestashop_repository_patch.dart';
import '../prestashop_api/prestashop_repository_post.dart';
import '../shopify_api/shopify.dart';

class MarketplaceEditRepositoryImpl implements MarketplaceEditRepository {
  MarketplaceEditRepositoryImpl();

  @override
  Future<Either<List<AbstractFailure>, Unit>> setQuantityMPInAllProductMarketplaces(
    Product product,
    int newQuantity,
    AbstractMarketplace? marketplaceToSkip,
  ) async {
    if (!await checkInternetConnection()) return Left([NoConnectionFailure()]);
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left([GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden')]);

    final List<AbstractFailure> failures = [];

    for (ProductMarketplace productMarketplace in product.productMarketplaces) {
      if (marketplaceToSkip != null && productMarketplace.idMarketplace == marketplaceToSkip.id) continue;

      final marketplaceResponse =
          await supabase.from('d_marketplaces').select().eq('ownerId', ownerId).eq('id', productMarketplace.idMarketplace).single();
      if (marketplaceResponse.isEmpty) return Left([GeneralFailure(customMessage: 'Marktplatz konnte nicht geladen werden.')]);
      final marketplace = AbstractMarketplace.fromJson(marketplaceResponse);

      if (!marketplace.isActive) continue;

      if (productMarketplace.marketplaceProduct == null) return left([ProductHasNoMarketplaceFailure()]);

      switch (productMarketplace.marketplaceProduct!.marketplaceType) {
        case MarketplaceType.prestashop:
          {
            final marketplaceProduct = productMarketplace.marketplaceProduct as ProductPresta;

            final resProduct = await PrestashopRepositoryPatch(marketplace as MarketplacePresta).patchProductQuantity(
              productId: marketplaceProduct.id,
              quantity: newQuantity,
            );

            if (resProduct.isLeft()) failures.add(resProduct.getLeft());
          }
        case MarketplaceType.shopify:
          {
            final marketplaceProduct = productMarketplace.marketplaceProduct as ProductShopify;

            final resProduct = await ShopifyRepositoryPost(marketplace as MarketplaceShopify).postProductStock(
              productId: marketplaceProduct.id,
              quantity: newQuantity,
            );

            if (resProduct.isLeft()) failures.add(resProduct.getLeft());
          }

        case MarketplaceType.shop:
          throw Exception('Ladengeschäft kann keine Artikel zum aktualisieren des Bestandes haben.');
      }
    }

    if (failures.isEmpty) return const Right(unit);
    return Left(failures);
  }

  @override
  Future<Either<List<AbstractFailure>, Unit>> editProdcutInMarketplace(Product product, List<AbstractMarketplace>? toEditMarketplaces) async {
    if (!await checkInternetConnection()) return Left([NoConnectionFailure()]);
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left([GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden')]);

    final List<AbstractFailure> failures = [];

    for (final productMarketplace in product.productMarketplaces) {
      //* Wenn "toEditMarketplaces" mitgegeben wird, dann sollen nur diese Marktplätze aktualisiert werden.
      if (toEditMarketplaces != null && !toEditMarketplaces.any((e) => e.id == productMarketplace.idMarketplace)) continue;

      final marketplaceResponse =
          await supabase.from('d_marketplaces').select().eq('ownerId', ownerId).eq('id', productMarketplace.idMarketplace).single();
      if (marketplaceResponse.isEmpty) return Left([GeneralFailure(customMessage: 'Mindestens ein Marktplatz kontte nicht geladen werden.')]);
      final marketplace = AbstractMarketplace.fromJson(marketplaceResponse);

      if (!marketplace.isActive) continue;

      if (product.isSetArticle) {
        switch (marketplace.marketplaceType) {
          case MarketplaceType.prestashop:
            {
              //* Alle Einzelartikel des Set-Artikel laden und in eine Liste speichern
              final productRepository = GetIt.I<ProductRepository>();
              final List<Product> listOfSetPartProducts = [];
              for (final partProductIdWithQuantity in product.listOfProductIdWithQuantity) {
                final fosPartProduct = await productRepository.getProduct(partProductIdWithQuantity.productId);
                if (fosPartProduct.isLeft()) {
                  failures.add(GeneralFailure(customMessage: fFEMpartOfSetProductNotFoundById(partProductIdWithQuantity.productId, product.name)));
                  continue;
                }

                final partProduct = fosPartProduct.getRight();
                listOfSetPartProducts.add(partProduct);
              }
              if (listOfSetPartProducts.isEmpty) {
                failures.add(GeneralFailure(customMessage: fFEMnoPartProductsFound()));
                continue;
              }

              final marketplaceProduct = productMarketplace.marketplaceProduct as ProductPresta;

              final result = await PrestashopRepositoryPatch(marketplace as MarketplacePresta).updateSetProductInMarketplace(
                product: product,
                listOfPartOfSetArticles: listOfSetPartProducts,
                productMarketplace: productMarketplace,
                marketplaceProductPrestaId: marketplaceProduct.id,
              );

              if (result.isLeft()) failures.add(result.getLeft());
            }
          case MarketplaceType.shopify:
            {
              final marketplaceProduct = productMarketplace.marketplaceProduct as ProductShopify;

              final result = await ShopifyRepositoryPut(marketplace as MarketplaceShopify).updateProductInMarketplace(
                productShopify: marketplaceProduct,
                product: product,
              );

              if (result.isLeft()) failures.addAll(result.getLeft());
            }
          case MarketplaceType.shop:
            throw Exception('Ladengeschäft kann keine Artikel haben.');
        }
      } else {
        switch (marketplace.marketplaceType) {
          case MarketplaceType.prestashop:
            {
              final marketplaceProduct = productMarketplace.marketplaceProduct as ProductPresta;

              final result = await PrestashopRepositoryPatch(marketplace as MarketplacePresta).updateProductInMarketplace(
                product: product,
                productMarketplace: productMarketplace,
                marketplaceProductPrestaId: marketplaceProduct.id,
              );

              if (result.isLeft()) failures.add(result.getLeft());
            }
          case MarketplaceType.shopify:
            {
              final marketplaceProduct = productMarketplace.marketplaceProduct as ProductShopify;

              final result = await ShopifyRepositoryPut(marketplace as MarketplaceShopify).updateProductInMarketplace(
                productShopify: marketplaceProduct,
                product: product,
              );

              if (result.isLeft()) failures.addAll(result.getLeft());
            }
          case MarketplaceType.shop:
            throw Exception('Ladengeschäft kann keine Artikel haben.');
        }
      }
      await setQuantityMPInAllProductMarketplaces(product, product.availableStock, null);
    }
    if (failures.isEmpty) return const Right(unit);
    return Left(failures);
  }

  @override
  Future<Either<AbstractFailure, ProductRawPresta>> createProdcutInMarketplace(
    Product product,
    ProductMarketplace productMarketplace,
    ProductMarketplace anotherProductMarketplaceWithSameManufacturer,
  ) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final marketplaceResponse =
        await supabase.from('d_marketplaces').select().eq('ownerId', ownerId).eq('id', productMarketplace.idMarketplace).single();
    if (marketplaceResponse.isEmpty) return Left(GeneralFailure(customMessage: 'Der Marktplatz kontte nicht geladen werden.'));
    final marketplace = MarketplacePresta.fromJson(marketplaceResponse);

    //* Erstellt den neuen Artikel in Prestashop und gibt die ID des erstellten Artikels zurück
    final fosIdOfCreatedProduct = await PrestashopRepositoryPost(marketplace).createNewProductInMarketplace(
      product: product,
      productMarketplace: productMarketplace,
      anotherProductMarketplaceWithSameManufacturer: anotherProductMarketplaceWithSameManufacturer,
    );

    if (fosIdOfCreatedProduct.isLeft()) return left(fosIdOfCreatedProduct.getLeft());
    final idOfCreatedProduct = fosIdOfCreatedProduct.getRight();

    await Future.delayed(const Duration(seconds: 1));

    final fosProductPresta = await PrestashopRepositoryGet(marketplace).getProduct(idOfCreatedProduct);
    if (fosProductPresta.isLeft()) {
      logger.e('Fehler beim Laden des Artikels aus Prestashop');
      return left(PrestaGeneralFailure(errorMessage: 'Fehler beim Laden der Artikels aus Prestashop'));
    }
    final productPresta = fosProductPresta.getRight();

    return Right(productPresta);
  }

  @override
  Future<Either<List<AbstractFailure>, Unit>> uploadProductImagesToMarketplace(Product product, List<ProductImage> productImages) async {
    if (!await checkInternetConnection()) return Left([NoConnectionFailure()]);
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left([GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden')]);

    final List<AbstractFailure> failures = [];

    for (ProductMarketplace productMarketplace in product.productMarketplaces) {
      final marketplaceRepository = GetIt.I<MarketplaceRepository>();
      final fosMarketplace = await marketplaceRepository.getMarketplace(productMarketplace.idMarketplace);

      if (fosMarketplace.isLeft()) {
        return Left([
          GeneralFailure(customMessage: 'Beim aktualisieren der Artikelbilder im Marktplatz konnte mindestens ein Marktplatz nicht geladen werden')
        ]);
      }
      final marketplace = fosMarketplace.getRight();

      if (!marketplace.isActive) continue;

      if (productMarketplace.marketplaceProduct == null) return left([ProductHasNoMarketplaceFailure()]);

      switch (marketplace.marketplaceType) {
        case MarketplaceType.prestashop:
          {
            final marketplaceProduct = productMarketplace.marketplaceProduct as ProductPresta;

            final fosProductPresta = await PrestashopRepositoryGet(marketplace as MarketplacePresta).getProduct(marketplaceProduct.id);
            if (fosProductPresta.isLeft()) {
              failures.add(PrestaGeneralFailure(
                  errorMessage: 'Artikel: "${marketplaceProduct.name}" konnte nicht vom Marktplatz: "${marketplace.name}" geladen werden.'));
              continue;
            }
            final productPresta = fosProductPresta.getRight();

            bool isSuccessOnDelete = false;
            if (productPresta.associations.associationsImages != null && productPresta.associations.associationsImages!.isNotEmpty) {
              for (final image in productPresta.associations.associationsImages!) {
                final response = await PrestashopRepositoryDelete(marketplace).deleteProductImage(productPresta.id.toString(), image.id);
                if (response.isRight()) isSuccessOnDelete = true;
              }
              if (!isSuccessOnDelete) {
                failures.add(
                  PrestaGeneralFailure(
                    errorMessage:
                        'Artikelbilder vom Artikel: "${marketplaceProduct.name}" im Marktplatz: "${marketplace.name}" konnten nicht gelöscht werden.',
                  ),
                );
              }
            }

            bool isSuccessOnCreate = false;
            if (productImages.isNotEmpty) {
              for (final image in productImages) {
                final response = await PrestashopRepositoryPost(marketplace).uploadProductImage(
                  productId: marketplaceProduct.id.toString(),
                  productImage: image,
                );
                if (response.isRight()) isSuccessOnCreate = true;
              }
              if (!isSuccessOnCreate) {
                failures.add(
                  PrestaGeneralFailure(
                    errorMessage:
                        'Artikelbilder vom Artikel: "${marketplaceProduct.name}" im Marktplatz: "${marketplace.name}" konnten nicht aktualisiert werden werden.',
                  ),
                );
              }
            }
          }
        case MarketplaceType.shopify:
          {
            final marketplaceProduct = productMarketplace.marketplaceProduct as ProductShopify;

            final fosDeleteImages = await ShopifyRepositoryDelete(marketplace as MarketplaceShopify).deleteProductImages(
              productId: marketplaceProduct.id,
            );
            if (fosDeleteImages.isLeft()) failures.addAll(fosDeleteImages.getLeft());

            final fosPostImages = await ShopifyRepositoryPost(marketplace).postProductImages(
              productId: marketplaceProduct.id,
              productName: product.name,
              productImages: productImages,
            );
            if (fosPostImages.isLeft()) failures.addAll(fosPostImages.getLeft());
          }
        case MarketplaceType.shop:
          throw Exception('Ladengeschäft kann keine Artikelbilder haben.');
      }
    }

    if (failures.isEmpty) return right(unit);
    return left(failures);
  }

  @override
  Future<Either<PrestaFailure, Unit>> setOrderStatusInMarketplace(
    AbstractMarketplace abstractMarketplace,
    int orderId,
    OrderStatusUpdateType orderStatusUpdateType,
    ParcelTracking? parcelTracking,
  ) async {
    if (!abstractMarketplace.isActive) return const Right(unit);
    if (orderId == 0) return right(unit);
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(PrestaGeneralFailure());

    switch (abstractMarketplace.marketplaceType) {
      case MarketplaceType.prestashop:
        {
          final marketplace = abstractMarketplace as MarketplacePresta;

          final statusId = switch (orderStatusUpdateType) {
            OrderStatusUpdateType.onImport => marketplace.marketplaceSettings.statusIdAfterImport,
            OrderStatusUpdateType.onShipping => marketplace.marketplaceSettings.statusIdAfterShipping,
            OrderStatusUpdateType.onCancel => marketplace.marketplaceSettings.statusIdAfterCancellation,
            OrderStatusUpdateType.onDelete => marketplace.marketplaceSettings.statusIdAfterDelete,
          };

          await PrestashopRepositoryPatch(marketplace).updateOrderStatusInMarketplace(orderId: orderId, statusId: statusId);
          return const Right(unit);
        }
      case MarketplaceType.shopify:
        {
          await ShopifyRepositoryPost(abstractMarketplace as MarketplaceShopify).updateOrderStatusInMarketplace(
            orderId: orderId,
            parcelTracking: parcelTracking,
          );
          // TODO: Error Handling or log

          return const Right(unit);
        }
      case MarketplaceType.shop:
        {
          throw Exception('SHOP not implemented');
        }
    }
  }
}
