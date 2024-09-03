import '/3_domain/entities/product/product.dart';

int calcSetArticleAvailableQuantity(Product setProduct, List<Product> listOfSetPartProducts) {
  final quantitySetArticle = setProduct.listOfProductIdWithQuantity.map((e) {
    final partProduct = listOfSetPartProducts.firstWhere((element) => element.id == e.productId);
    return partProduct.availableStock ~/ e.quantity;
  }).reduce((a, b) => a < b ? a : b);
  return quantitySetArticle;
}
