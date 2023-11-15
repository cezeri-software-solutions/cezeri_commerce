import 'dart:io';

import 'package:cezeri_commerce/3_domain/entities_presta/product_presta_image.dart';
import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import '../../../1_presentation/core/functions/check_internet_connection.dart';
import '../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/entities/product/product_image.dart';
import '../../../3_domain/entities_presta/product_presta.dart';
import '../../../3_domain/repositories/firebase/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final FirebaseFirestore db;
  final FirebaseAuth firebaseAuth;

  const ProductRepositoryImpl({required this.db, required this.firebaseAuth});

  @override
  Future<Either<FirebaseFailure, Product>> createProduct(Product product, ProductPresta? productPresta) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;

    try {
      final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Products').doc();

      Product toCreateProduct;
      //* Artikelbilder erstellen START

      if (productPresta != null && productPresta.imageFiles != null) {
        final firebaseStoragePath = '$currentUserUid/ProductImages/${docRef.id}';
        final List<ProductImage> listOfProductImages = await uploadImageFilesToStorage(productPresta.imageFiles, firebaseStoragePath);

        toCreateProduct = product.copyWith(id: docRef.id, listOfProductImages: listOfProductImages);

        //* Artikelbilder erstellen ENDE
      } else {
        toCreateProduct = product.copyWith(id: docRef.id);
      }

      await docRef.set(toCreateProduct.toJson());

      return right(toCreateProduct);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, List<Product>>> getListOfProducts() async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Products');

    try {
      final listOfProducts = await docRef.get().then(
            (value) => value.docs.map((querySnapshot) => Product.fromJson(querySnapshot.data())).toList(),
          );

      if (listOfProducts.isEmpty) return left(EmptyFailure());
      return right(listOfProducts);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Product>> getProduct(String id) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Products').doc(id);

    try {
      final product = await docRef.get();
      return right(Product.fromJson(product.data()!));
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Product>> getProductByArticleNumber(String articleNumber) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Products').where('articleNumber', isEqualTo: articleNumber);

    try {
      final product = await docRef.get().then((value) => value.docs.map((docSs) => Product.fromJson(docSs.data())).toList().firstOrNull);
      if (product == null) return left(EmptyFailure());
      return right(product);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Product>> getProductByEan(String ean) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Products').where('ean', isEqualTo: ean);

    try {
      final product = await docRef.get().then((value) => value.docs.map((docSs) => Product.fromJson(docSs.data())).toList().firstOrNull);
      if (product == null) return left(EmptyFailure());
      return right(product);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Unit>> updateProduct(Product product) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;

    try {
      final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Products').doc(product.id);

      await docRef.update(product.toJson());

      return right(unit);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Unit>> deleteProduct(String id) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;

    try {
      final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Products').doc(id);

      await docRef.delete();

      return right(unit);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Unit>> deleteListOfProducts(List<Product> products) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;

    try {
      for (final product in products) {
        final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Products').doc(product.id);
        await docRef.delete();

        //* Delete product images from FirebaseStorage
        for (final url in product.listOfProductImages.map((e) => e.fileUrl).toList()) {
          final firebaseStoragePath = FirebaseStorage.instance.refFromURL(url);
          await firebaseStoragePath.delete();
        }
      }

      return right(unit);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Unit>> activateMarketplaceInSelectedProducts(List<Product> selectedProducts, Marketplace marketplace) async {
    // final isConnected = await checkInternetConnection();
    // if (!isConnected) return left(NoConnectionFailure());

    // final currentUserUid = firebaseAuth.currentUser!.uid;

    // try {
    //   final prestaLanguages = await getMarketplaceLanguages(marketplace);
    //   if (prestaLanguages == null) return left(GeneralFailure());

    //   for (final product in selectedProducts) {
    //     final uri = '${marketplace.fullUrl}products/?filter[reference]=[${product.articleNumber}]&display=full';
    //     // final uri = '${marketplace.fullUrl}products/?filter[reference]=[${product.articleNumber}]&output_format=JSON&display=full';
    //     // final uri = '${marketplace.fullUrl}products/?filter[reference]=[EL-1420313]&output_format=JSON&display=full';
    //     // final uri = '${marketplace.fullUrl}languages/?output_format=JSON&display=full';
    //     // final uri = '${marketplace.fullUrl}languages/?display=full';
    //     final response = await http.get(
    //       Uri.parse(uri),
    //       headers: {'Authorization': 'Basic ${base64Encode(utf8.encode('${marketplace.key}:'))}'},
    //     );

    //     final responseBody = XmlDocument.parse(response.body);
    //     final isProductInMarketplace = responseBody.findAllElements('products').first;
    //     if (isProductInMarketplace.children.whereType<XmlElement>().isEmpty) continue;

    //     if (response.statusCode == 200) {
    //       final productDocument = XmlDocument.parse(response.body);
    //       final productPresta = ProductPrestaOld.fromXml(productDocument, prestaLanguages);
    //       final productMarketplace = ProductMarketplace.fromProductPresta(productPresta, marketplace);
    //       List<ProductMarketplace> productMarketplaces = List.from(product.productMarketplaces);
    //       if (!productMarketplaces.any((e) => e.idMarketplace == productMarketplace.idMarketplace)) {
    //         productMarketplaces.add(productMarketplace);
    //       }
    //       final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Products').doc(product.id);
    //       final updatedProdukt = product.copyWith(productMarketplaces: productMarketplaces);
    //       await docRef.update(updatedProdukt.toJson());
    //     }
    //   }
    //   return right(unit);
    // } on FirebaseException {
    //   return left(GeneralFailure());
    // }
    throw UnimplementedError();
  }

  @override
  Future<Either<FirebaseFailure, Product>> updateQuantityOfProductAbsolut(Product product, int newQuantity) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRefProduct = db.collection(currentUserUid).doc(currentUserUid).collection('Products').doc(product.id);

    try {
      final updatedProduct = product.copyWith(
        availableStock: product.availableStock - (product.availableStock - newQuantity),
        warehouseStock: product.warehouseStock - (product.warehouseStock - newQuantity),
      );
      await docRefProduct.update(updatedProduct.toJson());

      return right(updatedProduct);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Product>> updateAvailableQuantityOfProductInremental(Product product, int newQuantityIncremental) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRefProduct = db.collection(currentUserUid).doc(currentUserUid).collection('Products').doc(product.id);

    try {
      final updatedProduct = product.copyWith(availableStock: product.availableStock + newQuantityIncremental);
      await docRefProduct.update(updatedProduct.toJson());

      return right(updatedProduct);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Product>> updateWarehouseQuantityOfProductIncremental(Product product, int newQuantityIncremental) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRefProduct = db.collection(currentUserUid).doc(currentUserUid).collection('Products').doc(product.id);

    try {
      final updatedProduct = product.copyWith(warehouseStock: product.warehouseStock + newQuantityIncremental);
      await docRefProduct.update(updatedProduct.toJson());

      return right(updatedProduct);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }
}

Future<List<ProductImage>> uploadImageFilesToStorage(List<ProductPrestaImage?>? imageFiles, String firebaseStoragePath) async {
  final FirebaseStorage storage = FirebaseStorage.instance;

  final List<String> fileUrls = [];
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
    fileUrls.add(fileUrl);
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
