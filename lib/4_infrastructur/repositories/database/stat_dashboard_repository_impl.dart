import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../1_presentation/core/core.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../3_domain/entities/statistic/stat_brand.dart';
import '../../../3_domain/entities/statistic/stat_dashboard.dart';
import '../../../3_domain/entities/statistic/stat_product_count.dart';
import '../../../3_domain/entities/statistic/stat_sales_grouped.dart';
import '../../../3_domain/entities/statistic/stat_sales_per_day.dart';
import '../../../3_domain/repositories/database/stat_dashboard_repository.dart';
import '../../../constants.dart';
import '../../../failures/abstract_failure.dart';
import '../../../failures/firebase_failures.dart';
import 'functions/repository_functions.dart';

class StatDashboardRepositoryImpl implements StatDashboardRepository {
  final SupabaseClient supabase;

  StatDashboardRepositoryImpl({required this.supabase});

  //? #######################################################################################################################################

  @override
  Future<Either<AbstractFailure, StatSalesBetweenDates>> getStatSalesBetweenDates(DateTimeRange dateRange) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final startDate = dateRange.start.toConvertedYearMonthDay();
    final endDate = dateRange.end.add(const Duration(days: 1)).toConvertedYearMonthDay();

    try {
      final response = await supabase.rpc('get_sales_per_day_per_marketplace', params: {
        'owner_id': ownerId,
        'start_date': startDate,
        'end_date': endDate,
      });

      if (response == null) {
        logger.e('Response is null');
        return Left(GeneralFailure(customMessage: 'Keine Daten erhalten.'));
      }

      if (response is! List) {
        logger.e('Response is not a List: ${response.runtimeType}');
        return Left(GeneralFailure(customMessage: 'Unerwartetes Datenformat erhalten.'));
      }

      final listOfStatSalesPerDay = response.map((dayData) {
        if (dayData is! Map<String, dynamic>) {
          logger.e('Day data is not a Map: ${dayData.runtimeType}');
          throw const FormatException('Ungültiges Tagesformat in der Liste');
        }

        final date = DateTime.parse(dayData['date']);
        final marketplaceData = dayData['list_of_stat_sales_per_day_per_marketplace'] as List;

        final listOfStatSalesPerDayPerMarketplace = marketplaceData.map((marketplaceItem) {
          return StatSalesPerDayPerMarketplace.fromJson(marketplaceItem);
        }).toList();

        return StatSalesPerDay(
          date: date,
          listOfStatSalesPerDayPerMarketplace: listOfStatSalesPerDayPerMarketplace,
        );
      }).toList();

      final statSalesBetweenDates = StatSalesBetweenDates(listOfStatSalesPerDay: listOfStatSalesPerDay, dateRange: dateRange);

      return Right(statSalesBetweenDates);
    } catch (e, stackTrace) {
      logger.e('Error in getStatSalesBetweenDates: $e');
      logger.e('Stack trace: $stackTrace');
      return Left(GeneralFailure(customMessage: 'Daten konnten nicht geladen werden: ${e.toString()}'));
    }
  }

  //? #######################################################################################################################################

  @override
  Future<Either<AbstractFailure, StatDashboard>> getStatDashboard() async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final now = DateTime.now();

    final query = supabase.from('stat_dashboards').select().eq('owner_id', ownerId).eq('statDashboardId', now.toConvertedYearMonth()).single();

    try {
      final response = await query;

      return right(StatDashboard.fromJson(response));
    } catch (e) {
      logger.e(e);
      return right(StatDashboard.empty());
    }
  }

  //? #######################################################################################################################################

  @override
  Future<Either<AbstractFailure, List<StatDashboard>>> getLast13StatDashboards() async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final query = supabase.from('stat_dashboards').select().eq('owner_id', ownerId).order('creation_date', ascending: false).limit(13);

    try {
      final response = await query;
      if (response.isEmpty) return const Right([]);

      final listOfProducts = response.map((e) => StatDashboard.fromJson(e)).toList();

      return Right(listOfProducts);
    } catch (e) {
      logger.e(e);
      return left(GeneralFailure(customMessage: 'Beim Laden der Vertriebsauswertungen der letzten 13 Monate ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  //? #######################################################################################################################################

  @override
  Future<Either<AbstractFailure, List<Receipt>>> getAppointmentsOfTodayAndTomorrow() async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final DateTime now = DateTime.now();
    final DateTime dayFirst = DateTime(
      now.year,
      now.month,
      now.day -
          switch (now.weekday) {
            DateTime.monday => 3,
            DateTime.sunday => 2,
            _ => 1,
          },
    );

    final query = supabase
        .from('d_appointments')
        .select()
        .eq('ownerId', ownerId)
        .gte('creationDateMarektplace', dayFirst.toIso8601String())
        .or('appointmentStatus.eq.${AppointmentStatus.open.name},appointmentStatus.eq.${AppointmentStatus.partiallyCompleted.name}');

    try {
      var listOfAppointments = await query.then((list) => list.map((e) => Receipt.fromJson(e)).toList());

      return Right(listOfAppointments);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Beim Laden der Vertriebsauswertungen von heute und morgen ist ein Fehler aufgetreten. Error: $e'));
    }
  }

  //? #######################################################################################################################################

  @override
  Future<Either<AbstractFailure, List<StatBrand>>> getStatProductsByBrand(DateTimeRange dateRange) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final startDate = dateRange.start.toConvertedYearMonthDay();
    final endDate = dateRange.end.add(const Duration(days: 1)).toConvertedYearMonthDay();

    try {
      final response = await supabase.rpc('get_stat_products_by_brand', params: {
        'p_owner_id': ownerId,
        'start_date': startDate,
        'end_date': endDate,
      });

      final listOfProductSalesByBrand = (response as List<dynamic>).map((e) {
        final item = e as Map<String, dynamic>;
        return StatBrand.fromJson(item);
      }).toList();

      return Right(listOfProductSalesByBrand);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Daten konnten nicht geladen werden.'));
    }
  }

  //? #######################################################################################################################################

  @override
  Future<Either<AbstractFailure, List<StatProductCount>>> getStatProductsCount(DateTimeRange dateRange) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    try {
      final response = await supabase
          .from('your_table_name')
          .select()
          .gte('date_column', dateRange.start.toIso8601String())
          .lte('date_column', dateRange.end.toIso8601String());

      final listOfStatProductsCount = response.map((e) => StatProductCount.fromJson(e)).toList();

      return Right(listOfStatProductsCount);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Daten konnten nicht geladen werden.'));
    }
  }

  //? #######################################################################################################################################

  @override
  Future<Either<AbstractFailure, List<StatSalesGrouped>>> getSalesVolumeInvoicesGroupedByCountry(DateTimeRange dateRange) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final startDate = dateRange.start.toConvertedYearMonthDay();
    final endDate = dateRange.end.add(const Duration(days: 1)).toConvertedYearMonthDay();

    try {
      final response = await supabase.rpc('get_sales_volume_invoices_grouped_by_country', params: {
        'owner_id': ownerId,
        'start_date': startDate,
        'end_date': endDate,
      });

      final salesVolumeGroupedByCountry = (response as List<dynamic>).map((e) {
        final item = e as Map<String, dynamic>;
        return StatSalesGrouped.fromJson(item);
      }).toList();

      return Right(salesVolumeGroupedByCountry);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Daten konnten nicht geladen werden.'));
    }
  }

  //? #######################################################################################################################################

  @override
  Future<Either<AbstractFailure, List<StatSalesGrouped>>> getSalesVolumeInvoicesGroupedByMarketplace(DateTimeRange dateRange) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final startDate = dateRange.start.toConvertedYearMonthDay();
    final endDate = dateRange.end.add(const Duration(days: 1)).toConvertedYearMonthDay();

    try {
      final response = await supabase.rpc('get_sales_volume_invoices_by_marketplace', params: {
        'owner_id': ownerId,
        'start_date': startDate,
        'end_date': endDate,
      });

      final salesVolumeGroupedByMarketplace = (response as List<dynamic>).map((e) {
        final item = e as Map<String, dynamic>;
        return StatSalesGrouped.fromJson(item);
      }).toList();

      return Right(salesVolumeGroupedByMarketplace);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Daten konnten nicht geladen werden.'));
    }
  }

  //? #######################################################################################################################################

  @override
  Future<Either<AbstractFailure, List<StatSalesGroupedByMarketplace>>> getSalesVolumeInvoicesGroupedByMarketplaceAndCountry(
      DateTimeRange dateRange) async {
    if (!await checkInternetConnection()) return Left(NoConnectionFailure());
    final ownerId = await getOwnerId();
    if (ownerId == null) return Left(GeneralFailure(customMessage: 'Dein User konnte nicht aus der Datenbank geladen werden'));

    final startDate = dateRange.start.toConvertedYearMonthDay();
    final endDate = dateRange.end.add(const Duration(days: 1)).toConvertedYearMonthDay();

    try {
      final response = await supabase.rpc('get_sales_volume_invoices_by_marketplace_and_country', params: {
        'owner_id': ownerId,
        'start_date': startDate,
        'end_date': endDate,
      });

      final listOfProductSalesByBrand = (response as List<dynamic>).map((e) {
        final item = e as Map<String, dynamic>;
        return StatSalesGroupedByMarketplace.fromJson(item);
      }).toList();

      return Right(listOfProductSalesByBrand);
    } catch (e) {
      logger.e(e);
      return Left(GeneralFailure(customMessage: 'Daten konnten nicht geladen werden.'));
    }
  }

  //? #######################################################################################################################################
}
