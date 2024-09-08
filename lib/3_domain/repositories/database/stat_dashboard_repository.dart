import 'package:cezeri_commerce/3_domain/entities/statistic/stat_sales_grouped.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../failures/abstract_failure.dart';
import '../../entities/receipt/receipt.dart';
import '../../entities/statistic/stat_brand.dart';
import '../../entities/statistic/stat_dashboard.dart';
import '../../entities/statistic/stat_product_count.dart';
import '../../entities/statistic/stat_sales_per_day.dart';

abstract class StatDashboardRepository {
  Future<Either<AbstractFailure, StatSalesBetweenDates>> getStatSalesBetweenDates(DateTimeRange dateRange);

  Future<Either<AbstractFailure, StatDashboard>> getStatDashboard();

  Future<Either<AbstractFailure, List<StatDashboard>>> getLast13StatDashboards();

  Future<Either<AbstractFailure, List<Receipt>>> getAppointmentsOfTodayAndTomorrow();

  Future<Either<AbstractFailure, List<StatBrand>>> getStatProductsByBrand(DateTimeRange dateRange);

  Future<Either<AbstractFailure, List<StatProductCount>>> getStatProductsCount(DateTimeRange dateRange);

  Future<Either<AbstractFailure, List<StatSalesGrouped>>> getSalesVolumeInvoicesGroupedByCountry(DateTimeRange dateRange);
  Future<Either<AbstractFailure, List<StatSalesGrouped>>> getSalesVolumeInvoicesGroupedByMarketplace(DateTimeRange dateRange);
  Future<Either<AbstractFailure, List<StatSalesGroupedByMarketplace>>> getSalesVolumeInvoicesGroupedByMarketplaceAndCountry(DateTimeRange dateRange);
}
