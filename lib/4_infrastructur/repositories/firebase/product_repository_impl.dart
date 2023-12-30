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
import '../../../3_domain/repositories/firebase/marketplace_repository.dart';
import '../../../3_domain/repositories/firebase/product_repository.dart';
import '../../../3_domain/repositories/marketplace/marketplace_edit_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final FirebaseFirestore db;
  final FirebaseAuth firebaseAuth;
  final MarketplaceEditRepository marketplaceEditRepository;
  final MarketplaceRepository marketplaceRepository;

  const ProductRepositoryImpl({
    required this.db,
    required this.firebaseAuth,
    required this.marketplaceEditRepository,
    required this.marketplaceRepository,
  });

  @override
  Future<Either<FirebaseFailure, Product>> createProduct(Product product, ProductPresta? productPresta) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;

    try {
      final docRef = db.collection('Products').doc(currentUserUid).collection('Products').doc();

      Product toCreateProduct;
      //* Artikelbilder erstellen START

      if (productPresta != null && productPresta.imageFiles != null) {
        final firebaseStoragePath = '$currentUserUid/ProductImages/${docRef.id}';
        final List<ProductImage> listOfProductImages =
            await uploadImageFilesToStorageFromProductPrestaImage(productPresta.imageFiles, firebaseStoragePath);

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
    final docRef = db.collection('Products').doc(currentUserUid).collection('Products');

    try {
      final listOfProducts = await docRef.get().then(
            (value) => value.docs.map((querySnapshot) => Product.fromJson(querySnapshot.data())).toList(),
          );

      // for (final product in listOfProducts) {
      //   if (product.availableStock <= product.minimumReorderQuantity!) {
      //     final docRefPh = db.collection('Products').doc(currentUserUid).collection('Products').doc(product.id);
      //     final updatedProduct = product.copyWith(isUnderMinimumStock: true);
      //     await docRefPh.update(updatedProduct.toJson());
      //     await Future.delayed(const Duration(milliseconds: 200));
      //   }
      // }
      //********************************
      // List<Marketplace> marketplaces = [];
      // final fosMarketplaces = await marketplaceRepository.getListOfMarketplaces();
      // fosMarketplaces.fold(
      //   (failure) => left(GeneralFailure()),
      //   (listOfMarketplaces) => marketplaces.addAll(listOfMarketplaces),
      // );

      // int index = 1;
      // for (final product in listOfProducts) {
      //   logger.i('####################### Schleifendurchgang $index ###########################');
      //   final docRefPh = db.collection('Products').doc(currentUserUid).collection('Products').doc(product.id);
      //   List<ProductMarketplace> listOfProductMarketplaces = [];
      //   for (int i = 0; i < product.productMarketplaces.length; i++) {
      //     final marketplace = marketplaces.where((e) => e.id == product.productMarketplaces[i].idMarketplace).firstOrNull;
      //     if (marketplace == null) continue;
      //     final api = PrestashopApi(Client(), PrestashopApiConfig(apiKey: marketplace.key, webserviceUrl: marketplace.fullUrl));
      //     final optionalProductPresta = await api.getProduct(
      //       (product.productMarketplaces[i].marketplaceProduct as MarketplaceProductPresta).id,
      //       marketplace,
      //     );
      //     if (optionalProductPresta.isNotPresent) continue;
      //     final productPresta = optionalProductPresta.value;
      //     final productMarketplace = ProductMarketplace.fromProductPresta(productPresta, marketplace);
      //     listOfProductMarketplaces.add(productMarketplace);
      //   }
      //   final updatedProduct = product.copyWith(productMarketplaces: listOfProductMarketplaces);
      //   await docRefPh.update(updatedProduct.toJson());
      //   await Future.delayed(const Duration(milliseconds: 100));
      //   index++;
      // }

      if (listOfProducts.isEmpty) return left(EmptyFailure());
      return right(listOfProducts);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, List<Product>>> getListOfProductsByIds(List<String> productIds) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;

    List<Product> listOfProducts = [];

    try {
      for (final productId in productIds) {
        if (productId.isEmpty || productId.startsWith('00000')) continue;
        final docRef = db.collection('Products').doc(currentUserUid).collection('Products').doc(productId);
        final product = await docRef.get();
        if (product.exists) listOfProducts.add(Product.fromJson(product.data()!));
      }

      return right(listOfProducts);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, List<Product>>> getListOfSoldOutProducts() async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Products').doc(currentUserUid).collection('Products').where('availableStock', isEqualTo: 0);

    try {
      final listOfProducts = await docRef.get().then(
            (value) => value.docs.map((querySnapshot) => Product.fromJson(querySnapshot.data())).toList(),
          );

      return right(listOfProducts);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, List<Product>>> getListOfUnderMinimumQuantityProducts() async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Products').doc(currentUserUid).collection('Products').where('isUnderMinimumStock', isEqualTo: true);

    try {
      final listOfProducts = await docRef.get().then(
            (value) => value.docs.map((querySnapshot) => Product.fromJson(querySnapshot.data())).toList(),
          );

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
    final docRef = db.collection('Products').doc(currentUserUid).collection('Products').doc(id);

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
    final docRef = db.collection('Products').doc(currentUserUid).collection('Products').where('articleNumber', isEqualTo: articleNumber);

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
    final docRef = db.collection('Products').doc(currentUserUid).collection('Products').where('ean', isEqualTo: ean);

    try {
      final product = await docRef.get().then((value) => value.docs.map((docSs) => Product.fromJson(docSs.data())).toList().firstOrNull);
      if (product == null) return left(EmptyFailure());
      return right(product);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Product>> getProductByName(String name) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Products').doc(currentUserUid).collection('Products').where('name', isEqualTo: name);

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
      final docRef = db.collection('Products').doc(currentUserUid).collection('Products').doc(product.id);

      await docRef.update(product.toJson());

      return right(unit);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Product>> updateProductAddImages(Product product, List<File> imageFiles) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Products').doc(currentUserUid).collection('Products').doc(product.id);

    try {
      final firebaseStoragePath = '$currentUserUid/ProductImages/${docRef.id}';
      final List<ProductImage> listOfProductImages =
          await uploadImageFilesToStorageFromFlutter(product.listOfProductImages, imageFiles, firebaseStoragePath);

      final List<ProductImage> newListOfProductImages = List.from(product.listOfProductImages);
      newListOfProductImages.addAll(listOfProductImages);

      final updatedProduct = product.copyWith(listOfProductImages: newListOfProductImages);

      await docRef.update(updatedProduct.toJson());

      return right(updatedProduct);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Product>> updateProductRemoveImages(
    Product product,
    List<ProductImage> listOfProductImages,
  ) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Products').doc(currentUserUid).collection('Products').doc(product.id);

    final FirebaseStorage storage = FirebaseStorage.instance;

    try {
      final List<ProductImage> updatedListOfProductImages = List.from(product.listOfProductImages);
      for (final image in listOfProductImages) {
        final firebaseStoragePathToDelete = storage.refFromURL(image.fileUrl);
        await firebaseStoragePathToDelete.delete();
        updatedListOfProductImages.removeWhere((e) => e.fileUrl == image.fileUrl);
      }

      final List<ProductImage> newListOfProductImages = [];
      for (int i = 0; i < updatedListOfProductImages.length; i++) {
        final productImage = updatedListOfProductImages[i].copyWith(isDefault: i == 0 ? true : false, sortId: i + 1);
        newListOfProductImages.add(productImage);
      }

      final updatedProduct = product.copyWith(listOfProductImages: newListOfProductImages);

      await docRef.update(updatedProduct.toJson());

      return right(updatedProduct);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Unit>> deleteProduct(String id) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Products').doc(currentUserUid).collection('Products').doc(id);
    final FirebaseStorage storage = FirebaseStorage.instance;

    try {
      await db.runTransaction((transaction) async {
        final dsProduct = await transaction.get(docRef);
        if (!dsProduct.exists) return left(GeneralFailure());
        final product = Product.fromJson(dsProduct.data()!);
        final List<ProductImage> listOfProductImages = List.from(product.listOfProductImages);
        for (final image in listOfProductImages) {
          final firebaseStoragePathToDelete = storage.refFromURL(image.fileUrl);
          await firebaseStoragePathToDelete.delete();
        }
        await docRef.delete();
      });
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
        final docRef = db.collection('Products').doc(currentUserUid).collection('Products').doc(product.id);
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
    //       final docRef = db.collection('Products').doc(currentUserUid).collection('Products').doc(product.id);
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
  Future<Either<FirebaseFailure, Product>> updateAllQuantityOfProductAbsolut(Product product, int newQuantity) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRefProduct = db.collection('Products').doc(currentUserUid).collection('Products').doc(product.id);

    try {
      final updatedProduct = product.copyWith(
        availableStock: newQuantity,
        warehouseStock: product.warehouseStock - (product.availableStock - newQuantity),
        isUnderMinimumStock: newQuantity <= product.minimumReorderQuantity ? true : false,
      );
      await docRefProduct.update(updatedProduct.toJson());

      return right(updatedProduct);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Product>> updateAvailableQuantityOfProductAbsolut(Product product, int newQuantity) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRefProduct = db.collection('Products').doc(currentUserUid).collection('Products').doc(product.id);

    try {
      final updatedProduct = product.copyWith(
        availableStock: newQuantity,
        isUnderMinimumStock: newQuantity <= product.minimumReorderQuantity ? true : false,
      );
      await docRefProduct.update(updatedProduct.toJson());

      return right(updatedProduct);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Product>> updateWarehouseQuantityOfProductAbsolut(Product product, int newQuantity) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRefProduct = db.collection('Products').doc(currentUserUid).collection('Products').doc(product.id);

    try {
      final updatedProduct = product.copyWith(
        warehouseStock: product.warehouseStock - (product.warehouseStock - newQuantity),
        isUnderMinimumStock: product.availableStock <= product.minimumReorderQuantity ? true : false,
      );
      await docRefProduct.update(updatedProduct.toJson());

      return right(updatedProduct);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Product>> updateAvailableQuantityOfProductInremental(
    Product product,
    int newQuantityIncremental,
    Marketplace? marketplaceToSkip,
  ) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRefProduct = db.collection('Products').doc(currentUserUid).collection('Products').doc(product.id);

    try {
      final newAvailableStock = product.availableStock + newQuantityIncremental;
      final updatedProduct = product.copyWith(
        availableStock: newAvailableStock,
        isUnderMinimumStock: newAvailableStock <= product.minimumReorderQuantity ? true : false,
      );
      await docRefProduct.update(updatedProduct.toJson());

      await marketplaceEditRepository.setProdcutPrestaQuantity(updatedProduct, updatedProduct.availableStock, marketplaceToSkip);
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
    final docRefProduct = db.collection('Products').doc(currentUserUid).collection('Products').doc(product.id);

    try {
      final updatedProduct = product.copyWith(
        warehouseStock: product.warehouseStock + newQuantityIncremental,
        isUnderMinimumStock: product.availableStock <= product.minimumReorderQuantity ? true : false,
      );
      await docRefProduct.update(updatedProduct.toJson());

      return right(updatedProduct);
    } on FirebaseException {
      return left(GeneralFailure());
    }
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
