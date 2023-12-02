import 'package:cezeri_commerce/3_domain/entities/reorder/supplier.dart';
import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../1_presentation/core/functions/check_internet_connection.dart';
import '../../../3_domain/repositories/firebase/supplier_repository.dart';

class SupplierRepositoryImpl implements SupplierRepository {
  final FirebaseFirestore db;
  final FirebaseAuth firebaseAuth;

  SupplierRepositoryImpl({required this.db, required this.firebaseAuth});

  @override
  Future<Either<FirebaseFailure, Supplier>> createSupplier(Supplier supplier) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;

    try {
      final docRef = db.collection('Suppliers').doc(currentUserUid).collection('Suppliers').doc();

      Supplier toCreateSupplier = supplier.copyWith(id: docRef.id);

      await docRef.set(toCreateSupplier.toJson());

      return right(toCreateSupplier);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Supplier>> getSupplier(String id) async {
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
  Future<Either<FirebaseFailure, List<Supplier>>> getListOfSuppliers() async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Suppliers').doc(currentUserUid).collection('Suppliers');

    try {
      final listOfSuppliers = await docRef.get().then((value) => value.docs.map((querySnapshot) => Supplier.fromJson(querySnapshot.data())).toList());

      if (listOfSuppliers.isEmpty) return left(EmptyFailure());
      return right(listOfSuppliers);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Supplier>> updateSupplier(Supplier supplier) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;

    try {
      final docRef = db.collection('Suppliers').doc(currentUserUid).collection('Suppliers').doc(supplier.id);

      await docRef.update(supplier.toJson());

      return right(supplier);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Unit>> deleteSupplier(String id) async {
    // TODO: implement deleteSupplier
    throw UnimplementedError();
  }

  @override
  Future<Either<FirebaseFailure, Unit>> deleteListOfSuppliers(List<Supplier> suppliers) async {
    // TODO: implement deleteListOfSuppliers
    throw UnimplementedError();
  }
}
