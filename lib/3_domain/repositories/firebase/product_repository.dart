import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:dartz/dartz.dart';

import '../../entities/marketplace/marketplace.dart';
import '../../entities/product/product.dart';

abstract class ProductRepository {
  Future<Either<FirebaseFailure, Product>> createProduct(Product product);
  Future<Either<FirebaseFailure, Unit>> updateProduct(Product product);
  Future<Either<FirebaseFailure, Unit>> deleteProduct(String id);
  Future<Either<FirebaseFailure, Unit>> deleteListOfProducts(List<String> productsIds);
  Future<Either<FirebaseFailure, Unit>> activateMarketplaceInSelectedProducts(List<Product> selectedProducts, Marketplace marketplace);
  Future<Either<FirebaseFailure, Product>> getProduct(String id);
  Future<Either<FirebaseFailure, Product>> getProductByArticleNumber(String articleNumber);
  Future<Either<FirebaseFailure, List<Product>>> getListOfProducts();

  Future<Either<FirebaseFailure, Product>> updateQuantityOfProductAbsolut(Product product, int newQuantityIncremental);
  Future<Either<FirebaseFailure, Product>> updateAvailableQuantityOfProductInremental(Product product, int newQuantityIncremental);
  Future<Either<FirebaseFailure, Product>> updateWarehouseQuantityOfProductIncremental(Product product, int newQuantityIncremental);
}
