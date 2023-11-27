import 'package:dartz/dartz.dart';

import '../../../../core/abstract_failure.dart';
import '../../../../core/presta_failure.dart';
import '../../entities/marketplace/marketplace.dart';
import '../../entities/product/product.dart';
import '../../entities/settings/main_settings.dart';
import '../../entities_presta/product_presta.dart';

abstract class MarketplaceImportRepository {
  Future<Either<AbstractFailure, List<int>>> getToLoadProductsFromMarketplace(Marketplace marketplace, bool onlyActive);
  Future<Either<AbstractFailure, ProductPresta>> loadProductFromMarketplace(int productId, Marketplace marketplace);
  Future<Either<AbstractFailure, Product?>> uploadLoadedProductToFirestore(
    ProductPresta productPresta,
    Marketplace marketplace,
    MainSettings mainSettings,
  );
  //
  Future<Either<PrestaFailure, ProductPresta>> getProductByIdFromPrestashopAsJson(int id, Marketplace marketplace);
}
