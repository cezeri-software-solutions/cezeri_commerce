import 'package:cezeri_commerce/3_domain/entities/product/product.dart';
import 'package:cezeri_commerce/3_domain/entities/product/product_image.dart';
import 'package:cezeri_commerce/3_domain/enums/enums.dart';
import 'package:cezeri_commerce/core/presta_failure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';

import '../../../../1_presentation/core/functions/check_internet_connection.dart';
import '../../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../../3_domain/entities/product/marketplace_product_presta.dart';
import '../../../../3_domain/entities/product/product_marketplace.dart';
import '../../../../3_domain/repositories/marketplace/marketplace_edit_repository.dart';
import '../../../3_domain/entities/patch_marketplace_logger.dart';
import '../../../3_domain/entities_presta/product_presta.dart';
import '../prestashop_api/prestashop_api.dart';

class MarketplaceEditRepositoryImpl implements MarketplaceEditRepository {
  final FirebaseFirestore db;
  final FirebaseAuth firebaseAuth;

  MarketplaceEditRepositoryImpl({required this.db, required this.firebaseAuth});

  @override
  Future<Either<PrestaFailure, Unit>> setProdcutPrestaQuantity(Product product, int newQuantity, Marketplace? marketplaceToSkip) async {
    if (product.isSetArticle) return right(unit);
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(PrestaGeneralFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    bool isAllSuccess = false;

    for (ProductMarketplace productMarketplace in product.productMarketplaces) {
      // TODO: if (!productMarketplace.active!) continue;
      if (marketplaceToSkip != null && productMarketplace.idMarketplace == marketplaceToSkip.id) continue;
      final docRef = db.collection('Marketetplaces').doc(currentUserUid).collection('Marketetplaces').doc(productMarketplace.idMarketplace);

      final marketplaceSnapshot = await docRef.get();
      final marketplace = Marketplace.fromJson(marketplaceSnapshot.data()!);
      if (!marketplace.isActive) continue;

      final api = PrestashopApi(Client(), PrestashopApiConfig(apiKey: marketplace.key, webserviceUrl: marketplace.fullUrl));

      if (productMarketplace.marketplaceProduct == null) return left(ProductHasNoMarketplaceFailure());
      final marketplaceProduct = switch (productMarketplace.marketplaceProduct!.marketplaceType) {
        MarketplaceType.prestashop => productMarketplace.marketplaceProduct as MarketplaceProductPresta,
        MarketplaceType.shop => throw Error(),
      };

      final isSuccess = await api.patchProductQuantity(marketplaceProduct.id, newQuantity, marketplace);
      if (isSuccess) {
        isAllSuccess = true;
      } else {
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

    if (isAllSuccess) return right(unit);
    return left(PrestaGeneralFailure());
  }

  @override
  Future<Either<PrestaFailure, Unit>> editProdcutPresta(Product product, List<Marketplace>? toEditMarketplaces) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(PrestaGeneralFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;

    bool isSuccess = true;

    for (final productMarketplace in product.productMarketplaces) {
      // TODO: if (!productMarketplace.active!) continue;
      //* Wenn "toEditMarketplaces" mitgegeben wird, dann sollen nur diese Marktplätze aktualisiert werden.
      if (toEditMarketplaces != null && !toEditMarketplaces.any((e) => e.id == productMarketplace.idMarketplace)) continue;

      final docRef = db.collection('Marketetplaces').doc(currentUserUid).collection('Marketetplaces').doc(productMarketplace.idMarketplace);

      final marketplaceSnapshot = await docRef.get();
      final marketplace = Marketplace.fromJson(marketplaceSnapshot.data()!);

      final api = PrestashopApi(Client(), PrestashopApiConfig(apiKey: marketplace.key, webserviceUrl: marketplace.fullUrl));

      final marketplaceProduct = productMarketplace.marketplaceProduct as MarketplaceProductPresta;
      isSuccess = await api.patchProduct(marketplaceProduct.id, product, productMarketplace, marketplace);
    }
    if (isSuccess) return right(unit);
    return left(PrestaGeneralFailure());
  }

  @override
  Future<Either<PrestaFailure, ProductPresta>> createProdcutPresta(
    Product product,
    ProductMarketplace productMarketplace,
    ProductMarketplace anotherProductMarketplaceWithSameManufacturer,
  ) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(PrestaGeneralFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;

    final docRef = db.collection('Marketetplaces').doc(currentUserUid).collection('Marketetplaces').doc(productMarketplace.idMarketplace);

    final marketplaceSnapshot = await docRef.get();
    final marketplace = Marketplace.fromJson(marketplaceSnapshot.data()!);

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
  Future<Either<PrestaFailure, Unit>> uploadProductImages(Product product, List<ProductImage> productImages) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(PrestaGeneralFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;

    bool isSuccess = true;
    for (ProductMarketplace productMarketplace in product.productMarketplaces) {
      // TODO: if (!productMarketplace.active!) continue;
      final docRef = db.collection('Marketetplaces').doc(currentUserUid).collection('Marketetplaces').doc(productMarketplace.idMarketplace);

      final marketplaceSnapshot = await docRef.get();
      if (!marketplaceSnapshot.exists) return left(PrestaGeneralFailure());
      final marketplace = Marketplace.fromJson(marketplaceSnapshot.data()!);

      final api = PrestashopApi(Client(), PrestashopApiConfig(apiKey: marketplace.key, webserviceUrl: marketplace.fullUrl));

      if (productMarketplace.marketplaceProduct == null) return left(ProductHasNoMarketplaceFailure());
      final marketplaceProduct = switch (productMarketplace.marketplaceProduct!.marketplaceType) {
        MarketplaceType.prestashop => productMarketplace.marketplaceProduct as MarketplaceProductPresta,
        MarketplaceType.shop => throw Error(),
      };

      final optionalProductPresta = await api.getProduct(marketplaceProduct.id, marketplace);
      if (optionalProductPresta.isNotPresent) return left(PrestaGeneralFailure());
      final productPresta = optionalProductPresta.value;

      bool isSuccessOnDelete = false;
      if (productPresta.associations.associationsImages != null && productPresta.associations.associationsImages!.isNotEmpty) {
        for (final image in productPresta.associations.associationsImages!) {
          isSuccessOnDelete = await api.deleteProductImage(productPresta.id.toString(), image.id);
        }
      } else {
        isSuccessOnDelete = true;
      }

      bool isSuccessOnCreate = false;
      if (productImages.isNotEmpty) {
        for (final image in productImages) {
          isSuccessOnCreate = await api.uploadProductImageFromUrl(marketplaceProduct.id.toString(), image);
        }
      } else {
        isSuccessOnCreate = true;
      }

      isSuccess = isSuccessOnDelete && isSuccessOnCreate;
    }

    if (isSuccess) return right(unit);
    return left(PrestaGeneralFailure());
  }

  @override
  Future<Either<PrestaFailure, Unit>> setOrderStatus(
    Marketplace marketplace,
    int orderId,
    OrderStatusUpdateType orderStatusUpdateType,
  ) async {
    if (orderId == 0) return right(unit);
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(PrestaGeneralFailure());

    bool isSuccess = true;

    if (marketplace.marketplaceType == MarketplaceType.prestashop) {
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
