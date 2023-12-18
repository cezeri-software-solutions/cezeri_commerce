import 'package:cezeri_commerce/3_domain/entities/statistic/stat_product.dart';
import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/material/date.dart';

import '../../../1_presentation/core/functions/check_internet_connection.dart';
import '../../../3_domain/repositories/firebase/stat_product_repository.dart';

class StatProductRepositoryImpl implements StatProductRepository {
  final FirebaseFirestore db;
  final FirebaseAuth firebaseAuth;
  StatProductRepositoryImpl({required this.db, required this.firebaseAuth});

  @override
  Future<Either<FirebaseFailure, List<StatProduct>>> getAllStatProductsCurMonth() async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final now = DateTime.now();
    final curYear = now.year;
    final curMonth = now.month;

    final currentUserUid = firebaseAuth.currentUser!.uid;
    var docRef = db.collection('StatProducts').doc(currentUserUid).collection('$curYear$curMonth');

    try {
      var statProducts = await docRef.get().then((value) => value.docs.map((querySnapshot) => StatProduct.fromJson(querySnapshot.data())).toList());

      return right(statProducts);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }

  @override
  Future<Either<FirebaseFailure, List<StatProduct>>> getAllStatProductsFromTo(DateTimeRange dateRange) async {
    final isConnected = await checkInternetConnection();
    if (!isConnected) return left(NoConnectionFailure());

    final startDate = dateRange.start;
    final endDate = dateRange.end;
    DateTime calcDate = DateTime(endDate.year, endDate.month);

    final currentUserUid = firebaseAuth.currentUser!.uid;

    try {
      List<StatProduct> listOfStatProducts = [];
      do {
        var docRef = db.collection('StatProducts').doc(currentUserUid).collection('${calcDate.year}${calcDate.month.toString().padLeft(2, '0')}');
        var statProducts = await docRef.get().then((value) => value.docs.map((querySnapshot) => StatProduct.fromJson(querySnapshot.data())).toList());
        listOfStatProducts.addAll(statProducts);
        calcDate = DateTime(calcDate.year, calcDate.month - 1);
      } while (calcDate.isAfter(startDate) || (calcDate.year == startDate.year && calcDate.month == startDate.month));

      return right(listOfStatProducts);
    } on FirebaseException {
      return left(GeneralFailure());
    }
  }
}
