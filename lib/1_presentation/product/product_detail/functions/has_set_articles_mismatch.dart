import '../../../../3_domain/entities/product/product.dart';
import '../../../../3_domain/entities/product/product_id_with_quantity.dart';

bool hasSetArticlesMismatch(List<ProductIdWithQuantity> listOfProductIdWithQuantity, List<Product>? listOfAllProducts) {
  if (listOfAllProducts == null) return true;
  final hasMismatch = listOfProductIdWithQuantity.any((e) => !listOfAllProducts.map((p) => p.id).contains(e.productId));
  return hasMismatch;
}
