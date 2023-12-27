import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../core/firebase_failures.dart';
import '../../entities/statistic/stat_product.dart';

abstract class StatProductRepository {
  Future<Either<FirebaseFailure, List<StatProduct>>> getAllStatProductsCurMonth();
  Future<Either<FirebaseFailure, List<StatProduct>>> getAllStatProductsFromTo(DateTimeRange dateRange);
  Future<Either<FirebaseFailure, List<StatProduct>>> getStatProductsOfProductLast13(String id);
}
