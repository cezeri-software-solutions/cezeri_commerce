import 'package:cezeri_commerce/3_domain/entities/customer/customer.dart';
import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

import '../../../core/abstract_failure.dart';
import '/1_presentation/core/functions/check_internet_connection.dart';
import '/3_domain/repositories/firebase/customer_repository.dart';

final logger = Logger();

class CustomerRepositoryImpl implements CustomerRepository {
  final FirebaseFirestore db;
  final FirebaseAuth firebaseAuth;

  CustomerRepositoryImpl({required this.db, required this.firebaseAuth});

  @override
  Future<Either<AbstractFailure, Customer>> createCustomer(Customer customer) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Customers').doc(currentUserUid).collection('Customers').doc();
    final docRefSettings = db.collection('Settings').doc(currentUserUid).collection('Settings').doc(currentUserUid);

    try {
      Customer toCreateCustomer = customer.copyWith(id: docRef.id);
      await docRef.set(toCreateCustomer.toJson());

      await docRefSettings.update({'nextCustomerNumber': FieldValue.increment(1)});

      return right(toCreateCustomer);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Erstellen des Kunden ist ein Fehler aufgetreten.', e: e));
    }
  }

  @override
  Future<Either<AbstractFailure, Customer>> getCustomer(String id) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Customers').doc(currentUserUid).collection('Customers').doc(id);

    try {
      final customer = await docRef.get();
      return right(Customer.fromJson(customer.data()!));
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Laden des Kunden ist ein Fehler aufgetreten.', e: e));
    }
  }

  @override
  Future<Either<AbstractFailure, List<Customer>>> getListOfCustomers() async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Customers').doc(currentUserUid).collection('Customers');

    try {
      final listOfCustomers = await docRef.get().then((value) => value.docs.map((querySnapshot) => Customer.fromJson(querySnapshot.data())).toList());

      return right(listOfCustomers);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Laden der Kunden ist ein Fehler aufgetreten.', e: e));
    }
  }

  @override
  Future<Either<AbstractFailure, Customer>> updateCustomer(Customer customer) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Customers').doc(currentUserUid).collection('Customers').doc(customer.id);

    try {
      await docRef.update(customer.toJson());

      return right(customer);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Aktualisieren des Kunden ist ein Fehler aufgetreten.', e: e));
    }
  }

  @override
  Future<Either<AbstractFailure, Unit>> deleteCustomer(String id) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('Customers').doc(currentUserUid).collection('Customers').doc(id);

    try {
      await docRef.delete();

      return right(unit);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Löschen des Kunden ist ein Fehler aufgetreten.', e: e));
    }
  }

  @override
  Future<Either<AbstractFailure, Customer>> getCustomerByCustomerIdInMarketplace(String marketplaceId, int customerIdMarketplace) async {
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
      if (customer == null) {
        return left(GeneralFailure(customMessage: 'In der Datenbank konnte kein Kunde gefunden werden.'));
      }
      return right(customer);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Laden des Kunden ist ein Fehler aufgetreten.', e: e));
    }
  }
}
