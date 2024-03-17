import 'package:cezeri_commerce/3_domain/entities/product/product.dart';
import 'package:cezeri_commerce/3_domain/entities/product/product_image.dart';
import 'package:cezeri_commerce/3_domain/enums/enums.dart';
import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:cezeri_commerce/core/presta_failure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

import '../../../../1_presentation/core/functions/check_internet_connection.dart';
import '../../../../3_domain/entities/product/product_marketplace.dart';
import '../../../../3_domain/repositories/marketplace/marketplace_edit_repository.dart';
import '../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../3_domain/entities/marketplace/marketplace_presta.dart';
import '../../../3_domain/entities/marketplace/marketplace_shopify.dart';
import '../../../3_domain/entities/patch_marketplace_logger.dart';
import '../../../3_domain/entities/product/product_presta.dart';
import '../../../core/abstract_failure.dart';
import '../prestashop_api/models/product_raw_presta.dart';
import '../prestashop_api/prestashop_api.dart';
import '../shopify_api/shopify.dart';

final logger = Logger();

class MarketplaceEditRepositoryImpl implements MarketplaceEditRepository {
  final FirebaseFirestore db;
  final FirebaseAuth firebaseAuth;

  MarketplaceEditRepositoryImpl({required this.db, required this.firebaseAuth});

  @override
  Future<Either<List<AbstractFailure>, Unit>> setQuantityMPInAllProductMarketplaces(
    Product product,
    int newQuantity,
    MarketplacePresta? marketplaceToSkip,
  ) async {
    if (!await checkInternetConnection()) return left([NoConnectionFailure()]);

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final List<AbstractFailure> failures = [];

    for (ProductMarketplace productMarketplace in product.productMarketplaces) {
      // TODO: if (!productMarketplace.active!) continue;
      if (marketplaceToSkip != null && productMarketplace.idMarketplace == marketplaceToSkip.id) continue;
      final docRef = db.collection('Marketetplaces').doc(currentUserUid).collection('Marketetplaces').doc(productMarketplace.idMarketplace);

      final marketplaceSnapshot = await docRef.get();
      final marketplace = AbstractMarketplace.fromJson(marketplaceSnapshot.data()!);
      // if (!marketplace.isActive) continue;

      if (productMarketplace.marketplaceProduct == null) return left([ProductHasNoMarketplaceFailure()]);
      Either<AbstractFailure, Unit>? fosAbstract;

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
            fosAbstract = fos;
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
            fosAbstract = fos;
          }

        case MarketplaceType.shop:
          throw Exception('Ladengeschäft kann keine Artikel zum aktualisieren des Bestandes haben.');
      }

