import 'package:dartz/dartz.dart';

import '../../../../core/presta_failure.dart';
import '../../../core/abstract_failure.dart';
import '../../entities/marketplace/marketplace.dart';
import '../../entities/product/product.dart';
import '../../entities/product/product_image.dart';
import '../../entities/product/product_marketplace.dart';
import '../../entities_presta/product_presta.dart';
import '../../enums/enums.dart';

abstract class MarketplaceEditRepository {
  //* Product
  Future<Either<List<AbstractFailure>, Unit>> setProdcutPrestaQuantity(Product prodcut, int newQuantity, Marketplace? marketplaceToSkip);
  Future<Either<List<AbstractFailure>, Unit>> editProdcutPresta(Product product, List<Marketplace>? toEditMarketplaces);
  Future<Either<PrestaFailure, ProductPresta>> createProdcutPresta(
    Product product,
    ProductMarketplace productMarketplace,
    ProductMarketplace anotherProductMarketplaceWithSameManufacturer,
  );
  Future<Either<PrestaFailure, Unit>> uploadProductImages(Product product, List<ProductImage> productImages);

  //* Order
  Future<Either<PrestaFailure, Unit>> setOrderStatus(
    Marketplace marketplace,
    int orderId,
    OrderStatusUpdateType orderStatusUpdateType,
  );
}
