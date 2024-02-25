import 'dart:io';

import 'package:cezeri_commerce/3_domain/entities/product/product_marketplace.dart';
import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

import '../../../1_presentation/core/functions/set_product_functions.dart';
import '../../../3_domain/entities/marketplace/marketplace_presta.dart';
import '../../../3_domain/entities/product/marketplace_product.dart';
import '../functions/product_repository_helper.dart';
import '/1_presentation/core/functions/check_internet_connection.dart';
import '/3_domain/entities/product/product.dart';
import '/3_domain/entities/product/product_image.dart';
import '/3_domain/entities/reorder/supplier.dart';
import '/3_domain/repositories/firebase/marketplace_repository.dart';
import '/3_domain/repositories/firebase/product_repository.dart';
import '/3_domain/repositories/marketplace/marketplace_edit_repository.dart';
import '/core/abstract_failure.dart';

final logger = Logger();

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
  Future<Either<FirebaseFailure, Product>> createProduct(Product product, MarketplaceProduct? marketplaceProduct) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;

    try {
      final docRef = db.collection('Products').doc(currentUserUid).collection('Products').doc();

      Product toCreateProduct;
      //* Artikelbilder erstellen START
      if (marketplaceProduct != null) {
        final listOfProductImages = await uploadImageFilesToStorageFromMarketplaceProduct(
          currentUserUid: currentUserUid,
          docRef: docRef,
          marketplaceProduct: marketplaceProduct,
        );

        toCreateProduct = product.copyWith(id: docRef.id, listOfProductImages: listOfProductImages);

        //* Artikelbilder erstellen ENDE
      } else {
        toCreateProduct = product.copyWith(id: docRef.id);
      }

      await docRef.set(toCreateProduct.toJson());

      return right(toCreateProduct);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Erstellen des Artikels ist ein Fehler aufgetreten.', e: e));
    }
  }

  @override
  Future<Either<FirebaseFailure, List<Product>>> getListOfProducts(bool onlyActive) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = switch (onlyActive) {
      false => db.collection('Products').doc(currentUserUid).collection('Products'),
      true => db.collection('Products').doc(currentUserUid).collection('Products').where('isActive', isEqualTo: true),
    };

    try {
      final listOfProducts = await docRef.get().then(
            (value) => value.docs.map((querySnapshot) => Product.fromJson(querySnapshot.data())).toList(),
          );

      return right(listOfProducts);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Laden der Artikel ist ein Fehler aufgetreten.', e: e));
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
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Laden der Artikel ist ein Fehler aufgetreten.', e: e));
    }
  }

  @override
  Future<Either<FirebaseFailure, List<Product>>> getListOfProductsBySupplierName({required bool onlyActive, required Supplier supplier}) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    print(supplier.name);

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = switch (onlyActive) {
      false => db.collection('Products').doc(currentUserUid).collection('Products').where('supplier', isEqualTo: supplier.company),
      true => db
          .collection('Products')
          .doc(currentUserUid)
          .collection('Products')
          .where('isActive', isEqualTo: true)
          .where('supplier', isEqualTo: supplier.company),
    };

    try {
      final listOfProducts = await docRef.get().then(
            (value) => value.docs.map((querySnapshot) => Product.fromJson(querySnapshot.data())).toList(),
          );

      return right(listOfProducts);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Laden der Artikel ist ein Fehler aufgetreten.', e: e));
    }
  }

  @override
  Future<Either<FirebaseFailure, List<Product>>> getListOfSoldOutProducts() async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef =
        db.collection('Products').doc(currentUserUid).collection('Products').where('isActive', isEqualTo: true).where('availableStock', isEqualTo: 0);

    try {
      final listOfProducts = await docRef.get().then(
            (value) => value.docs.map((querySnapshot) => Product.fromJson(querySnapshot.data())).toList(),
          );

      return right(listOfProducts);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Laden der ausverkauften Artikel ist ein Fehler aufgetreten.', e: e));
    }
  }

  @override
  Future<Either<FirebaseFailure, List<Product>>> getListOfUnderMinimumQuantityProducts() async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db
        .collection('Products')
        .doc(currentUserUid)
        .collection('Products')
        .where('isActive', isEqualTo: true)
        .where('isUnderMinimumStock', isEqualTo: true);

    try {
      final listOfProducts = await docRef.get().then(
            (value) => value.docs.map((querySnapshot) => Product.fromJson(querySnapshot.data())).toList(),
          );

      return right(listOfProducts);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Laden der Artikel, die unter dem Mindestbestand sind ist ein Fehler aufgetreten.', e: e));
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
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Laden des Artikels ist ein Fehler aufgetreten.', e: e));
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
      if (product == null) {
        return left(GeneralFailure(customMessage: 'In der Datenbank konnte kein Artikel mit der Artikelnummer: "$articleNumber" gefunden werden.'));
      }
      return right(product);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Laden des Artikels ist ein Fehler aufgetreten.', e: e));
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
      if (product == null) {
        return left(GeneralFailure(customMessage: 'In der Datenbank konnte kein Artikel mit der EAN: "$ean" gefunden werden.'));
      }
      return right(product);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Laden des Artikels ist ein Fehler aufgetreten.', e: e));
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
      if (product == null) {
        return left(GeneralFailure(customMessage: 'In der Datenbank konnte kein Artikel mit dem Namen: "$name" gefunden werden.'));
      }
      return right(product);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Laden des Artikels ist ein Fehler aufgetreten.', e: e));
    }
  }

  @override
  Future<Either<FirebaseFailure, Product>> getProductWithSameProductMarketplaceAndSameManufacturer(
    Product product,
    ProductMarketplace productMarketplace,
  ) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Products').doc(currentUserUid).collection('Products').where('manufacturer',
        isEqualTo: product.manufacturer); //.where('productMarketplaces.idMarketplace', whereIn: [productMarketplace.idMarketplace]);

    try {
      final products = await docRef.get().then((value) => value.docs.map((docSs) => Product.fromJson(docSs.data())).toList());
      if (products.isEmpty) return left(EmptyFailure());

      final productSameMarketplace =
          products.where((e) => e.productMarketplaces.any((f) => f.idMarketplace == productMarketplace.idMarketplace)).firstOrNull;
      if (productSameMarketplace == null) return left(GeneralFailure());

      return right(productSameMarketplace);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Laden des Artikels ist ein Fehler aufgetreten.', e: e));
    }
  }

  @override
  Future<Either<AbstractFailure, Product>> updateProduct(Product product) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Products').doc(currentUserUid).collection('Products').doc(product.id);

    try {
      docRef.update(product.toJson());

      return right(product);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Aktualisieren des Bestandes vom Artikel: "${product.name}" ist ein Fehler aufgetreten.', e: e));
    }
  }

  @override
  Future<Either<AbstractFailure, Product>> updateProductAndSets(Product product) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Products').doc(currentUserUid).collection('Products').doc(product.id);

    final fosOriginalProduct = await getProduct(product.id);
    Product? originalProduct;
    fosOriginalProduct.fold(
      (failure) => left(failure),
      (loadedProduct) => originalProduct = loadedProduct,
    );
    if (originalProduct == null) {
      final errorMessage = 'Der Artikel: "${product.name}" konnte nicht aus der Datenbank geladen werden.';
      return left(GeneralFailure(customMessage: errorMessage));
    }

    try {
      if (product.isSetArticle ||
          originalProduct!.isSetArticle && (product.listOfProductIdWithQuantity != originalProduct!.listOfProductIdWithQuantity)) {
        Either<AbstractFailure, Product>? fosHandleNewSetProduct;
        await db.runTransaction((transaction) async {
          //* Wenn der Artikel entweder davor ein Set-Artikel war oder jetzt ein Set-Artikel ist
          fosHandleNewSetProduct = await handleNewSetProduct(
            product: product,
            originalProduct: originalProduct!,
            db: db,
            currentUserUid: currentUserUid,
            transaction: transaction,
            docRef: docRef,
          );
        });
        if (fosHandleNewSetProduct == null) return left(GeneralFailure(customMessage: 'Ein Fehler ist aufgetreten'));
        Product? updatedSetProduct;
        AbstractFailure? abstractFailure;
        fosHandleNewSetProduct!.fold(
          (failure) => abstractFailure = failure,
          (setProduct) => updatedSetProduct = setProduct,
        );
        if (updatedSetProduct != null && fosHandleNewSetProduct!.isRight()) return right(updatedSetProduct!);
        if (abstractFailure != null && fosHandleNewSetProduct!.isLeft()) return left(abstractFailure!);
        return left(GeneralFailure(customMessage: 'Ein Fehler ist aufgetreten'));
      } else {
        await docRef.update(product.toJson());

        return right(product);
      }
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Aktualisieren des Artikels: "${product.name}" ist ein Fehler aufgetreten.', e: e));
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
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(
          GeneralFailure(customMessage: 'Beim Aktualisieren der Artikelbilder des Artikels: ${product.name} ist ein Fehler aufgetreten.', e: e));
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
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Löschen der Artikelbilder des Artikels: ${product.name} ist ein Fehler aufgetreten.', e: e));
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
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Löschen des Artikels ist ein Fehler aufgetreten.', e: e));
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
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Löschen des Artikel ist ein Fehler aufgetreten.', e: e));
    }
  }

  @override
  Future<Either<FirebaseFailure, Unit>> activateMarketplaceInSelectedProducts(List<Product> selectedProducts, MarketplacePresta marketplace) async {
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
  Future<Either<AbstractFailure, Product>> updateAllQuantityOfProductAbsolut(
    Product product,
    int newQuantity,
    bool updateOnlyAvailableQuantity,
  ) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Products').doc(currentUserUid).collection('Products').doc(product.id);

    try {
      Product? updatedProduct;
      List<Product> listOfUpdatedSetProducts = [];
      await db.runTransaction((transaction) async {
        final loadedProductDS = await transaction.get(docRef);
        if (!loadedProductDS.exists) {
          return left(GeneralFailure(customMessage: 'Der Artikel "${product.name}" konnte nicht aus der Datenbank geladen werden.'));
        }
        final loadedProduct = Product.fromJson(loadedProductDS.data()!);

        updatedProduct = loadedProduct.copyWith(
          availableStock: newQuantity,
          warehouseStock: updateOnlyAvailableQuantity
              ? loadedProduct.warehouseStock
              : loadedProduct.warehouseStock - (loadedProduct.availableStock - newQuantity),
          isUnderMinimumStock: newQuantity <= loadedProduct.minimumStock ? true : false,
        );

        if (updatedProduct == null) {
          return left(GeneralFailure(customMessage: 'Ein Fehler beim absoluten aktualiseren des Artikels "${product.name}" ist aufgetreten.'));
        }

        if (loadedProduct.listOfIsPartOfSetIds.isNotEmpty) {
          final updatedSetProducts = await updateQuantityOfSetProducts(
            db: db,
            currentUserUid: currentUserUid,
            transaction: transaction,
            product: updatedProduct!,
          );

          listOfUpdatedSetProducts.addAll(updatedSetProducts!);
        }

        transaction.update(docRef, updatedProduct!.toJson());
      });

      for (final updatedSetProduct in listOfUpdatedSetProducts) {
        await marketplaceEditRepository.setQuantityMPInAllProductMarketplaces(updatedSetProduct, updatedSetProduct.availableStock, null);
      }
      if (updatedProduct == null) return left(GeneralFailure());
      await marketplaceEditRepository.setQuantityMPInAllProductMarketplaces(updatedProduct!, updatedProduct!.availableStock, null);
      return right(updatedProduct!);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Aktualisieren des Bestandes vom Artikel: "${product.name}" ist ein Fehler aufgetreten.', e: e));
    }
  }

  @override
  Future<Either<AbstractFailure, Product>> updateAvailableQuantityOfProductInremental(
    Product product,
    int newQuantityIncremental,
    MarketplacePresta? marketplaceToSkip,
  ) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRefProduct = db.collection('Products').doc(currentUserUid).collection('Products').doc(product.id);

    try {
      Product? updatedProduct;
      List<Product> listOfUpdatedSetProducts = [];
      await db.runTransaction((transaction) async {
        final newAvailableStock = product.availableStock + newQuantityIncremental;
        updatedProduct = product.copyWith(
          availableStock: newAvailableStock,
          isUnderMinimumStock: newAvailableStock <= product.minimumStock ? true : false,
        );

        if (updatedProduct == null) return left(GeneralFailure());

        if (product.listOfIsPartOfSetIds.isNotEmpty) {
          final updatedSetProducts = await updateQuantityOfSetProducts(
            db: db,
            currentUserUid: currentUserUid,
            transaction: transaction,
            product: updatedProduct!,
          );

          listOfUpdatedSetProducts.addAll(updatedSetProducts!);
        }

        transaction.update(docRefProduct, updatedProduct!.toJson());
      });

      for (final updatedSetProduct in listOfUpdatedSetProducts) {
        await marketplaceEditRepository.setQuantityMPInAllProductMarketplaces(updatedSetProduct, updatedSetProduct.availableStock, null);
      }

      if (updatedProduct == null) return left(GeneralFailure());
      await marketplaceEditRepository.setQuantityMPInAllProductMarketplaces(updatedProduct!, updatedProduct!.availableStock, marketplaceToSkip);
      return right(updatedProduct!);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(
        customMessage: 'Beim inkrementellen Aktualisieren des Bestandes vom Artikel: "${product.name}" ist ein Fehler aufgetreten',
        e: e,
      ));
    }
  }

  @override
  Future<Either<FirebaseFailure, Product>> updateWarehouseQuantityOfNewProductOnImportIncremental(Product product, int newQuantityIncremental) async {
    //! Wenn diese Funktion bearbeitet wird muss auch die Funktion (receipt_repository_impl)(updateProductWarehouseQuantityIncremental) geupdatet werden
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRefProduct = db.collection('Products').doc(currentUserUid).collection('Products').doc(product.id);

    try {
      final updatedProduct = product.copyWith(
        warehouseStock: product.warehouseStock + newQuantityIncremental,
        isUnderMinimumStock: product.availableStock <= product.minimumStock ? true : false,
      );
      await docRefProduct.update(updatedProduct.toJson());

      return right(updatedProduct);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(
        customMessage: 'Beim inkrementellen Aktualisieren des  Lagerbestandes vom Artikel: "${product.name}" ist ein Fehler aufgetreten',
        e: e,
      ));
    }
  }
}

