import 'package:cezeri_commerce/3_domain/entities/product/product.dart';
import 'package:cezeri_commerce/3_domain/entities/product/product_image.dart';
import 'package:cezeri_commerce/core/presta_failure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';

import '../../../../1_presentation/core/functions/check_internet_connection.dart';
import '../../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../../3_domain/entities/product/marketplace_product_presta.dart';
import '../../../../3_domain/entities/product/product_marketplace.dart';
import '../../../../3_domain/repositories/prestashop/product/product_edit_repository.dart';
import '../../prestashop_api/prestashop_api.dart';

class ProductEditRepositoryImpl implements ProductEditRepository {
  final FirebaseFirestore db;
  final FirebaseAuth firebaseAuth;

  ProductEditRepositoryImpl({required this.db, required this.firebaseAuth});

  @override
  Future<Either<PrestaFailure, Unit>> editProdcutPresta(Product product) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(PrestaGeneralFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;

    bool isSuccess = true;

    for (final productMarketplace in product.productMarketplaces) {
      print(product.toJson());
      // TODO: if (!productMarketplace.active!) continue;
      final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Marketetplaces').doc(productMarketplace.idMarketplace);

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
  Future<Either<PrestaFailure, Unit>> setProdcutPrestaQuantity(Product product, int newQuantity) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(PrestaGeneralFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;

    for (ProductMarketplace productMarketplace in product.productMarketplaces) {
      // TODO: if (!productMarketplace.active!) continue;
      final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Marketetplaces').doc(productMarketplace.idMarketplace);

      final marketplaceSnapshot = await docRef.get();
      final marketplace = Marketplace.fromJson(marketplaceSnapshot.data()!);

      final api = PrestashopApi(Client(), PrestashopApiConfig(apiKey: marketplace.key, webserviceUrl: marketplace.fullUrl));

      if (productMarketplace.marketplaceProduct == null) return left(ProductHasNoMarketplaceFailure());
      final marketplaceProduct = switch (productMarketplace.marketplaceProduct!.marketplaceType) {
        MarketplaceType.prestashop => productMarketplace.marketplaceProduct as MarketplaceProductPresta,
        _ => throw Error(),
      };

      final isSuccess = await api.patchProductQuantity(marketplaceProduct.id, newQuantity, marketplace);
      if (isSuccess) return right(unit);
    }

    return left(PrestaGeneralFailure());
  }

  @override
  Future<Either<PrestaFailure, Unit>> uploadProductImages(Product product, List<ProductImage> productImages) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(PrestaGeneralFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;

    bool isSuccess = true;
    for (ProductMarketplace productMarketplace in product.productMarketplaces) {
      // TODO: if (!productMarketplace.active!) continue;
      final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Marketetplaces').doc(productMarketplace.idMarketplace);

      final marketplaceSnapshot = await docRef.get();
      if (!marketplaceSnapshot.exists) return left(PrestaGeneralFailure());
      final marketplace = Marketplace.fromJson(marketplaceSnapshot.data()!);

      final api = PrestashopApi(Client(), PrestashopApiConfig(apiKey: marketplace.key, webserviceUrl: marketplace.fullUrl));

      if (productMarketplace.marketplaceProduct == null) return left(ProductHasNoMarketplaceFailure());
      final marketplaceProduct = switch (productMarketplace.marketplaceProduct!.marketplaceType) {
        MarketplaceType.prestashop => productMarketplace.marketplaceProduct as MarketplaceProductPresta,
        _ => throw Error(),
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
          isSuccessOnCreate = await api.uploadProductImageFromUrl(marketplaceProduct.id.toString(), image.fileUrl);
        }
      } else {
        isSuccessOnCreate = true;
      }

      isSuccess = isSuccessOnDelete && isSuccessOnCreate;
    }

    if (isSuccess) return right(unit);
    return left(PrestaGeneralFailure());
  }

  // void updateXmlElementText(XmlElement element, String newText) {
  //   final cdataNode = element.children.whereType<XmlCDATA>().firstOrNull;
  //   if (cdataNode != null) cdataNode.text = newText;
  // }

  // void updateXmlElementCDATAContent(XmlElement element, String newText) {
  //   // Finden Sie den CDATA-Knoten innerhalb des Elements
  //   final cdataNode = element.children.whereType<XmlCDATA>().firstOrNull;

  //   if (cdataNode != null) {
  //     // Ersetzen Sie den Inhalt des CDATA-Knotens
  //     cdataNode.text = newText;
  //   }
  // }
}
