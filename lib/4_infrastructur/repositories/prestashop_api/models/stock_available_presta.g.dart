// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_available_presta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockAvailablesPresta _$StockAvailablesPrestaFromJson(
        Map<String, dynamic> json) =>
    StockAvailablesPresta(
      items: (json['stock_availables'] as List<dynamic>)
          .map((e) => StockAvailablePresta.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StockAvailablesPrestaToJson(
        StockAvailablesPresta instance) =>
    <String, dynamic>{
      'stock_availables': instance.items,
    };

StockAvailablePresta _$StockAvailablePrestaFromJson(
        Map<String, dynamic> json) =>
    StockAvailablePresta(
      id: (json['id'] as num).toInt(),
      idProduct: json['id_product'] as String,
      idProductAttribute: json['id_product_attribute'] as String,
      idShop: json['id_shop'] as String,
      idShopGroup: json['id_shop_group'] as String,
      quantity: json['quantity'] as String,
      dependsOnStock: json['depends_on_stock'] as String,
      outOfStock: json['out_of_stock'] as String,
      location: json['location'] as String,
    );

Map<String, dynamic> _$StockAvailablePrestaToJson(
        StockAvailablePresta instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_product': instance.idProduct,
      'id_product_attribute': instance.idProductAttribute,
      'id_shop': instance.idShop,
      'id_shop_group': instance.idShopGroup,
      'quantity': instance.quantity,
      'depends_on_stock': instance.dependsOnStock,
      'out_of_stock': instance.outOfStock,
      'location': instance.location,
    };
