import 'package:dartz/dartz.dart';

import '../../../../core/presta_failure.dart';
import '../../../entities/marketplace.dart';
import '../../../entities_presta/product_presta.dart';

abstract class ProductImportRepository {
  Future<Either<PrestaFailure, List<ProductPresta>>> getAllProductsFromPrestashop();
  Future<Either<PrestaFailure, ProductPresta>> getProductByIdFromPrestashop(int id, Marketplace marketplace);
}
