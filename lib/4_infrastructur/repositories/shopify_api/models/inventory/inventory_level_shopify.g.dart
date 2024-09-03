// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_level_shopify.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryLevelShopify _$InventoryLevelShopifyFromJson(
        Map<String, dynamic> json) =>
    InventoryLevelShopify(
      available: (json['available'] as num?)?.toInt(),
      inventoryItemId: (json['inventory_item_id'] as num).toInt(),
      locationId: (json['location_id'] as num).toInt(),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$InventoryLevelShopifyToJson(
        InventoryLevelShopify instance) =>
    <String, dynamic>{
      'available': instance.available,
      'inventory_item_id': instance.inventoryItemId,
      'location_id': instance.locationId,
      'updated_at': instance.updatedAt.toIso8601String(),
    };
