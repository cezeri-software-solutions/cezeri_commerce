import 'package:dartz/dartz.dart';

import '../../../../core/presta_failure.dart';
import '../../../entities/product/product.dart';

abstract class ProductEditRepository {
  Future<Either<PrestaFailure, Unit>> setProdcutPrestaQuantity(Product prodcut, int newQuantity);
  Future<Either<PrestaFailure, Unit>> editProdcutPresta(Product prodcut);
}
