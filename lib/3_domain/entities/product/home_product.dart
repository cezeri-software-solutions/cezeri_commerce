import 'product.dart';

class HomeProduct {
  final String supplier;
  final String manufacturer;
  final List<Product> listOfProducts;

  const HomeProduct({
    required this.supplier,
    required this.manufacturer,
    required this.listOfProducts,
  });

  factory HomeProduct.empty() {
    return const HomeProduct(supplier: '', manufacturer: '', listOfProducts: []);
  }

  HomeProduct copyWith({
    String? supplier,
    String? manufacturer,
    List<Product>? listOfProducts,
  }) {
    return HomeProduct(
      supplier: supplier ?? this.supplier,
      manufacturer: manufacturer ?? this.manufacturer,
      listOfProducts: listOfProducts ?? this.listOfProducts,
    );
  }

  @override
  String toString() => 'HomeProduct(supplier: $supplier, manufacturer: $manufacturer, listOfProducts: $listOfProducts)';
}
