import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../failures/abstract_failure.dart';
import '../../entities/statistic/product_sales_data.dart';

abstract class StatProductRepository {
  Future<Either<AbstractFailure, List<ProductSalesData>>> getProductSalesDataBetweenDates(DateTimeRange dateRange, List<String> productIds);
  Future<Either<AbstractFailure, List<ProductSalesData>>> getProductSalesDataOfOpenAppBetweenDates(DateTimeRange dateRange, List<String> productIds);
  Future<Either<AbstractFailure, List<ProductSalesData>>> getProductsSalesDataOfLast13Months(String id);
}
