import 'dart:io';

import 'package:cezeri_commerce/3_domain/entities/product/product_marketplace.dart';
import 'package:cezeri_commerce/3_domain/entities_presta/product_presta_image.dart';
import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';

import '../../../3_domain/entities/reorder/supplier.dart';
import '/1_presentation/core/functions/check_internet_connection.dart';
import '/3_domain/entities/marketplace/marketplace.dart';
import '/3_domain/entities/product/product.dart';
import '/3_domain/entities/product/product_image.dart';
import '/3_domain/entities_presta/product_presta.dart';
import '/3_domain/repositories/firebase/marketplace_repository.dart';
import '/3_domain/repositories/firebase/product_repository.dart';
import '/3_domain/repositories/marketplace/marketplace_edit_repository.dart';

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

      // int index = 1;
      // for (final product in listOfProducts) {
      //   print('####################### Schleifendurchgang $index ###########################');
      //   final docRefPh = db.collection('Products').doc(currentUserUid).collection('Products').doc(product.id);
      //   final updatedProduct = product.copyWith(
      //     isUnderMinimumStock: product.availableStock <= product.minimumStock ? true : false,
      //     listOfIsPartOfSetIds: [],
      //     listOfProductIdWithQuantity: [],
      //     isSetArticle: false,
      //   );
      //   await docRefPh.update(updatedProduct.toJson());
      //   await Future.delayed(const Duration(milliseconds: 200));
      //   index++;
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

      if (listOfProducts.isEmpty) return left(EmptyFailure());
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
    final docRef =
        db.collection('Products').doc(currentUserUid).collection('Products').where('isActive', isEqualTo: true).where('availableStock', isEqualTo: 0);

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
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Product>> updateProduct(Product product) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Products').doc(currentUserUid).collection('Products').doc(product.id);

    try {
      Product? updatedProduct;
      if (product.isSetArticle) {
        await db.runTransaction((transaction) async {
          final originalProductDs = await transaction.get(docRef);
          if (!originalProductDs.exists) return left(GeneralFailure());
          final originalProduct = Product.fromJson(originalProductDs.data()!);

          //* Alle Einzelartikel des Set-Artikel laden und in eine Liste speichern
          final listOfSetPartProducts = await getPartProductsOfSetProduct(
            db: db,
            currentUserUid: currentUserUid,
            transaction: transaction,
            setProduct: product,
          );
          if (listOfSetPartProducts == null) return left(GeneralFailure());

          //* Alle Einzelartikel, die nicht mehr Bestandteil des Set-Artikel sind identitfizieren und aus Einzelartikel das Set Entfernen
          final newPartArticleIds = listOfSetPartProducts.map((e) => e.id).toList();
          final originalPartArticleIds = originalProduct.listOfProductIdWithQuantity.map((e) => e.productId).toList();
          final noMorePartOfSetIds = [];
          for (final originalId in originalPartArticleIds) {
            if (!newPartArticleIds.any((e) => e == originalId)) {
              noMorePartOfSetIds.add(originalId);
            }
          }
          for (final noMorePartId in noMorePartOfSetIds) {
            final docRefNoMorePartOfSet = db.collection('Products').doc(currentUserUid).collection('Products').doc(noMorePartId);
            final noMorePartProductDs = await transaction.get(docRefNoMorePartOfSet);
            if (!noMorePartProductDs.exists) return left(GeneralFailure());
            Product noMorePartProduct = Product.fromJson(noMorePartProductDs.data()!);
            List<String> listOfIsPartOfSetIds = List.from(noMorePartProduct.listOfIsPartOfSetIds);
            final index = listOfIsPartOfSetIds.indexWhere((e) => e == product.id);
            if (index == -1) continue;
            listOfIsPartOfSetIds.removeAt(index);

            noMorePartProduct = noMorePartProduct.copyWith(listOfIsPartOfSetIds: listOfIsPartOfSetIds);
            transaction.update(docRefNoMorePartOfSet, noMorePartProduct.toJson());
          }

          //* Berechne Menge des Set-Artikels
          final quantitySetArticle = calcSetArticleAvailableQuantity(product, listOfSetPartProducts);

          //* Alle Einzelartikel, wo der Set-Artikel noch nicht eingetragen ist in Firestore updaten
          await addSetProductIdToPartProducts(
            db: db,
            currentUserUid: currentUserUid,
            transaction: transaction,
            setProduct: product,
            listOfSetPartProducts: listOfSetPartProducts,
          );

          //* Update Set-Article
          final difference = product.warehouseStock - product.availableStock;
          final setArticle = product.copyWith(availableStock: quantitySetArticle, warehouseStock: quantitySetArticle + difference);
          transaction.update(docRef, setArticle.toJson());
          updatedProduct = setArticle;
        });
        if (updatedProduct == null) return left(GeneralFailure());
        return right(updatedProduct!);
      } else {
        await docRef.update(product.toJson());

        return right(product);
      }
    } on FirebaseException catch (e) {
      logger.e(e);
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
    } on FirebaseException catch (e) {
      logger.e(e);
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
  Future<Either<FirebaseFailure, Product>> updateAllQuantityOfProductAbsolut(
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
        if (!loadedProductDS.exists) return left(GeneralFailure());
        final loadedProduct = Product.fromJson(loadedProductDS.data()!);

        updatedProduct = loadedProduct.copyWith(
          availableStock: newQuantity,
          warehouseStock: updateOnlyAvailableQuantity
              ? loadedProduct.warehouseStock
              : loadedProduct.warehouseStock - (loadedProduct.availableStock - newQuantity),
          isUnderMinimumStock: newQuantity <= loadedProduct.minimumStock ? true : false,
        );

        if (updatedProduct == null) return left(GeneralFailure());

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
        await marketplaceEditRepository.setProdcutPrestaQuantity(updatedSetProduct, updatedSetProduct.availableStock, null);
      }
      if (updatedProduct == null) return left(GeneralFailure());
      await marketplaceEditRepository.setProdcutPrestaQuantity(updatedProduct!, updatedProduct!.availableStock, null);
      return right(updatedProduct!);
    } on FirebaseException catch (e) {
      logger.e(e);
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
        await marketplaceEditRepository.setProdcutPrestaQuantity(updatedSetProduct, updatedSetProduct.availableStock, null);
      }

      if (updatedProduct == null) return left(GeneralFailure());
      await marketplaceEditRepository.setProdcutPrestaQuantity(updatedProduct!, updatedProduct!.availableStock, marketplaceToSkip);
      return right(updatedProduct!);
    } on FirebaseException {
      return left(GeneralFailure());
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
    } on FirebaseException {
      return left(GeneralFailure());
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
  if (listOfSetProducts == null) return Future.value(null);

  //* Bestand bei allen Set-Artikeln anpassen
  for (final setProduct in listOfSetProducts) {
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

    transaction.update(docRefSetProduct, updatedSetProduct.toJson());
    listOfUpdatedSetProducts.add(updatedSetProduct);
  }
  return listOfUpdatedSetProducts;
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

Future<List<Product>?> getSetProductsOfPartProduct(FirebaseFirestore db, String currentUserUid, Transaction transaction, Product product) async {
  final List<Product> listOfSetProducts = [];
  for (final setProductId in product.listOfIsPartOfSetIds) {
    final docRefSet = db.collection('Products').doc(currentUserUid).collection('Products').doc(setProductId);
    final setProductDS = await transaction.get(docRefSet);
    if (!setProductDS.exists) return Future.value(null);
    final setProduct = Product.fromJson(setProductDS.data()!);
    listOfSetProducts.add(setProduct);
  }
  return listOfSetProducts;
}

int calcSetArticleAvailableQuantity(Product setProduct, List<Product> listOfSetPartProducts) {
  final quantitySetArticle = setProduct.listOfProductIdWithQuantity.map((e) {
    final partProduct = listOfSetPartProducts.firstWhere((element) => element.id == e.productId);
    return partProduct.availableStock ~/ e.quantity;
  }).reduce((a, b) => a < b ? a : b);
  return quantitySetArticle;
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
