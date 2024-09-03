import 'package:dartz/dartz.dart';

import '../../../4_infrastructur/repositories/prestashop_api/models/product_raw_presta.dart';
import '../../../failures/abstract_failure.dart';
import '../../../failures/presta_failure.dart';
import '../../entities/carrier/parcel_tracking.dart';
import '../../entities/marketplace/abstract_marketplace.dart';
import '../../entities/product/product.dart';
import '../../entities/product/product_image.dart';
import '../../entities/product/product_marketplace.dart';
import '../../enums/enums.dart';

abstract class MarketplaceEditRepository {
  //* Product
  Future<Either<List<AbstractFailure>, Unit>> setQuantityMPInAllProductMarketplaces(
      Product prodcut, int newQuantity, AbstractMarketplace? marketplaceToSkip);
  Future<Either<List<AbstractFailure>, Unit>> editProdcutInMarketplace(Product product, List<AbstractMarketplace>? toEditMarketplaces);
  Future<Either<AbstractFailure, ProductRawPresta>> createProdcutInMarketplace(
    Product product,
    ProductMarketplace productMarketplace,
    ProductMarketplace anotherProductMarketplaceWithSameManufacturer,
  );
  Future<Either<List<AbstractFailure>, Unit>> uploadProductImagesToMarketplace(Product product, List<ProductImage> productImages);

  //* Order
  Future<Either<PrestaFailure, Unit>> setOrderStatusInMarketplace(
    AbstractMarketplace marketplace,
    int orderId,
    OrderStatusUpdateType orderStatusUpdateType,
    ParcelTracking? parcelTracking,
  );
}
