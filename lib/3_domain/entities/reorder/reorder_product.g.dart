// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reorder_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReorderProduct _$ReorderProductFromJson(Map<String, dynamic> json) =>
    ReorderProduct(
      productId: json['productId'] as String,
      pos: json['pos'] as int,
      name: json['name'] as String,
      articleNumber: json['articleNumber'] as String,
      ean: json['ean'] as String,
      tax: Tax.fromJson(json['tax'] as Map<String, dynamic>),
      wholesalePriceNet: (json['wholesalePriceNet'] as num).toDouble(),
      wholesalePriceGross: (json['wholesalePriceGross'] as num).toDouble(),
      quantity: json['quantity'] as int,
      bookedQuantity: json['bookedQuantity'] as int,
      isFromDatabase: json['isFromDatabase'] as bool,
    );

Map<String, dynamic> _$ReorderProductToJson(ReorderProduct instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'pos': instance.pos,
      'name': instance.name,
      'articleNumber': instance.articleNumber,
      'ean': instance.ean,
      'tax': instance.tax.toJson(),
      'wholesalePriceNet': instance.wholesalePriceNet,
      'wholesalePriceGross': instance.wholesalePriceGross,
      'quantity': instance.quantity,
      'bookedQuantity': instance.bookedQuantity,
      'isFromDatabase': instance.isFromDatabase,
    };