Future<List<Product>?> updateQuantityOfSetProducts({
  required FirebaseFirestore db,
  required String currentUserUid,
  required Transaction transaction,
  required Product product,
}) async {
  List<Product> listOfUpdatedSetProducts = [];
  //* Set-Artikel laden, wo dieser Artikel ein Bestandteil ist
  final listOfSetProducts = await getSetProductsOfPartProduct(db, currentUserUid, transaction, product);

  //* Bestand bei allen Set-Artikeln anpassen
  for (final setProduct in listOfSetProducts!) {
    final docRefSetProduct = db.collection('Products').doc(currentUserUid).collection('Products').doc(setProduct.id);
    final listOfSetPartProducts = await getPartProductsOfSetProduct(
      db: db,
      currentUserUid: currentUserUid,
      transaction: transaction,
      setProduct: setProduct,
      alreadyLoadedPartProduct: product,
    );
    if (listOfSetPartProducts == null) return Future.value(null);

    final quantitySetArticle = calcSetArticleAvailableQuantity(setProduct, listOfSetPartProducts);
    final difference = setProduct.warehouseStock - setProduct.availableStock;
    final updatedSetProduct = setProduct.copyWith(availableStock: quantitySetArticle, warehouseStock: quantitySetArticle + difference);

    //TODO: Transactions require all reads to be executed before all writes. transaction.update(docRefSetProduct, updatedSetProduct.toJson());
    await docRefSetProduct.update(updatedSetProduct.toJson());
    listOfUpdatedSetProducts.add(updatedSetProduct);
  }
  return listOfUpdatedSetProducts;
}

Future<List<Product>?> getSetProductsOfPartProduct(FirebaseFirestore db, String currentUserUid, Transaction transaction, Product product) async {
  final List<Product> listOfSetProducts = [];
  for (final setProductId in product.listOfIsPartOfSetIds) {
    final docRefSet = db.collection('Products').doc(currentUserUid).collection('Products').doc(setProductId);
    final setProductDS = await transaction.get(docRefSet);
    //* Wenn die Liste einen null Wert enthält, wird das Programm nicht unterbrochen, aber es kann ein Fehler geworfen werden, dass es mindestens bei einem Set-Artikel nicht geklappt hat.
    if (!setProductDS.exists) {
      // listOfSetProducts.add(null);
      return Future.value(null);
    } else {
      final setProduct = Product.fromJson(setProductDS.data()!);
      listOfSetProducts.add(setProduct);
    }
  }
  return listOfSetProducts;
}
