import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';

import '../../../1_presentation/core/functions/set_product_functions.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/repositories/firebase/product_repository.dart';
import '../../../core/abstract_failure.dart';
import '../../../core/firebase_failures.dart';

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
