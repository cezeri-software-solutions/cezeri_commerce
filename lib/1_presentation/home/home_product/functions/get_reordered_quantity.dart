import '../../../../3_domain/entities/product/product.dart';
import '../../../../3_domain/entities/reorder/reorder.dart';

int getReorderedQuantity(Product product, List<Reorder>? listOfReorders) {
  if (listOfReorders == null) return 0;

  return listOfReorders.fold<int>(0, (sum, reorder) {
    final productQuantity = reorder.listOfReorderProducts
        .where((reorderProduct) => reorderProduct.productId == product.id)
        .fold<int>(0, (sumInner, product) => sumInner + product.openQuantity);
    return sum + productQuantity;
  });
}
