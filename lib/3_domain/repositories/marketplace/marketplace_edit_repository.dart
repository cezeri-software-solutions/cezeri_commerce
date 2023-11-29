import 'package:dartz/dartz.dart';

import '../../../../core/presta_failure.dart';
import '../../entities/marketplace/marketplace.dart';
import '../../entities/product/product.dart';
import '../../entities/product/product_image.dart';
import '../../enums/enums.dart';

abstract class MarketplaceEditRepository {
  //* Product
  Future<Either<PrestaFailure, Unit>> setProdcutPrestaQuantity(Product prodcut, int newQuantity, Marketplace? marketplaceToSkip);
  Future<Either<PrestaFailure, Unit>> editProdcutPresta(Product product);
  Future<Either<PrestaFailure, Unit>> uploadProductImages(Product product, List<ProductImage> productImages);

  //* Order
  Future<Either<PrestaFailure, Unit>> setOrderStatus(
    Marketplace marketplace,
    int orderId,
    OrderStatusUpdateType orderStatusUpdateType,
  );
}
