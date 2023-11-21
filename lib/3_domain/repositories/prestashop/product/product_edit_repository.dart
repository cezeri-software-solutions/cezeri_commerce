import 'package:dartz/dartz.dart';

import '../../../../core/presta_failure.dart';
import '../../../entities/product/product.dart';
import '../../../entities/product/product_image.dart';

abstract class ProductEditRepository {
  Future<Either<PrestaFailure, Unit>> setProdcutPrestaQuantity(Product prodcut, int newQuantity);
  Future<Either<PrestaFailure, Unit>> editProdcutPresta(Product product);
  Future<Either<PrestaFailure, Unit>> uploadProductImages(Product product, List<ProductImage> productImages);
}
