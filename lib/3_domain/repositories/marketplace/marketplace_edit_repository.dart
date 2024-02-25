import 'package:dartz/dartz.dart';

import '../../../../core/presta_failure.dart';
import '../../../4_infrastructur/repositories/prestashop_api/models/product_raw_presta.dart';
import '../../../core/abstract_failure.dart';
import '../../entities/marketplace/marketplace_presta.dart';
import '../../entities/product/product.dart';
import '../../entities/product/product_image.dart';
import '../../entities/product/product_marketplace.dart';
import '../../enums/enums.dart';

abstract class MarketplaceEditRepository {
  //* Product
  Future<Either<List<AbstractFailure>, Unit>> setQuantityMPInAllProductMarketplaces(Product prodcut, int newQuantity, MarketplacePresta? marketplaceToSkip);
  Future<Either<List<AbstractFailure>, Unit>> editProdcutInMarketplace(Product product, List<MarketplacePresta>? toEditMarketplaces);
  Future<Either<PrestaFailure, ProductRawPresta>> createProdcutInMarketplace(
    Product product,
    ProductMarketplace productMarketplace,
    ProductMarketplace anotherProductMarketplaceWithSameManufacturer,
  );
  Future<Either<List<AbstractFailure>, Unit>> uploadProductImagesToMarketplace(Product product, List<ProductImage> productImages);

  //* Order
  Future<Either<PrestaFailure, Unit>> setOrderStatusInMarketplace(
    MarketplacePresta marketplace,
    int orderId,
    OrderStatusUpdateType orderStatusUpdateType,
  );
}
