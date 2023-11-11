import 'package:cezeri_commerce/3_domain/entities/picklist/picklist.dart';
import 'package:cezeri_commerce/3_domain/entities/product/product.dart';
import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../1_presentation/core/functions/check_internet_connection.dart';
import '../../../3_domain/entities/picklist/picklist_product.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../3_domain/repositories/firebase/packing_station_repository.dart';

class PackingStationRepositoryImpl implements PackingStationRepository {
  final FirebaseFirestore db;
  final FirebaseAuth firebaseAuth;

  PackingStationRepositoryImpl({required this.db, required this.firebaseAuth});

  @override
  Future<Either<FirebaseFailure, List<Product>>> getListOfProducts(List<String> productIds) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final colRef = db.collection(currentUserUid).doc(currentUserUid).collection('Products');

    List<Product> listOfProducts = [];

    try {
      for (final productId in productIds) {
        final docRef = colRef.doc(productId);
        final productSnapshot = await docRef.get();
        if (productSnapshot.data() != null) listOfProducts.add(Product.fromJson(productSnapshot.data()!));
      }

      if (listOfProducts.isEmpty) return left(EmptyFailure());
      return right(listOfProducts);
    } on FirebaseException {
      return left(GeneralFailure());
    } catch (_) {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Picklist>> createPicklist(List<Receipt> listOfAppointments) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Picklists').doc();
    final picklist = Picklist.fromListOfAppointments(listOfAppointments);
    final phToCreatePicklist = picklist.copyWith(id: docRef.id);

    final productIds = phToCreatePicklist.listOfPicklistProducts.map((e) => e.productId).toList();
    final uniqueProductIds = productIds.toSet().where((id) => id.isNotEmpty).toList();

    // Funktion zum Aufteilen der Liste
    List<List<T>> splitList<T>(List<T> list, int chunkSize) {
      List<List<T>> chunks = [];
      for (int i = 0; i < list.length; i += chunkSize) {
        int end = (i + chunkSize < list.length) ? i + chunkSize : list.length;
        chunks.add(list.sublist(i, end));
      }
      return chunks;
    }

    // Teilen der Liste in Teillisten mit maximal 30 Einträgen
    List<List<String>> splitProductIds = splitList(uniqueProductIds, 30);

    try {
      List<Product> products = [];
      for (var idsChunk in splitProductIds) {
        var chunkProducts = await db
            .collection(currentUserUid)
            .doc(currentUserUid)
            .collection('Products')
            .where('id', whereIn: idsChunk)
            .get()
            .then((value) => value.docs.map((docSs) => Product.fromJson(docSs.data())).toList());
        products.addAll(chunkProducts);
      }

      List<PicklistProduct> listOfPicklistProducts = [];
      for (final picklistProduct in picklist.listOfPicklistProducts) {
        final product = products.where((e) => e.id == picklistProduct.productId).firstOrNull;
        if (product == null) {
          listOfPicklistProducts.add(picklistProduct);
        } else {
          final updatedPicklistProduct = picklistProduct.copyWith(imageUrl: product.listOfProductImages.where((e) => e.isDefault).first.fileUrl);
          listOfPicklistProducts.add(updatedPicklistProduct);
        }
      }
      final toCreatePicklist = phToCreatePicklist.copyWith(listOfPicklistProducts: listOfPicklistProducts);

      await db.runTransaction((transaction) async {
        for (final appointment in listOfAppointments) {
          final updatedAppointment = appointment.copyWith(isPicked: true);
          final docRefAppointment = db.collection(currentUserUid).doc(currentUserUid).collection('Appointments').doc(appointment.id);
          transaction.update(docRefAppointment, updatedAppointment.toJson());
        }
        transaction.set(docRef, toCreatePicklist.toJson());
      });

      return right(toCreatePicklist);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Unit>> updatePicklist(Picklist picklist) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Picklists').doc(picklist.id);
    final toUpdatePicklist = picklist.copyWith(lastEditingDate: DateTime.now());

    try {
      await docRef.update(toUpdatePicklist.toJson());
      return right(unit);
    } on FirebaseException {
      return left(GeneralFailure());
    } catch (_) {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, List<Picklist>>> getListOfPicklists() async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection(currentUserUid).doc(currentUserUid).collection('Picklists').orderBy('creationDate', descending: true).limit(20);

    try {
      final listOfPicklists = await docRef.get().then((value) => value.docs.map((querySnapshot) => Picklist.fromJson(querySnapshot.data())).toList());
      if (listOfPicklists.isEmpty) return left(EmptyFailure());
      return right(listOfPicklists);
    } on FirebaseException {
      return left(GeneralFailure());
    } catch (_) {
      return left(GeneralFailure());
    }
  }
}
