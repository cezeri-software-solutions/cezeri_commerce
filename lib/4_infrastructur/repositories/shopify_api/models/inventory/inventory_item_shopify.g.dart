// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_item_shopify.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryItemShopify _$InventoryItemShopifyFromJson(
        Map<String, dynamic> json) =>
    InventoryItemShopify(
      cost: (json['cost'] as num?)?.toDouble(),
      countryCodeOfOrigin: json['country_code_of_origin'] as String?,
      countryHarmonizedSystemCodes:
          (json['country_harmonized_system_codes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      harmonizedSystemCode: json['harmonized_system_code'] as String?,
      id: (json['id'] as num).toInt(),
      provinceCodeOfOrigin: json['province_code_of_origin'] as String?,
      sku: json['sku'] as String,
      tracked: json['tracked'] as bool,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      requiresShipping: json['requires_shipping'] as bool,
    );

Map<String, dynamic> _$InventoryItemShopifyToJson(
        InventoryItemShopify instance) =>
    <String, dynamic>{
      'cost': instance.cost,
      'country_code_of_origin': instance.countryCodeOfOrigin,
      'country_harmonized_system_codes': instance.countryHarmonizedSystemCodes,
      'created_at': instance.createdAt.toIso8601String(),
      'harmonized_system_code': instance.harmonizedSystemCode,
      'id': instance.id,
      'province_code_of_origin': instance.provinceCodeOfOrigin,
      'sku': instance.sku,
      'tracked': instance.tracked,
      'updated_at': instance.updatedAt.toIso8601String(),
      'requires_shipping': instance.requiresShipping,
    };
