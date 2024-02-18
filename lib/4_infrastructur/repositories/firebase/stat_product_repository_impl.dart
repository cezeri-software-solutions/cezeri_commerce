import 'package:cezeri_commerce/3_domain/entities/statistic/stat_product.dart';
import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../../1_presentation/core/functions/check_internet_connection.dart';
import '../../../3_domain/repositories/firebase/stat_product_repository.dart';
import '../../../core/abstract_failure.dart';

final logger = Logger();

class StatProductRepositoryImpl implements StatProductRepository {
  final FirebaseFirestore db;
  final FirebaseAuth firebaseAuth;
  StatProductRepositoryImpl({required this.db, required this.firebaseAuth});

  @override
  Future<Either<AbstractFailure, List<StatProduct>>> getAllStatProductsCurMonth() async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final now = DateTime.now();
    final curYear = now.year;
    final curMonth = now.month;

    final currentUserUid = firebaseAuth.currentUser!.uid;
    final docRef = db.collection('StatProducts').doc(currentUserUid).collection('$curYear$curMonth');

    try {
      final statProducts = await docRef.get().then((value) => value.docs.map((querySnapshot) => StatProduct.fromJson(querySnapshot.data())).toList());

      return right(statProducts);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Laden der Artikelausertungen für den aktuellen Monat ist ein Fehler aufgetreten', e: e));
    }
  }

  @override
  Future<Either<AbstractFailure, List<StatProduct>>> getAllStatProductsFromTo(DateTimeRange dateRange) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final startDate = dateRange.start;
    final endDate = dateRange.end;
    DateTime calcDate = endDate;

    final currentUserUid = firebaseAuth.currentUser!.uid;

    try {
      List<StatProduct> listOfStatProducts = [];
      do {
        final docRef = db.collection('StatProducts').doc(currentUserUid).collection('${calcDate.year}${calcDate.month.toString()}');
        final statProducts =
            await docRef.get().then((value) => value.docs.map((querySnapshot) => StatProduct.fromJson(querySnapshot.data())).toList());
        listOfStatProducts.addAll(statProducts);
        calcDate = subtractMonth(calcDate);
      } while (calcDate.isAfter(startDate) || (calcDate.year == startDate.year && calcDate.month == startDate.month));

      return right(listOfStatProducts);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Laden der Artikelausertungen ist ein Fehler aufgetreten', e: e));
    }
  }

  @override
  Future<Either<AbstractFailure, List<StatProduct>>> getStatProductsOfProductLast13(String id) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final now = DateTime.now();
    final startDate = DateTime(now.year - 1, now.month);
    DateTime calcDate = now;

    final currentUserUid = firebaseAuth.currentUser!.uid;

    List<StatProduct> listOfStatProducts = [];

    try {
      while (calcDate.isAfter(startDate) || (calcDate.year == startDate.year && calcDate.month == startDate.month)) {
        final collection = '${calcDate.year}${calcDate.month.toString()}';
        final docRef = db.collection('StatProducts').doc(currentUserUid).collection(collection).doc(id);
        final statProductDs = await docRef.get();

        if (statProductDs.exists) {
          final statProduct = StatProduct.fromJson(statProductDs.data()!);
          listOfStatProducts.add(statProduct);
        }

        calcDate = subtractMonth(calcDate);
      }

      return right(listOfStatProducts);
    } on FirebaseException catch (e) {
      logger.e(e.message);
      return left(GeneralFailure(customMessage: 'Beim Laden der Artikelausertungen der letzten 13 Monate ist ein Fehler aufgetreten', e: e));
    }
  }

//* ################################################################################################################################
//* ### Hilfsfunktionen

  DateTime subtractMonth(DateTime date) {
    if (date.month == 1) {
      return DateTime(date.year - 1, 12, date.day);
    } else {
      return DateTime(date.year, date.month - 1, date.day);
    }
  }
}
