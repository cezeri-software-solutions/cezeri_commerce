import 'package:cezeri_commerce/3_domain/entities/statistic/stat_product.dart';
import 'package:cezeri_commerce/failures/firebase_failures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../1_presentation/core/functions/check_internet_connection.dart';
import '../../../3_domain/repositories/firebase/stat_product_repository.dart';
import '../../../constants.dart';
import '../../../failures/abstract_failure.dart';
import '../functions/repository_functions.dart';

class StatProductRepositoryImpl implements StatProductRepository {
  final FirebaseFirestore db;
  final FirebaseAuth firebaseAuth;
  StatProductRepositoryImpl({required this.db, required this.firebaseAuth});

  @override
  Future<Either<AbstractFailure, List<StatProduct>>> getAllStatProductsCurMonth() async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final now = DateTime.now();
    final curYear = now.year;
    final curMonth = now.month;

    final query = supabase
        .from('d_stat_products')
        .select()
        .eq('ownerId', ownerId)
        .filter('EXTRACT(YEAR FROM creationDate)', 'eq', curYear)
        .filter('EXTRACT(MONTH FROM creationDate)', 'eq', curMonth);

    try {
      final statProducts = await query.then((val) => val.map((e) => StatProduct.fromJson(e)).toList());

      return Right(statProducts);
    } catch (e) {
      logger.e(e);
      return const Right([]);
    }
  }

  @override
  Future<Either<AbstractFailure, List<StatProduct>>> getAllStatProductsFromTo(DateTimeRange dateRange) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final startDate = dateRange.start;
    final endDate = dateRange.end;
    DateTime calcDate = endDate;

    final query = supabase
        .from('d_stat_products')
        .select()
        .eq('ownerId', ownerId)
        .gte('creationDate', DateTime(calcDate.year, calcDate.month, 1).toIso8601String())
        .lte('creationDate', DateTime(calcDate.year, calcDate.month + 1, 0, 23, 59, 59).toIso8601String());

    try {
      List<StatProduct> listOfStatProducts = [];
      do {
        final response = await query;

        final statProducts = response.map((json) => StatProduct.fromJson(json)).toList();

        listOfStatProducts.addAll(statProducts);

        calcDate = subtractMonth(calcDate);
      } while (calcDate.isAfter(startDate) || (calcDate.year == startDate.year && calcDate.month == startDate.month));

      return Right(listOfStatProducts);
    } catch (e) {
      logger.e(e);
      return const Right([]);
    }
  }

  @override
  Future<Either<AbstractFailure, List<StatProduct>>> getStatProductsOfProductLast13(String id) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final now = DateTime.now();
    final startDate = DateTime(now.year - 1, now.month);
    DateTime calcDate = now;

    final query = supabase
        .from('d_stat_products')
        .select()
        .eq('ownerId', ownerId)
        .eq('statProductId', id)
        .gte('creationDate', DateTime(calcDate.year, calcDate.month, 1).toIso8601String())
        .lte('creationDate', DateTime(calcDate.year, calcDate.month + 1, 0, 23, 59, 59).toIso8601String())
        .single();

    List<StatProduct> listOfStatProducts = [];

    try {
      while (calcDate.isAfter(startDate) || (calcDate.year == startDate.year && calcDate.month == startDate.month)) {
        final response = await query;

        final statProducts = StatProduct.fromJson(response); // response.map((json) => StatProduct.fromJson(json)).toList();

        listOfStatProducts.add(statProducts);

        calcDate = subtractMonth(calcDate);
      }

      return Right(listOfStatProducts);
    } catch (e) {
      logger.e(e.toString());
      return const Right([]);
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
