import 'package:dartz/dartz.dart';

import '../../../4_infrastructur/repositories/prestashop_api/models/product_raw_presta.dart';
import '../../../4_infrastructur/repositories/shopify_api/shopify.dart';
import '../../../failures/abstract_failure.dart';
import '../../entities/marketplace/abstract_marketplace.dart';
import '../../entities/marketplace/marketplace_presta.dart';
import '../../entities/marketplace/marketplace_shopify.dart';
import '../../entities/product/marketplace_product.dart';
import '../../entities/product/product.dart';
import '../../entities/product/product_presta.dart';

abstract class MarketplaceImportRepository {
  Future<Either<AbstractFailure, List<int>>> getToLoadProductsFromMarketplace(MarketplacePresta marketplace, bool onlyActive);
  Future<Either<AbstractFailure, ProductRawPresta>> loadProductFromMarketplace(int productId, MarketplacePresta marketplace);
  Future<Either<AbstractFailure, Product?>> uploadLoadedMarketplaceProductToFirestore(MarketplaceProduct marketplaceProduct, String marketplaceId);
  //
  Future<Either<AbstractFailure, ProductPresta>> loadProductByIdFromPrestashopAsJson(int id, MarketplacePresta marketplace);
  Future<Either<AbstractFailure, List<ProductShopify>>> loadProductByArticleNumberFromShopify(String articleNumber, MarketplaceShopify marketplace);
  Future<Either<AbstractFailure, List<dynamic>>> getAllMarketplaceCategories(AbstractMarketplace marketplace);
}
