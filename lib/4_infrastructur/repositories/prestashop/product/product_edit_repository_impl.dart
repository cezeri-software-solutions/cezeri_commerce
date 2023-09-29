import 'package:cezeri_commerce/3_domain/entities/product/product.dart';
import 'package:cezeri_commerce/core/presta_failure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';

import '../../../../1_presentation/core/functions/check_internet_connection.dart';
import '../../../../3_domain/entities/marketplace/marketplace.dart';
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

    for (ProductMarketplace productMarketplace in product.productMarketplaces) {
      print(product.toJson());
      // TODO: if (!productMarketplace.active!) continue;
      final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Marketetplaces').doc(productMarketplace.idMarketplace);

      final marketplaceSnapshot = await docRef.get();
      final marketplace = Marketplace.fromJson(marketplaceSnapshot.data()!);

      final api = PrestashopApi(Client(), PrestashopApiConfig(apiKey: marketplace.key, webserviceUrl: marketplace.fullUrl));

      final isSuccess = await api.patchProduct(productMarketplace.idProduct!, product, productMarketplace);
      if (isSuccess) return right(unit);
    }

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

      final isSuccess = await api.patchProductQuantity(productMarketplace.stockAvailables!.first.id!, newQuantity);
      if (isSuccess) return right(unit);
    }

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
