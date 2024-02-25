import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../prestashop_api/models/models.dart';
import '../shopify_api/shopify.dart';
import '/1_presentation/core/functions/set_product_functions.dart';
import '/3_domain/entities/marketplace/abstract_marketplace.dart';
import '/3_domain/entities/product/marketplace_product.dart';
import '/3_domain/entities/product/product.dart';
import '/3_domain/entities/product/product_image.dart';
import '/3_domain/entities/product/product_presta.dart';
import '/3_domain/repositories/firebase/product_repository.dart';
import '/core/abstract_failure.dart';
import '/core/firebase_failures.dart';

Future<Either<AbstractFailure, Product>> handleNewSetProduct({
  required Product product,
  required Product originalProduct,
  required FirebaseFirestore db,
  required String currentUserUid,
  required Transaction transaction,
  required DocumentReference<Map<String, dynamic>> docRef,
}) async {
  //* Alle Einzelartikel des Set-Artikel laden und in eine Liste speichern
  final listOfSetPartProducts = await getPartProductsOfSetProduct(
    db: db,
    currentUserUid: currentUserUid,
    transaction: transaction,
    setProduct: product,
  );
  if (listOfSetPartProducts == null) {
    final errorMessage = 'Beim Aktualisieren des Artikels: "${product.name}" konnte mindestens ein Einzelartikel nicht geladen werden.';
    return left(GeneralFailure(customMessage: errorMessage));
  }

  //* Alle Einzelartikel, die nicht mehr Bestandteil des Set-Artikel sind identitfizieren
  final noMorePartOfSetIds = identifyNoMorePartOfSetProducts(
    listOfSetPartProducts: listOfSetPartProducts,
    originalProduct: originalProduct,
  );
  //* Alle Einzelartikel, die nicht mehr Bestandteil des Set-Artikel sind aus dem Set-Artikel Entfernen
  final fosRemovePartProducts = await removePartProductsFromSet(
    noMorePartOfSetIds: noMorePartOfSetIds,
    currentUserUid: currentUserUid,
    product: product,
    db: db,
    transaction: transaction,
  );
  fosRemovePartProducts.fold(
    (failure) => left(failure),
    (r) => null,
  );

  //* Alle Einzelartikel, wo der Set-Artikel noch nicht eingetragen ist in Firestore updaten
  await addSetProductIdToPartProducts(
    db: db,
    currentUserUid: currentUserUid,
    transaction: transaction,
    setProduct: product,
    listOfSetPartProducts: listOfSetPartProducts,
  );

  if (product.isSetArticle) {
    //* Berechne Menge des Set-Artikels
    final quantitySetArticle = calcSetArticleAvailableQuantity(product, listOfSetPartProducts);

    //* Update Set-Article
    final difference = product.warehouseStock - product.availableStock;
    final setArticle = product.copyWith(availableStock: quantitySetArticle, warehouseStock: quantitySetArticle + difference);
    transaction.update(docRef, setArticle.toJson());
    return right(setArticle);
  } else {
    transaction.update(docRef, product.toJson());
    return right(product);
  }
}

List<String> identifyNoMorePartOfSetProducts({
  required List<Product> listOfSetPartProducts,
  required Product? originalProduct,
}) {
  if (originalProduct == null) return [];

  final newPartArticleIds = listOfSetPartProducts.map((e) => e.id).toList();
  final originalPartArticleIds = originalProduct.listOfProductIdWithQuantity.map((e) => e.productId).toList();
  final noMorePartOfSetIds = <String>[];

  for (final originalId in originalPartArticleIds) {
    if (!newPartArticleIds.any((e) => e == originalId)) {
      noMorePartOfSetIds.add(originalId);
    }
  }

  return noMorePartOfSetIds;
}

Future<Either<AbstractFailure, Unit>> removePartProductsFromSet({
  required List<String> noMorePartOfSetIds,
  required String currentUserUid,
  required Product product,
  required FirebaseFirestore db,
  required Transaction transaction,
}) async {
  for (final noMorePartId in noMorePartOfSetIds) {
    final docRefNoMorePartOfSet = db.collection('Products').doc(currentUserUid).collection('Products').doc(noMorePartId);
    Product? noMorePartProduct;
    final fosNoMorePartProduct = await GetIt.I.get<ProductRepository>().getProduct(noMorePartId);
    fosNoMorePartProduct.fold(
      (failure) => left(failure),
      (loadedProduct) => noMorePartProduct = loadedProduct,
    );

    final index = noMorePartProduct!.listOfIsPartOfSetIds.indexWhere((e) => e == product.id);
    if (index == -1) continue;

    noMorePartProduct!.listOfIsPartOfSetIds.removeAt(index);
    transaction.update(docRefNoMorePartOfSet, noMorePartProduct!.toJson());
  }

  return right(unit);
}

