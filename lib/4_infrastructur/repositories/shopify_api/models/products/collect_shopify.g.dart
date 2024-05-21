// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collect_shopify.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollectShopify _$CollectShopifyFromJson(Map<String, dynamic> json) =>
    CollectShopify(
      collectionId: (json['collection_id'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      id: (json['id'] as num).toInt(),
      position: (json['position'] as num).toInt(),
      productId: (json['product_id'] as num).toInt(),
      sortValue: json['sort_value'] as String,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$CollectShopifyToJson(CollectShopify instance) =>
    <String, dynamic>{
      'collection_id': instance.collectionId,
      'created_at': instance.createdAt.toIso8601String(),
      'id': instance.id,
      'position': instance.position,
      'product_id': instance.productId,
      'sort_value': instance.sortValue,
      'updated_at': instance.updatedAt.toIso8601String(),
    };
