// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metafield_shopify.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetafieldShopify _$MetafieldShopifyFromJson(Map<String, dynamic> json) =>
    MetafieldShopify(
      createdAt: DateTime.parse(json['created_at'] as String),
      description: json['description'] as String?,
      id: (json['id'] as num).toInt(),
      key: json['key'] as String,
      namespace: json['namespace'] as String,
      ownerId: (json['owner_id'] as num).toInt(),
      ownerResource: json['owner_resource'] as String,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      value: json['value'],
      type: json['type'],
    );

Map<String, dynamic> _$MetafieldShopifyToJson(MetafieldShopify instance) =>
    <String, dynamic>{
      'created_at': instance.createdAt.toIso8601String(),
      'description': instance.description,
      'id': instance.id,
      'key': instance.key,
      'namespace': instance.namespace,
      'owner_id': instance.ownerId,
      'owner_resource': instance.ownerResource,
      'updated_at': instance.updatedAt.toIso8601String(),
      'value': instance.value,
      'type': instance.type,
    };
