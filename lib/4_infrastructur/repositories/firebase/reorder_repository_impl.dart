import 'package:cezeri_commerce/3_domain/entities/product/booking_product.dart';
import 'package:cezeri_commerce/3_domain/entities/reorder/reorder.dart';
import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../1_presentation/core/functions/check_internet_connection.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/entities/reorder/reorder_product.dart';
import '../../../3_domain/enums/enums.dart';
import '../../../3_domain/repositories/firebase/reorder_repository.dart';
import '../../../3_domain/repositories/marketplace/marketplace_edit_repository.dart';

class ReorderRepositoryImpl implements ReorderRepository {
  final FirebaseFirestore db;
  final FirebaseAuth firebaseAuth;
  final MarketplaceEditRepository marketplaceEditRepository;

  ReorderRepositoryImpl({required this.db, required this.firebaseAuth, required this.marketplaceEditRepository});

  @override
  Future<Either<FirebaseFailure, Reorder>> createReorder(Reorder reorder) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Reorders').doc(currentUserUid).collection('Reorders').doc();
    final docRefSettings = db.collection('Settings').doc(currentUserUid).collection('Settings').doc(currentUserUid);

    try {
      Reorder toCreateReorder = reorder.copyWith(id: docRef.id);
      await docRef.set(toCreateReorder.toJson());

      await docRefSettings.update({'nextReorderNumber': FieldValue.increment(1)});

      return right(toCreateReorder);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Reorder>> getReorder(String id) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Reorders').doc(currentUserUid).collection('Reorders').doc(id);

    try {
      final reorder = await docRef.get();
      return right(Reorder.fromJson(reorder.data()!));
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, List<Reorder>>> getListOfReorders(GetReordersType getReordersType) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = switch (getReordersType) {
      GetReordersType.open =>
        db.collection('Reorders').doc(currentUserUid).collection('Reorders').where('reorderStatus', isEqualTo: ReorderStatus.open.name),
      GetReordersType.partialOpen =>
        db.collection('Reorders').doc(currentUserUid).collection('Reorders').where('reorderStatus', isEqualTo: ReorderStatus.partiallyCompleted.name),
      GetReordersType.openOrPartialOpen => db.collection('Reorders').doc(currentUserUid).collection('Reorders').where('reorderStatus', whereIn: [
          ReorderStatus.open.name,
          ReorderStatus.partiallyCompleted.name,
        ]),
      GetReordersType.completed =>
        db.collection('Reorders').doc(currentUserUid).collection('Reorders').where('reorderStatus', isEqualTo: ReorderStatus.completed.name),
      GetReordersType.all => db.collection('Reorders').doc(currentUserUid).collection('Reorders'),
    };

    try {
      final listOfReorders = await docRef.get().then((value) => value.docs.map((querySnapshot) => Reorder.fromJson(querySnapshot.data())).toList());
      print('Repository');
      print(listOfReorders.length);

      if (listOfReorders.isEmpty) return left(EmptyFailure());
      return right(listOfReorders);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Reorder>> updateReorder(Reorder reorder) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Reorders').doc(currentUserUid).collection('Reorders').doc(reorder.id);

    try {
      await docRef.update(reorder.toJson());

      return right(reorder);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Unit>> deleteReorder(String id) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Reorders').doc(currentUserUid).collection('Reorders').doc(id);

    try {
      await docRef.delete();

      return right(unit);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Unit>> deleteReorders(List<String> ids) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;

    try {
      for (final id in ids) {
        final docRef = db.collection('Reorders').doc(currentUserUid).collection('Reorders').doc(id);
        await docRef.delete();
      }

      return right(unit);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Unit>> updateReordersFromProductsBooking(List<BookingProduct> listOfBookingProducts) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;

    Reorder? curReorder;
    Product? updatedProduct;

    listOfBookingProducts.sort((a, b) => a.id.compareTo(b.id));

    try {
      for (final bookingProduct in listOfBookingProducts) {
        final docRefReorder = db.collection('Reorders').doc(currentUserUid).collection('Reorders').doc(bookingProduct.reorderId);
        final docRefProduct = db.collection('Products').doc(currentUserUid).collection('Products').doc(bookingProduct.productId);
        await db.runTransaction((transaction) async {
          if (curReorder == null || (curReorder != null && bookingProduct.reorderId != curReorder!.id)) {
            final loadedReorderDs = await transaction.get(docRefReorder);
            if (!loadedReorderDs.exists) return left(GeneralFailure());
            curReorder = Reorder.fromJson(loadedReorderDs.data()!);
          }
          final loadedProductDs = await transaction.get(docRefProduct);
          if (!loadedProductDs.exists) return left(GeneralFailure());
          final loadedProduct = Product.fromJson(loadedProductDs.data()!);

          //* Update Reorder
          List<ReorderProduct> listOfReorderProducts = List.from(curReorder!.listOfReorderProducts);
          final index = listOfReorderProducts.indexWhere((e) => e.productId == bookingProduct.productId);
          if (index == -1) return left(GeneralFailure());
          listOfReorderProducts[index] =
              listOfReorderProducts[index].copyWith(bookedQuantity: listOfReorderProducts[index].bookedQuantity + bookingProduct.toBookQuantity);
          final isReorderCompleted = listOfReorderProducts.every((e) => e.openQuantity <= 0);
          final updatedReorder = curReorder!.copyWith(
            listOfReorderProducts: listOfReorderProducts,
            reorderStatus: isReorderCompleted ? ReorderStatus.completed : ReorderStatus.partiallyCompleted,
          );
          transaction.update(docRefReorder, updatedReorder.toJson());
          curReorder = updatedReorder;

          //* Update Product
          updatedProduct = loadedProduct.copyWith(
            availableStock: loadedProduct.availableStock + bookingProduct.toBookQuantity,
            warehouseStock: loadedProduct.warehouseStock + bookingProduct.toBookQuantity,
          );
          transaction.update(docRefProduct, updatedProduct!.toJson());
        });

        //* Update Product Quantity in Marketplaces
        if (updatedProduct == null) return left(GeneralFailure());
        await marketplaceEditRepository.setProdcutPrestaQuantity(updatedProduct!, updatedProduct!.availableStock, null);
      }
      return right(unit);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }
}
