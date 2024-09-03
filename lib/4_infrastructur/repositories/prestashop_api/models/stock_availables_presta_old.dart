class StockAvailablesPrestaOld {
  final int idProduct;
  final int idProductAttribute;
  final int idShop;
  final int idShopGroup;
  final int quantity;
  final int dependsOnStock;
  final int outOfStock;
  final String location;

  const StockAvailablesPrestaOld({
    required this.idProduct,
    required this.idProductAttribute,
    required this.idShop,
    required this.idShopGroup,
    required this.quantity,
    required this.dependsOnStock,
    required this.outOfStock,
    required this.location,
  });

  StockAvailablesPrestaOld copyWith({
    int? idProduct,
    int? idProductAttribute,
    int? idShop,
    int? idShopGroup,
    int? quantity,
    int? dependsOnStock,
    int? outOfStock,
    String? location,
  }) {
    return StockAvailablesPrestaOld(
      idProduct: idProduct ?? this.idProduct,
      idProductAttribute: idProductAttribute ?? this.idProductAttribute,
      idShop: idShop ?? this.idShop,
      idShopGroup: idShopGroup ?? this.idShopGroup,
      quantity: quantity ?? this.quantity,
      dependsOnStock: dependsOnStock ?? this.dependsOnStock,
      outOfStock: outOfStock ?? this.outOfStock,
      location: location ?? this.location,
    );
  }

  @override
  String toString() {
    return 'StockAvailablesPresta(idProduct: $idProduct, idProductAttribute: $idProductAttribute, idShop: $idShop, idShopGroup: $idShopGroup, quantity: $quantity, dependsOnStock: $dependsOnStock, outOfStock: $outOfStock, location: $location)';
  }
}
