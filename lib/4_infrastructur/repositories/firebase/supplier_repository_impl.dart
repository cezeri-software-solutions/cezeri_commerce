import 'package:cezeri_commerce/3_domain/entities/reorder/supplier.dart';
import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../1_presentation/core/functions/check_internet_connection.dart';
import '../../../3_domain/repositories/firebase/supplier_repository.dart';
import '../../../core/abstract_failure.dart';

class SupplierRepositoryImpl implements SupplierRepository {
  final FirebaseFirestore db;
  final FirebaseAuth firebaseAuth;

  SupplierRepositoryImpl({required this.db, required this.firebaseAuth});

  @override
  Future<Either<AbstractFailure, Supplier>> createSupplier(Supplier supplier) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Suppliers').doc(currentUserUid).collection('Suppliers').doc();
    final docRefSettings = db.collection('Settings').doc(currentUserUid).collection('Settings').doc(currentUserUid);

    try {
      Supplier toCreateSupplier = supplier.copyWith(id: docRef.id);
      await docRef.set(toCreateSupplier.toJson());

      await docRefSettings.update({'nextSupplierNumber': FieldValue.increment(1)});

      return right(toCreateSupplier);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<AbstractFailure, Supplier>> getSupplier(String id) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Suppliers').doc(currentUserUid).collection('Suppliers').doc(id);

    try {
      final supplier = await docRef.get();
      return right(Supplier.fromJson(supplier.data()!));
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<AbstractFailure, List<Supplier>>> getListOfSuppliers() async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Suppliers').doc(currentUserUid).collection('Suppliers');

    try {
      final listOfSuppliers = await docRef.get().then((value) => value.docs.map((querySnapshot) => Supplier.fromJson(querySnapshot.data())).toList());

      return right(listOfSuppliers);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<AbstractFailure, Supplier>> updateSupplier(Supplier supplier) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Suppliers').doc(currentUserUid).collection('Suppliers').doc(supplier.id);

    try {
      await docRef.update(supplier.toJson());

      return right(supplier);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> deleteSupplier(String id) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Suppliers').doc(currentUserUid).collection('Suppliers').doc(id);

    try {
      await docRef.delete();

      return right(unit);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }
}
