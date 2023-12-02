import 'package:cezeri_commerce/3_domain/entities/customer/customer.dart';
import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../1_presentation/core/functions/check_internet_connection.dart';
import '../../../3_domain/repositories/firebase/customer_repository.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final FirebaseFirestore db;
  final FirebaseAuth firebaseAuth;

  CustomerRepositoryImpl({required this.db, required this.firebaseAuth});

  @override
  Future<Either<FirebaseFailure, Customer>> createCustomer(Customer customer) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;

    try {
      final docRef = db.collection('Customers').doc(currentUserUid).collection('Customers').doc();

      Customer toCreateCustomer = customer.copyWith(id: docRef.id);

      await docRef.set(toCreateCustomer.toJson());

      return right(toCreateCustomer);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Customer>> getCustomer(String id) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Customers').doc(currentUserUid).collection('Customers').doc(id);

    try {
      final customer = await docRef.get();
      return right(Customer.fromJson(customer.data()!));
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, List<Customer>>> getListOfCustomers() async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Customers').doc(currentUserUid).collection('Customers');

    try {
      final listOfCustomers = await docRef.get().then((value) => value.docs.map((querySnapshot) => Customer.fromJson(querySnapshot.data())).toList());

      if (listOfCustomers.isEmpty) return left(EmptyFailure());
      return right(listOfCustomers);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Customer>> updateCustomer(Customer customer) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;

    try {
      final docRef = db.collection('Customers').doc(currentUserUid).collection('Customers').doc(customer.id);

      await docRef.update(customer.toJson());

      return right(customer);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, Unit>> deleteCustomer(String id) {
    // TODO: implement deleteCustomer
    throw UnimplementedError();
  }

  @override
  Future<Either<FirebaseFailure, Unit>> deleteListOfCustomers(List<Customer> customers) {
    // TODO: implement deleteListOfCustomers
    throw UnimplementedError();
  }

  @override
  Future<Either<FirebaseFailure, Customer>> getCustomerByCustomerIdInMarketplace(String marketplaceId, int customerIdMarketplace) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db
        .collection('Customers')
        .doc(currentUserUid)
        .collection('Customers')
        .where('customerMarketplace.marketplaceId', isEqualTo: marketplaceId)
        .where('customerMarketplace.customerIdMarketplace', isEqualTo: customerIdMarketplace);

    try {
      final customer = await docRef.get().then((value) => value.docs.map((docSs) => Customer.fromJson(docSs.data())).toList().firstOrNull);
      if (customer == null) return left(EmptyFailure());
      return right(customer);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }
}