Future<List<Product>?> getPartProductsOfSetProduct({
  required FirebaseFirestore db,
  required String currentUserUid,
  required Transaction transaction,
  required Product setProduct,
  Product? alreadyLoadedPartProduct,
}) async {
  final List<Product> listOfSetPartProducts = [];
  for (final partProductIdWithQuantity in setProduct.listOfProductIdWithQuantity) {
    if (alreadyLoadedPartProduct != null && partProductIdWithQuantity.productId == alreadyLoadedPartProduct.id) {
      listOfSetPartProducts.add(alreadyLoadedPartProduct);
      continue;
    }
    final docRefPartProduct = db.collection('Products').doc(currentUserUid).collection('Products').doc(partProductIdWithQuantity.productId);
    final partProductDs = await transaction.get(docRefPartProduct);
    if (!partProductDs.exists) return Future.value(null);
    Product partProduct = Product.fromJson(partProductDs.data()!);
    listOfSetPartProducts.add(partProduct);
  }
  return listOfSetPartProducts;
}

Future<void> addSetProductIdToPartProducts({
  required FirebaseFirestore db,
  required String currentUserUid,
  required Transaction? transaction,
  required Product setProduct,
  required List<Product> listOfSetPartProducts,
}) async {
  for (final partOfSetProduct in listOfSetPartProducts) {
    final docRefUpdatedPartProduct = db.collection('Products').doc(currentUserUid).collection('Products').doc(partOfSetProduct.id);
    if (partOfSetProduct.listOfIsPartOfSetIds.any((e) => e == setProduct.id)) continue;
    final updatedProduct = partOfSetProduct.copyWith(listOfIsPartOfSetIds: partOfSetProduct.listOfIsPartOfSetIds..add(setProduct.id));
    if (transaction != null) {
      transaction.update(docRefUpdatedPartProduct, updatedProduct.toJson());
    } else {
      docRefUpdatedPartProduct.update(updatedProduct.toJson());
    }
  }
}

Future<List<ProductImage>?> uploadImageFilesToStorageFromMarketplaceProduct({
  required String currentUserUid,
  required DocumentReference<Map<String, dynamic>> docRef,
  required MarketplaceProduct marketplaceProduct,
}) async {
  final firebaseStoragePath = '$currentUserUid/ProductImages/${docRef.id}';

  switch (marketplaceProduct.marketplaceType) {
    case MarketplaceType.prestashop:
      {
        final productPresta = marketplaceProduct as ProductPresta;
        if (productPresta.imageFiles == null) return null;

        final List<ProductImage> listOfProductImages =
            await uploadImageFilesToStorageFromProductPrestaImage(productPresta.imageFiles, firebaseStoragePath);
        return listOfProductImages;
      }
    case MarketplaceType.shopify:
      {
        final productShopify = marketplaceProduct as ProductShopify;
        if (productShopify.images.isEmpty) return null;

        final List<ProductImage> listOfProductImages = await uploadImageFilesToStorageFromProductShopify(productShopify.images, firebaseStoragePath);
        return listOfProductImages;
      }
    case MarketplaceType.shop:
      throw Exception('Aus einem Ladengeschäft können keine Artikelbilder importieret werden.');
  }
}

Future<List<ProductImage>> uploadImageFilesToStorageFromProductPrestaImage(List<ProductPrestaImage?>? imageFiles, String firebaseStoragePath) async {
  final FirebaseStorage storage = FirebaseStorage.instance;

  final List<ProductImage> listOfProductImages = [];

  int sortId = 0;

  for (final myFile in imageFiles!) {
    if (myFile == null) continue;

    sortId++;

    final File file = myFile.imageFile;
    // Erstelle einen eindeutigen Dateinamen, um Kollisionen zu vermeiden
    final fileName = basename(file.path);
    // Erstelle einen Verweis auf den Firebase Cloud Storage-Pfad, an dem das Bild gespeichert werden soll
    final Reference firebaseStorageRef = storage.ref().child('$firebaseStoragePath/$fileName');
    // Erstelle einen Byte-Datenstrom aus der Datei
    final bytes = await file.readAsBytes();
    // Lade die Byte-Daten in Firebase Cloud Storage hoch
    await firebaseStorageRef.putData(bytes);
    // Speichere die URL des hochgeladenen Bildes in Firestore
    final String fileUrl = await firebaseStorageRef.getDownloadURL();
    final imageFile = ProductImage.empty().copyWith(
      fileName: fileName,
      fileUrl: fileUrl,
      sortId: sortId,
      isDefault: sortId == 1 ? true : false,
    );
    listOfProductImages.add(imageFile);
  }
  return listOfProductImages;
}

