// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_id_with_quantity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductIdWithQuantity _$ProductIdWithQuantityFromJson(
        Map<String, dynamic> json) =>
    ProductIdWithQuantity(
      productId: json['productId'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$ProductIdWithQuantityToJson(
        ProductIdWithQuantity instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'quantity': instance.quantity,
    };
