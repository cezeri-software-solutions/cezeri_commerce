// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picklist_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PicklistProduct _$PicklistProductFromJson(Map<String, dynamic> json) =>
    PicklistProduct(
      productId: json['productId'] as String,
      quantity: json['quantity'] as int,
      pickedQuantity: json['pickedQuantity'] as int,
      imageUrl: json['imageUrl'] as String?,
      name: json['name'] as String,
      articleNumber: json['articleNumber'] as String,
      ean: json['ean'] as String,
      customization: json['customization'] as int,
      weight: (json['weight'] as num).toDouble(),
    );

Map<String, dynamic> _$PicklistProductToJson(PicklistProduct instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'quantity': instance.quantity,
      'pickedQuantity': instance.pickedQuantity,
      'imageUrl': instance.imageUrl,
      'name': instance.name,
      'articleNumber': instance.articleNumber,
      'ean': instance.ean,
      'customization': instance.customization,
      'weight': instance.weight,
    };
