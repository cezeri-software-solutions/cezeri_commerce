import 'dart:io';

import 'package:cezeri_commerce/core/firebase_failures.dart';
import 'package:dartz/dartz.dart';

import '../../entities/marketplace/marketplace.dart';
import '../../entities/product/product.dart';
import '../../entities/product/product_image.dart';
import '../../entities_presta/product_presta.dart';

abstract class ProductRepository {
  Future<Either<FirebaseFailure, Product>> createProduct(Product product, ProductPresta? productPresta);
  Future<Either<FirebaseFailure, Unit>> updateProduct(Product product);
  Future<Either<FirebaseFailure, Product>> updateProductAddImages(Product product, List<File> imageFiles);
  Future<Either<FirebaseFailure, Product>> updateProductRemoveImages(Product product, List<ProductImage> listOfProductImages);
  Future<Either<FirebaseFailure, Unit>> deleteProduct(String id);
  Future<Either<FirebaseFailure, Unit>> deleteListOfProducts(List<Product> products);
  Future<Either<FirebaseFailure, Unit>> activateMarketplaceInSelectedProducts(List<Product> selectedProducts, Marketplace marketplace);
  Future<Either<FirebaseFailure, Product>> getProduct(String id);
  Future<Either<FirebaseFailure, Product>> getProductByArticleNumber(String articleNumber);
  Future<Either<FirebaseFailure, Product>> getProductByEan(String ean);
  Future<Either<FirebaseFailure, Product>> getProductByName(String name);
  Future<Either<FirebaseFailure, List<Product>>> getListOfProducts();
  Future<Either<FirebaseFailure, List<Product>>> getListOfProductsByIds(List<String> productIds);

  Future<Either<FirebaseFailure, Product>> updateAllQuantityOfProductAbsolut(Product product, int newQuantity);
  Future<Either<FirebaseFailure, Product>> updateAvailableQuantityOfProductAbsolut(Product product, int newQuantity);
  Future<Either<FirebaseFailure, Product>> updateWarehouseQuantityOfProductAbsolut(Product product, int newQuantity);
  Future<Either<FirebaseFailure, Product>> updateAvailableQuantityOfProductInremental(
    Product product,
    int newQuantityIncremental,
    Marketplace? marketplaceToSkip,
  );
  Future<Either<FirebaseFailure, Product>> updateWarehouseQuantityOfProductIncremental(Product product, int newQuantityIncremental);
}
