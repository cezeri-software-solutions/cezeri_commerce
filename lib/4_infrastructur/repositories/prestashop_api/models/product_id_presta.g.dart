// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_id_presta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductsIdPresta _$ProductsIdPrestaFromJson(Map<String, dynamic> json) =>
    ProductsIdPresta(
      items: (json['products'] as List<dynamic>)
          .map((e) => ProductIdPresta.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductsIdPrestaToJson(ProductsIdPresta instance) =>
    <String, dynamic>{
      'products': instance.items,
    };

ProductIdPresta _$ProductIdPrestaFromJson(Map<String, dynamic> json) =>
    ProductIdPresta(
      id: (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$ProductIdPrestaToJson(ProductIdPresta instance) =>
    <String, dynamic>{
      'id': instance.id,
    };
