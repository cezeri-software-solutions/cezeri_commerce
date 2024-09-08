import 'package:cezeri_commerce/failures/firebase_failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../1_presentation/core/core.dart';
import '../../../3_domain/entities/statistic/product_sales_data.dart';
import '../../../3_domain/repositories/database/stat_product_repository.dart';
import '../../../constants.dart';
import '../../../failures/abstract_failure.dart';
import 'functions/repository_functions.dart';

class StatProductRepositoryImpl implements StatProductRepository {
  final SupabaseClient supabase;

  StatProductRepositoryImpl({required this.supabase});

  @override
  Future<Either<AbstractFailure, List<ProductSalesData>>> getProductSalesDataBetweenDates(DateTimeRange dateRange, List<String> productIds) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final startDate = '${dateRange.start.year}-${dateRange.start.month}-${dateRange.start.day}';
    final endDate = '${dateRange.end.year}-${dateRange.end.month}-${dateRange.end.day}';

    try {
      final response = productIds.isEmpty
          ? await supabase.rpc('get_products_sales_data_between_dates', params: {
              'p_owner_id': ownerId,
              'p_start_date': startDate,
              'p_end_date': endDate,
            })
          : await supabase.rpc('get_products_sales_data_by_product_ids_between_dates', params: {
              'p_product_ids': productIds,
              'p_owner_id': ownerId,
              'p_start_date': startDate,
              'p_end_date': endDate,
            });

      final listOfProductSalesData = (response as List<dynamic>).map((e) {
        final item = e as Map<String, dynamic>;
        return ProductSalesData.fromJson(item);
      }).toList();

      return Right(listOfProductSalesData);
    } catch (e) {
      logger.e(e);
      return const Right([]);
    }
  }

  @override
  Future<Either<AbstractFailure, List<ProductSalesData>>> getProductSalesDataOfOpenAppBetweenDates(
      DateTimeRange dateRange, List<String> productIds) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final startDate = '${dateRange.start.year}-${dateRange.start.month}-${dateRange.start.day}';
    final endDate = '${dateRange.end.year}-${dateRange.end.month}-${dateRange.end.day}';

    try {
      final response = productIds.isEmpty
          ? await supabase.rpc('get_app_products_sales_data_between_dates', params: {
              'p_owner_id': ownerId,
              'p_start_date': startDate,
              'p_end_date': endDate,
            })
          : await supabase.rpc('get_app_products_sales_data_by_product_ids_between_dates', params: {
              'p_product_ids': productIds,
              'p_owner_id': ownerId,
              'p_start_date': startDate,
              'p_end_date': endDate,
            });

      final listOfProductSalesData = (response as List<dynamic>).map((e) {
        final item = e as Map<String, dynamic>;
        return ProductSalesData.fromJson(item);
      }).toList();

      return Right(listOfProductSalesData);
    } catch (e) {
      logger.e(e);
      return const Right([]);
    }
  }

  @override
  Future<Either<AbstractFailure, List<ProductSalesData>>> getProductsSalesDataOfLast13Months(String id) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final response = await supabase.rpc('get_products_sales_data_of_last_13_months', params: {
        'p_product_id': id,
        'p_owner_id': ownerId,
      });

      final listOfProductSalesData = (response as List<dynamic>).map((e) {
        final item = e as Map<String, dynamic>;
        return ProductSalesData.fromJson(item);
      }).toList();

      return Right(listOfProductSalesData);
    } catch (e) {
      logger.e(e);
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