Future<List<ProductImage>> uploadImageFilesToStorageFromProductShopify(
    List<ProductImageShopify> productImagesShopify, String firebaseStoragePath) async {
  final FirebaseStorage storage = FirebaseStorage.instance;

  final List<ProductImage> listOfProductImages = [];
  final List<File> imageFiles = [];

  for (final shopifyImage in productImagesShopify) {
    // HTTP-Anfrage, um die Bilddaten als Bytes zu erhalten
    final response = await http.get(Uri.parse(shopifyImage.src));
    if (response.statusCode == 200) {
      // Erhalten des temporären Verzeichnisses
      final directory = await getTemporaryDirectory();
      // Erstellen eines Dateipfads im temporären Verzeichnis
      final filePath = '${directory.path}/product_${shopifyImage.id}_${shopifyImage.productId}.jpg';
      // Datei mit den Bilddaten erstellen
      final file = File(filePath);

      // Schreiben der Byte-Daten in die Datei und Rückgabe der Datei
      final imageFile = await file.writeAsBytes(response.bodyBytes);
      imageFiles.add(imageFile);
    }
  }

  int sortId = 0;

  for (final myFile in imageFiles) {
    sortId++;

    // Erstelle einen eindeutigen Dateinamen, um Kollisionen zu vermeiden
    final fileName = basename(myFile.path);
    // Erstelle einen Verweis auf den Firebase Cloud Storage-Pfad, an dem das Bild gespeichert werden soll
    final Reference firebaseStorageRef = storage.ref().child('$firebaseStoragePath/$fileName');
    // Erstelle einen Byte-Datenstrom aus der Datei
    final bytes = await myFile.readAsBytes();
    // Lade die Byte-Daten in Firebase Cloud Storage hoch
    await firebaseStorageRef.putData(bytes);
    // Speichere die URL des hochgeladenen Bildes in Firestore
    final String fileUrl = await firebaseStorageRef.getDownloadURL();
    final imageFile = ProductImage.empty().copyWith(
      fileName: fileName,
      fileUrl: fileUrl,
      sortId: sortId,
      isDefault: sortId == 1 ? true : false,
    );
    listOfProductImages.add(imageFile);
  }
  return listOfProductImages;
}

Future<List<ProductImage>> uploadImageFilesToStorageFromFlutter(
  List<ProductImage> listOfProductImages,
  List<File> imageFiles,
  String firebaseStoragePath,
) async {
  final FirebaseStorage storage = FirebaseStorage.instance;

  final List<ProductImage> newListOfProductImages = [];

  int sortId = listOfProductImages.length;

  for (final myFile in imageFiles) {
    sortId++;

    final File file = myFile;
    // Erstelle einen eindeutigen Dateinamen, um Kollisionen zu vermeiden
    final fileName = basename(file.path);
    // Erstelle einen Verweis auf den Firebase Cloud Storage-Pfad, an dem das Bild gespeichert werden soll
    final Reference firebaseStorageRef = storage.ref().child('$firebaseStoragePath/$fileName');
    // Erstelle einen Byte-Datenstrom aus der Datei
    final bytes = await file.readAsBytes();
    // Lade die Byte-Daten in Firebase Cloud Storage hoch
    await firebaseStorageRef.putData(bytes);
    // Speichere die URL des hochgeladenen Bildes in Firestore
    final String fileUrl = await firebaseStorageRef.getDownloadURL();
    final imageFile = ProductImage.empty().copyWith(
      fileName: fileName,
      fileUrl: fileUrl,
      sortId: sortId,
      isDefault: listOfProductImages.isEmpty && sortId == 1 ? true : false,
    );
    newListOfProductImages.add(imageFile);
  }
  return newListOfProductImages;
}
