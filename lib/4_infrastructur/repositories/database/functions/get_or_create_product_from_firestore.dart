import '/3_domain/entities/product/product.dart';
import '../../../../3_domain/repositories/database/product_repository.dart';
import '../../../../constants.dart';

Future<Product?> getProductFromFirestoreIfExists({
  required String articleNumber,
  required String ean,
  required String name,
  required ProductRepository productRepository,
}) async {
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