      if (fosAbstract.isLeft()) {
        final patchMarketplaceLogger = PatchMarketplaceLogger.empty().copyWith(
          loggerType: LoggerType.product,
          loggerActionType: LoggerActionType.setStocks,
          marketplaceId: productMarketplace.idMarketplace,
          marketplaceName: productMarketplace.nameMarketplace,
          productId: product.id,
          productArticleNumber: product.articleNumber,
          productName: product.name,
          errorMessage: 'Beim aktualisieren des Bestandes ist ein Fehler aufgetreten. Funktion: setProdcutPrestaQuantity',
        );
        await createLogFile(db: db, firebaseAuth: firebaseAuth, patchMarketplaceLogger: patchMarketplaceLogger);
      }
    }

    if (failures.isEmpty) return right(unit);
    return left(failures);
  }

  @override
  Future<Either<List<AbstractFailure>, Unit>> editProdcutInMarketplace(Product product, List<MarketplacePresta>? toEditMarketplaces) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left([NoConnectionFailure()]);

    final currentUserUid = firebaseAuth.currentUser!.uid;

    final List<AbstractFailure> failures = [];

    for (final productMarketplace in product.productMarketplaces) {
      // TODO: if (!productMarketplace.active!) continue;
      //* Wenn "toEditMarketplaces" mitgegeben wird, dann sollen nur diese Marktplätze aktualisiert werden.
      if (toEditMarketplaces != null && !toEditMarketplaces.any((e) => e.id == productMarketplace.idMarketplace)) continue;

      final docRef = db.collection('Marketetplaces').doc(currentUserUid).collection('Marketetplaces').doc(productMarketplace.idMarketplace);

      final marketplaceSnapshot = await docRef.get();
      if (!marketplaceSnapshot.exists) {
        failures.add(GeneralFailure(customMessage: 'Mindestens ein Marktplatz kontte nicht geladen werden'));
        continue;
      }
      final marketplace = AbstractMarketplace.fromJson(marketplaceSnapshot.data()!);

      if (product.isSetArticle) {
        //* Alle Einzelartikel des Set-Artikel laden und in eine Liste speichern
        final List<Product> listOfSetPartProducts = [];
        for (final partProductIdWithQuantity in product.listOfProductIdWithQuantity) {
          final docRefPartProduct = db.collection('Products').doc(currentUserUid).collection('Products').doc(partProductIdWithQuantity.productId);
          final partProductDs = await docRefPartProduct.get();
          if (!partProductDs.exists) {
            failures.add(GeneralFailure(customMessage: fFEMpartOfSetProductNotFoundById(partProductIdWithQuantity.productId, product.name)));
            continue;
          }
          Product partProduct = Product.fromJson(partProductDs.data()!);
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
    if (failures.isEmpty) return right(unit);
    return left(failures);
  }

  @override
  Future<Either<PrestaFailure, ProductRawPresta>> createProdcutInMarketplace(
    Product product,
    ProductMarketplace productMarketplace,
    ProductMarketplace anotherProductMarketplaceWithSameManufacturer,
  ) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(PrestaGeneralFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;

    final docRef = db.collection('Marketetplaces').doc(currentUserUid).collection('Marketetplaces').doc(productMarketplace.idMarketplace);

    final marketplaceSnapshot = await docRef.get();
    final marketplace = MarketplacePresta.fromJson(marketplaceSnapshot.data()!);

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

    return right(productPresta);
  }

  @override
  Future<Either<List<AbstractFailure>, Unit>> uploadProductImagesToMarketplace(Product product, List<ProductImage> productImages) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left([NoConnectionFailure()]);

    final List<AbstractFailure> failures = [];

    final currentUserUid = firebaseAuth.currentUser!.uid;

    for (ProductMarketplace productMarketplace in product.productMarketplaces) {
      // TODO: if (!productMarketplace.active!) continue;
      final docRef = db.collection('Marketetplaces').doc(currentUserUid).collection('Marketetplaces').doc(productMarketplace.idMarketplace);

      final marketplaceSnapshot = await docRef.get();
      if (!marketplaceSnapshot.exists) {
        failures.add(PrestaGeneralFailure(
            errorMessage: 'Beim aktualisieren der Artikelbilder im Marktplatz konnte mindestens ein Marktplatz nicht geladen werden'));
        continue;
      }
      final marketplace = AbstractMarketplace.fromJson(marketplaceSnapshot.data()!);

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
    MarketplacePresta marketplace,
    int orderId,
    OrderStatusUpdateType orderStatusUpdateType,
  ) async {
    if (orderId == 0) return right(unit);
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(PrestaGeneralFailure());

    bool isSuccess = true;

    switch (marketplace.marketplaceType) {
      case MarketplaceType.prestashop:
        {
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
          throw Exception('SHOPIFY not implemented');
        }
      case MarketplaceType.shop:
        {
          throw Exception('SHOP not implemented');
        }
    }

    if (isSuccess) return right(unit);
    return left(PrestaGeneralFailure());
  }
}

Future<void> createLogFile({
  required FirebaseFirestore db,
  required FirebaseAuth firebaseAuth,
  required PatchMarketplaceLogger patchMarketplaceLogger,
}) async {
  final currentUserUid = firebaseAuth.currentUser!.uid;

  final docRef = db.collection('Logger').doc(currentUserUid).collection('Logger').doc();

  final newPatchMarketplaceLogger = patchMarketplaceLogger.copyWith(id: docRef.id, creationDate: DateTime.now());

  await docRef.set(newPatchMarketplaceLogger.toJson());
}
