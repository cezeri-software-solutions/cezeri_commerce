import 'package:dartz/dartz.dart';
import 'package:http/http.dart';

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
import '../functions/repository_functions.dart';
import '../prestashop_api/models/product_raw_presta.dart';
import '../prestashop_api/prestashop_api.dart';
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
            final api = PrestashopApi(
              Client(),
              PrestashopApiConfig(apiKey: (marketplace as MarketplacePresta).key, webserviceUrl: marketplace.fullUrl),
            );
            final marketplaceProduct = productMarketplace.marketplaceProduct as ProductPresta;
            final fos = await api.patchProductQuantity(marketplaceProduct.id, newQuantity, marketplace);
            fos.fold(
              (failure) => failures.add(failure),
              (unit) => null,
            );
          }
        case MarketplaceType.shopify:
          {
            final api = ShopifyApi(
              ShopifyApiConfig(storefrontToken: (marketplace as MarketplaceShopify).storefrontAccessToken, adminToken: marketplace.adminAccessToken),
              marketplace.fullUrl,
            );
            final marketplaceProduct = productMarketplace.marketplaceProduct as ProductShopify;
            final fos = await api.postProductStock(marketplaceProduct.id, newQuantity);
            fos.fold(
              (failure) => failures.add(failure),
              (unit) => null,
            );
          }

        case MarketplaceType.shop:
          throw Exception('Ladengeschäft kann keine Artikel zum aktualisieren des Bestandes haben.');
      }

      // if (fosAbstract.isLeft()) {
      //   final patchMarketplaceLogger = PatchMarketplaceLogger.empty().copyWith(
      //     loggerType: LoggerType.product,
      //     loggerActionType: LoggerActionType.setStocks,
      //     marketplaceId: productMarketplace.idMarketplace,
      //     marketplaceName: productMarketplace.nameMarketplace,
      //     productId: product.id,
      //     productArticleNumber: product.articleNumber,
      //     productName: product.name,
      //     errorMessage: 'Beim aktualisieren des Bestandes ist ein Fehler aufgetreten. Funktion: setProdcutPrestaQuantity',
      //   );
      //   await createLogFile(db: db, firebaseAuth: firebaseAuth, patchMarketplaceLogger: patchMarketplaceLogger);
      // }
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
        //* Alle Einzelartikel des Set-Artikel laden und in eine Liste speichern
        final List<Product> listOfSetPartProducts = [];
        for (final partProductIdWithQuantity in product.listOfProductIdWithQuantity) {
          final partProductResponse =
              await supabase.from('d_products').select().eq('ownerId', ownerId).eq('id', partProductIdWithQuantity.productId).single();
          if (partProductResponse.isEmpty) {
            failures.add(GeneralFailure(customMessage: fFEMpartOfSetProductNotFoundById(partProductIdWithQuantity.productId, product.name)));
            continue;
          }

          Product partProduct = Product.fromJson(partProductResponse);
          listOfSetPartProducts.add(partProduct);
        }
        if (listOfSetPartProducts.isEmpty) {
          failures.add(GeneralFailure(customMessage: fFEMnoPartProductsFound()));
          continue;
        }
        switch (marketplace.marketplaceType) {
          case MarketplaceType.prestashop:
            {
              final api = PrestashopApi(
                Client(),
                PrestashopApiConfig(apiKey: (marketplace as MarketplacePresta).key, webserviceUrl: marketplace.fullUrl),
              );
              final marketplaceProduct = productMarketplace.marketplaceProduct as ProductPresta;
              final fos = await api.patchSetProduct(
                marketplaceProduct.id,
                product,
                listOfSetPartProducts,
                productMarketplace,
                marketplace,
              );
              fos.fold(
                (failure) => failures.add(failure),
                (unit) => null,
              );
            }
          case MarketplaceType.shopify:
            {
              final api = ShopifyApi(
                ShopifyApiConfig(
                  storefrontToken: (marketplace as MarketplaceShopify).storefrontAccessToken,
                  adminToken: marketplace.adminAccessToken,
                ),
                marketplace.fullUrl,
              );
              final marketplaceProduct = productMarketplace.marketplaceProduct as ProductShopify;
              final fos = await api.putProduct(marketplaceProduct, product);
              fos.fold(
                (failure) => failures.addAll(failure),
                (unit) => null,
              );
            }
          case MarketplaceType.shop:
            throw Exception('Ladengeschäft kann keine Artikel haben.');
        }
      } else {
        switch (marketplace.marketplaceType) {
          case MarketplaceType.prestashop:
            {
              final api = PrestashopApi(
                Client(),
                PrestashopApiConfig(apiKey: (marketplace as MarketplacePresta).key, webserviceUrl: marketplace.fullUrl),
              );
              final marketplaceProduct = productMarketplace.marketplaceProduct as ProductPresta;
              final fos = await api.patchProduct(marketplaceProduct.id, product, productMarketplace, marketplace);
              fos.fold(
                (failure) => failures.add(failure),
                (unit) => null,
              );
            }
          case MarketplaceType.shopify:
            {
              final api = ShopifyApi(
                ShopifyApiConfig(
                  storefrontToken: (marketplace as MarketplaceShopify).storefrontAccessToken,
                  adminToken: marketplace.adminAccessToken,
                ),
                marketplace.fullUrl,
              );
              final marketplaceProduct = productMarketplace.marketplaceProduct as ProductShopify;
              final fos = await api.putProduct(marketplaceProduct, product);
              fos.fold(
                (failure) => failures.addAll(failure),
                (unit) => null,
              );
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

    final api = PrestashopApi(Client(), PrestashopApiConfig(apiKey: marketplace.key, webserviceUrl: marketplace.fullUrl));
    //* Erstellt den neuen Artikel in Prestashop und gibt die ID des erstellten Artikels zurück
    final idOfCreatedProduct = await api.postProduct(product, productMarketplace, anotherProductMarketplaceWithSameManufacturer, marketplace);

    if (idOfCreatedProduct == 0) return left(PrestaGeneralFailure());

    await Future.delayed(const Duration(seconds: 1));

    final optionalProductPresta = await api.getProduct(idOfCreatedProduct, marketplace);
    if (optionalProductPresta.isNotPresent) {
      logger.e('Fehler beim Laden des Artikels aus Prestashop');
      return left(PrestaGeneralFailure(errorMessage: 'Fehler beim Laden der Artikels aus Prestashop'));
    }
    final productPresta = optionalProductPresta.value;

    return Right(productPresta);
  }

  @override
  Future<Either<List<AbstractFailure>, Unit>> uploadProductImagesToMarketplace(Product product, List<ProductImage> productImages) async {
    if (!await checkInternetConnection()) return Left([NoConnectionFailure()]);
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left([GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden')]);

    final List<AbstractFailure> failures = [];

    for (ProductMarketplace productMarketplace in product.productMarketplaces) {
      final marketplaceResponse =
          await supabase.from('d_marketplaces').select().eq('ownerId', ownerId).eq('id', productMarketplace.idMarketplace).single();
      if (marketplaceResponse.isEmpty) {
        return Left([
          GeneralFailure(customMessage: 'Beim aktualisieren der Artikelbilder im Marktplatz konnte mindestens ein Marktplatz nicht geladen werden')
        ]);
      }
      final marketplace = AbstractMarketplace.fromJson(marketplaceResponse);

      if (!marketplace.isActive) continue;

      if (productMarketplace.marketplaceProduct == null) return left([ProductHasNoMarketplaceFailure()]);

      switch (marketplace.marketplaceType) {
        case MarketplaceType.prestashop:
          {
            final api = PrestashopApi(
              Client(),
              PrestashopApiConfig(apiKey: (marketplace as MarketplacePresta).key, webserviceUrl: marketplace.fullUrl),
            );
            final marketplaceProduct = productMarketplace.marketplaceProduct as ProductPresta;

            final optionalProductPresta = await api.getProduct(marketplaceProduct.id, marketplace);
            if (optionalProductPresta.isNotPresent) {
              failures.add(PrestaGeneralFailure(
                  errorMessage: 'Artikel: "${marketplaceProduct.name}" konnte nicht vom Marktplatz: "${marketplace.name}" geladen werden.'));
              continue;
            }
            final productPresta = optionalProductPresta.value;

            bool isSuccessOnDelete = false;
            if (productPresta.associations.associationsImages != null && productPresta.associations.associationsImages!.isNotEmpty) {
              for (final image in productPresta.associations.associationsImages!) {
                isSuccessOnDelete = await api.deleteProductImage(productPresta.id.toString(), image.id);
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
                isSuccessOnCreate = await api.uploadProductImageFromUrl(marketplaceProduct.id.toString(), image);
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
            final api = ShopifyApi(
              ShopifyApiConfig(
                storefrontToken: (marketplace as MarketplaceShopify).storefrontAccessToken,
                adminToken: marketplace.adminAccessToken,
              ),
              marketplace.fullUrl,
            );
            final marketplaceProduct = productMarketplace.marketplaceProduct as ProductShopify;
            final fosDeleteImages = await api.deleteProductImages(marketplaceProduct.id);
            fosDeleteImages.fold(
              (deleteFailures) => failures.addAll(deleteFailures),
              (_) => null,
            );

            final fosPostImages = await api.postProductImages(marketplaceProduct.id, product.name, productImages);
            fosPostImages.fold(
              (postFailures) => failures.addAll(postFailures),
              (_) => null,
            );
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

    bool isSuccess = true;

    switch (abstractMarketplace.marketplaceType) {
      case MarketplaceType.prestashop:
        {
          final marketplace = abstractMarketplace as MarketplacePresta;
          final api = PrestashopApi(Client(), PrestashopApiConfig(apiKey: marketplace.key, webserviceUrl: marketplace.fullUrl));

          final statusId = switch (orderStatusUpdateType) {
            OrderStatusUpdateType.onImport => marketplace.marketplaceSettings.statusIdAfterImport,
            OrderStatusUpdateType.onShipping => marketplace.marketplaceSettings.statusIdAfterShipping,
            OrderStatusUpdateType.onCancel => marketplace.marketplaceSettings.statusIdAfterCancellation,
            OrderStatusUpdateType.onDelete => marketplace.marketplaceSettings.statusIdAfterDelete,
          };

          isSuccess = await api.patchOrderStatus(orderId, statusId, marketplace.isPresta8);
          if (isSuccess) return right(unit);
        }
      case MarketplaceType.shopify:
        {
          final mp = abstractMarketplace as MarketplaceShopify;
          final api = ShopifyApi(ShopifyApiConfig(storefrontToken: mp.storefrontAccessToken, adminToken: mp.adminAccessToken), mp.fullUrl);

          final result = await api.postFulfillment(orderId, parcelTracking);
          if (result.isRight()) return const Right(unit);
          return const Right(unit);
          // TODO: Error Handling or log
        }
      case MarketplaceType.shop:
        {
          throw Exception('SHOP not implemented');
        }
    }

    if (isSuccess) return const Right(unit);
    return Left(PrestaGeneralFailure());
  }
}

// Future<void> createLogFile({
//   required FirebaseFirestore db,
//   required FirebaseAuth firebaseAuth,
//   required PatchMarketplaceLogger patchMarketplaceLogger,
// }) async {
//   final currentUserUid = firebaseAuth.currentUser!.uid;

//   final docRef = db.collection('Logger').doc(currentUserUid).collection('Logger').doc();

//   final newPatchMarketplaceLogger = patchMarketplaceLogger.copyWith(id: docRef.id, creationDate: DateTime.now());

//   await docRef.set(newPatchMarketplaceLogger.toJson());
// }
