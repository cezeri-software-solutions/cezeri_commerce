import 'package:dartz/dartz.dart';

import '../../../core/firebase_failures.dart';
import '../../entities/product/product.dart';

abstract class PackingStationRepository {
  Future<Either<FirebaseFailure, List<Product>>> getListOfProducts(List<String> productIds);
}
