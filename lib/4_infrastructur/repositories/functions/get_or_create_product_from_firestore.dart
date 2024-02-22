import 'package:logger/logger.dart';

import '../../../3_domain/entities/marketplace/marketplace_presta.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/entities/product/product_id_with_quantity.dart';
import '../../../3_domain/entities/settings/main_settings.dart';
import '../../../3_domain/entities_presta/product_presta.dart';
import '../../../3_domain/repositories/firebase/product_repository.dart';

Future<Product?> createProductInFirestore(
  Product product,
  ProductPresta productPresta,
  MarketplacePresta marketplace,
  MainSettings mainSettings,
  ProductRepository productRepository,
  List<ProductIdWithQuantity>? listOfProductIdWithQuantity,
) async {
  final logger = Logger();
  Product? createdProduct;
  final fosProduct = await productRepository.createProduct(
    Product.fromProductPresta(
      productPresta: productPresta,
      marketplace: marketplace,
      mainSettings: mainSettings,
      listOfProductIdWithQuantity: listOfProductIdWithQuantity,
    ),
    productPresta,
  );
  fosProduct.fold(
    (failure) => logger.e('Artikel: ${product.name} konte nicht in der Firestore Datenbank angelegt werden. \n Error: $failure'),
    (productFirestore) => createdProduct = productFirestore,
  );

  return createdProduct;
}

Future<Product?> getProductFromFirestoreIfExists(
  String articleNumber,
  String ean,
  String name,
  MarketplacePresta marketplace,
  MainSettings mainSettings,
  ProductRepository productRepository,
) async {
  final logger = Logger();

  Product? product;

  final fosProduct = await productRepository.getProductByArticleNumber(articleNumber);
  fosProduct.fold(
    (failure) => logger.i('Artikel $articleNumber nicht in der Firestore Datenbank'),
    (productFirestore) => product = productFirestore,
  );

  if (product == null && ean != '') {
    final fosProduct = await productRepository.getProductByEan(ean);
    fosProduct.fold(
      (failure) => logger.i('Artikel $articleNumber nicht in der Firestore Datenbank'),
      (productFirestore) => product = productFirestore,
    );
  }

  if (product == null) {
    final fosProduct = await productRepository.getProductByName(name);
    fosProduct.fold(
      (failure) => logger.i('Artikel $articleNumber nicht in der Firestore Datenbank'),
      (productFirestore) => product = productFirestore,
    );
  }

  return product;
}
