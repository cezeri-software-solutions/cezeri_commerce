import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../core/abstract_failure.dart';
import '../../entities/statistic/stat_product.dart';

abstract class StatProductRepository {
  Future<Either<AbstractFailure, List<StatProduct>>> getAllStatProductsCurMonth();
  Future<Either<AbstractFailure, List<StatProduct>>> getAllStatProductsFromTo(DateTimeRange dateRange);
  Future<Either<AbstractFailure, List<StatProduct>>> getStatProductsOfProductLast13(String id);
}
