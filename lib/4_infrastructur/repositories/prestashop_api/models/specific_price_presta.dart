import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'specific_price_presta.g.dart';

@JsonSerializable()
class SpecificPricesPresta {
  static const _encoder = JsonEncoder.withIndent('  ');

  @JsonKey(name: 'specific_prices')
  final List<SpecificPricePresta> items;

  const SpecificPricesPresta({required this.items});

  factory SpecificPricesPresta.fromJson(Map<String, dynamic> json) => _$SpecificPricesPrestaFromJson(json);

  Map<String, dynamic> toJson() => _$SpecificPricesPrestaToJson(this);

  @override
  String toString() => _encoder.convert(toJson());
}

@JsonSerializable()
class SpecificPricePresta {
  static const _encoder = JsonEncoder.withIndent('  ');

  final int id;
  @JsonKey(name: 'id_shop_group')
  final String idShopGroup;
  @JsonKey(name: 'id_shop')
  final String idShop;
  @JsonKey(name: 'id_cart')
  final String idCart;
  @JsonKey(name: 'id_product')
  final String idProduct;
  @JsonKey(name: 'id_product_attribute')
  final String idProductAttribute;
  @JsonKey(name: 'id_currency')
  final String idCurrency;
  @JsonKey(name: 'id_country')
  final String idCountry;
  @JsonKey(name: 'id_group')
  final String idGroup;
  @JsonKey(name: 'id_customer')
  final String idCustomer;
  @JsonKey(name: 'id_specific_price_rule')
  final String idSpecificPriceRule;
  final String price;
  @JsonKey(name: 'from_quantity')
  final String fromQuantity;
  final String reduction;
  @JsonKey(name: 'reduction_tax')
  final String reductionTax;
  @JsonKey(name: 'reduction_type')
  final String reductionType;
  final String from;
  final String to;

  const SpecificPricePresta({
    required this.id,
    required this.idShopGroup,
    required this.idShop,
    required this.idCart,
    required this.idProduct,
    required this.idProductAttribute,
    required this.idCurrency,
    required this.idCountry,
    required this.idGroup,
    required this.idCustomer,
    required this.idSpecificPriceRule,
    required this.price,
    required this.fromQuantity,
    required this.reduction,
    required this.reductionTax,
    required this.reductionType,
    required this.from,
    required this.to,
  });

  factory SpecificPricePresta.fromJson(Map<String, dynamic> json) => _$SpecificPricePrestaFromJson(json);

  Map<String, dynamic> toJson() => _$SpecificPricePrestaToJson(this);

  List<Object?> get props => [id];

  @override
  String toString() => _encoder.convert(toJson());
}
