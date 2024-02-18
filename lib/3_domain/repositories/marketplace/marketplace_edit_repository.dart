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
  Future<Either<List<AbstractFailure>, Unit>> setQuantityMPInAllProductMarketplaces(Product prodcut, int newQuantity, Marketplace? marketplaceToSkip);
  Future<Either<List<AbstractFailure>, Unit>> editProdcutInMarketplace(Product product, List<Marketplace>? toEditMarketplaces);
  Future<Either<PrestaFailure, ProductPresta>> createProdcutInMarketplace(
    Product product,
    ProductMarketplace productMarketplace,
    ProductMarketplace anotherProductMarketplaceWithSameManufacturer,
  );
  Future<Either<List<AbstractFailure>, Unit>> uploadProductImagesToMarketplace(Product product, List<ProductImage> productImages);

  //* Order
  Future<Either<PrestaFailure, Unit>> setOrderStatusInMarketplace(
    Marketplace marketplace,
    int orderId,
    OrderStatusUpdateType orderStatusUpdateType,
  );
}
