import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../failures/abstract_failure.dart';
import '../../entities/marketplace/marketplace_presta.dart';
import '../../entities/product/marketplace_product.dart';
import '../../entities/product/product.dart';
import '../../entities/product/product_image.dart';
import '../../entities/product/product_marketplace.dart';
import '../../entities/product/product_stock_difference.dart';
import '../../entities/reorder/supplier.dart';

abstract class ProductRepository {
  Future<Either<AbstractFailure, Product>> createProduct(Product product, MarketplaceProduct? marketplaceProduct);
  Future<Either<AbstractFailure, Product>> updateProduct(Product product);
  Future<Either<AbstractFailure, Product>> updateProductAndSets(Product product);
  Future<Either<AbstractFailure, Product>> updateProductAddImages(Product product, List<File> imageFiles);
  Future<Either<AbstractFailure, Product>> updateProductRemoveImages(Product product, List<ProductImage> listOfProductImages);
  Future<Either<AbstractFailure, Unit>> deleteProduct(String id, String? ownerId);
  Future<Either<AbstractFailure, Unit>> deleteListOfProducts(List<Product> products);
  Future<Either<AbstractFailure, Unit>> activateMarketplaceInSelectedProducts(List<Product> selectedProducts, MarketplacePresta marketplace);
  Future<Either<AbstractFailure, Product>> getProduct(String productId, {String? ownerId});
  Future<Either<AbstractFailure, Product>> getProductByArticleNumber(String articleNumber);
  Future<Either<AbstractFailure, Product>> getProductByEan(String ean);
  Future<Either<AbstractFailure, Product>> getProductByName(String name);
  Future<Either<AbstractFailure, Product>> getProductWithSameProductMarketplaceAndSameManufacturer(
    Product product,
    ProductMarketplace productMarketplace,
  );
  Future<Either<AbstractFailure, List<Product>>> getListOfProducts(bool onlyActive);
  Future<Either<AbstractFailure, int>> getNumerOfAllProducts({bool? onlyActive = false});
  Future<Either<AbstractFailure, List<Product>>> getListOfProductsPerPage({
    required int currentPage,
    required int itemsPerPage,
    bool? onlyActive = false,
  });
  Future<Either<AbstractFailure, int>> getNumberOfFilteredProductsBySearchText({required String searchText});
  Future<Either<AbstractFailure, List<Product>>> getListOfFilteredProductsBySearchText({
    required String searchText,
    required int currentPage,
    required int itemsPerPage,
  });
  Future<Either<AbstractFailure, List<Product>>> getListOfProductsByIds(List<String> productIds);
  Future<Either<AbstractFailure, List<Product>>> getListOfProductsBySupplierName({required bool onlyActive, required Supplier supplier});
  Future<Either<AbstractFailure, List<Product>>> getListOfSoldOutOutletProducts();
  Future<Either<AbstractFailure, List<Product>>> getListOfSoldOutProducts();
  Future<Either<AbstractFailure, List<Product>>> getListOfUnderMinimumQuantityProducts();
  Future<Either<AbstractFailure, List<ProductStockDifference>>> getListOfProductSalesAndStockDiff();

  Future<Either<AbstractFailure, List<Product>>> updateProductQuantity(String productId, int incQuantity, bool updateOnlyAvailableQuantity);
  Future<Either<AbstractFailure, Unit>> updateProductWarehouseStock(String productId, int incQuantity);
  Future<Either<AbstractFailure, Product>> updateAllQuantityOfProductAbsolut(Product product, int newQuantity, bool updateOnlyAvailableQuantity);
  Future<Either<AbstractFailure, Product>> updateAvailableQuantityOfProductInremental(
    Product product,
    int newQuantityIncremental,
    MarketplacePresta? marketplaceToSkip,
  );
  Future<Either<AbstractFailure, Product>> updateWarehouseQuantityOfNewProductOnImportIncremental(
    Product product,
    int newQuantityIncremental, {
    bool updateSets,
  });
}
