// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetProduct _$SetProductFromJson(Map<String, dynamic> json) => SetProduct(
      id: json['id'] as String,
      articleNumber: json['articleNumber'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$SetProductToJson(SetProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'articleNumber': instance.articleNumber,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'quantity': instance.quantity,
    };
