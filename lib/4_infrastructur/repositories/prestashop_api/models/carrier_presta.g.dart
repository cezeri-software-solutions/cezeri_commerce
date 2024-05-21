// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carrier_presta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarriersPresta _$CarriersPrestaFromJson(Map<String, dynamic> json) =>
    CarriersPresta(
      items: (json['carriers'] as List<dynamic>)
          .map((e) => CarrierPresta.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CarriersPrestaToJson(CarriersPresta instance) =>
    <String, dynamic>{
      'carriers': instance.items,
    };

CarrierPresta _$CarrierPrestaFromJson(Map<String, dynamic> json) =>
    CarrierPresta(
      id: (json['id'] as num).toInt(),
      deleted: json['deleted'] as String,
      isModule: json['is_module'] as String,
      idTaxRulesGroup:
          CarrierPresta._idTaxRulesGroupFromJson(json['id_tax_rules_group']),
      idReference: json['id_reference'] as String,
      name: json['name'] as String,
      active: json['active'] as String,
      isFree: json['is_free'] as String,
      url: json['url'] as String,
      shippingHandling: json['shipping_handling'] as String,
      shippingExternal: json['shipping_external'] as String,
      rangeBehavior: json['range_behavior'] as String,
      shippingMethod: json['shipping_method'] as String,
      maxWidth: json['max_width'] as String,
      maxHeight: json['max_height'] as String,
      maxDepth: json['max_depth'] as String,
      maxWeight: json['max_weight'] as String,
      grade: json['grade'] as String,
      externalModuleName: json['external_module_name'] as String,
      needRange: json['need_range'] as String,
      position: json['position'] as String,
    );

Map<String, dynamic> _$CarrierPrestaToJson(CarrierPresta instance) =>
    <String, dynamic>{
      'id': instance.id,
      'deleted': instance.deleted,
      'is_module': instance.isModule,
      'id_tax_rules_group': instance.idTaxRulesGroup,
      'id_reference': instance.idReference,
      'name': instance.name,
      'active': instance.active,
      'is_free': instance.isFree,
      'url': instance.url,
      'shipping_handling': instance.shippingHandling,
      'shipping_external': instance.shippingExternal,
      'range_behavior': instance.rangeBehavior,
      'shipping_method': instance.shippingMethod,
      'max_width': instance.maxWidth,
      'max_height': instance.maxHeight,
      'max_depth': instance.maxDepth,
      'max_weight': instance.maxWeight,
      'grade': instance.grade,
      'external_module_name': instance.externalModuleName,
      'need_range': instance.needRange,
      'position': instance.position,
    };
