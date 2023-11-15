import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'stock_available_presta.g.dart';

@JsonSerializable()
class StockAvailablesPresta {
  static const _encoder = JsonEncoder.withIndent('  ');

  @JsonKey(name: 'stock_availables')
  final List<StockAvailablePresta> items;

  const StockAvailablesPresta({required this.items});

  factory StockAvailablesPresta.fromJson(Map<String, dynamic> json) => _$StockAvailablesPrestaFromJson(json);
  Map<String, dynamic> toJson() => _$StockAvailablesPrestaToJson(this);

  @override
  String toString() => _encoder.convert(toJson());
}

@JsonSerializable()
class StockAvailablePresta {
  static const _encoder = JsonEncoder.withIndent('  ');

  final int id;
  @JsonKey(name: 'id_product')
  final String idProduct;
  @JsonKey(name: 'id_product_attribute')
  final String idProductAttribute;
  @JsonKey(name: 'id_shop')
  final String idShop;
  @JsonKey(name: 'id_shop_group')
  final String idShopGroup;
  final String quantity;
  @JsonKey(name: 'depends_on_stock')
  final String dependsOnStock;
  @JsonKey(name: 'out_of_stock')
  final String outOfStock;
  final String location;

  const StockAvailablePresta({
    required this.id,
    required this.idProduct,
    required this.idProductAttribute,
    required this.idShop,
    required this.idShopGroup,
    required this.quantity,
    required this.dependsOnStock,
    required this.outOfStock,
    required this.location,
  });

  factory StockAvailablePresta.fromJson(Map<String, dynamic> json) => _$StockAvailablePrestaFromJson(json);
  Map<String, dynamic> toJson() => _$StockAvailablePrestaToJson(this);

  List<Object?> get props => [id];

  @override
  String toString() => _encoder.convert(toJson());
}
