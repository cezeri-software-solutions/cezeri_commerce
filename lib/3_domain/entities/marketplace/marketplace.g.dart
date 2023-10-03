// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marketplace.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Marketplace _$MarketplaceFromJson(Map<String, dynamic> json) => Marketplace(
      id: json['id'] as String,
      name: json['name'] as String,
      shortName: json['shortName'] as String,
      logoUrl: json['logoUrl'] as String,
      marketplaceType: json['marketplaceType'] as String,
      endpointUrl: json['endpointUrl'] as String,
      url: json['url'] as String,
      shopSuffix: json['shopSuffix'] as String,
      fullUrl: json['fullUrl'] as String,
      key: json['key'] as String,
      isActive: json['isActive'] as bool,
      orderStatusIdList: (json['orderStatusIdList'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      orderStatusOnSuccessImport: json['orderStatusOnSuccessImport'] as int?,
      orderStatusOnSuccessShipping:
          json['orderStatusOnSuccessShipping'] as int?,
      warehouseForProductImport: json['warehouseForProductImport'] as String,
      createMissingProductOnOrderImport:
          json['createMissingProductOnOrderImport'] as bool,
      marketplaceSettings: MarketplaceSettings.fromJson(
          json['marketplaceSettings'] as Map<String, dynamic>),
      paymentMethods: (json['paymentMethods'] as List<dynamic>)
          .map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastEditingDate: DateTime.parse(json['lastEditingDate'] as String),
      createnDate: DateTime.parse(json['createnDate'] as String),
    );

Map<String, dynamic> _$MarketplaceToJson(Marketplace instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'shortName': instance.shortName,
      'logoUrl': instance.logoUrl,
      'marketplaceType': instance.marketplaceType,
      'endpointUrl': instance.endpointUrl,
      'url': instance.url,
      'shopSuffix': instance.shopSuffix,
      'fullUrl': instance.fullUrl,
      'key': instance.key,
      'isActive': instance.isActive,
      'orderStatusIdList': instance.orderStatusIdList,
      'orderStatusOnSuccessImport': instance.orderStatusOnSuccessImport,
      'orderStatusOnSuccessShipping': instance.orderStatusOnSuccessShipping,
      'warehouseForProductImport': instance.warehouseForProductImport,
      'createMissingProductOnOrderImport':
          instance.createMissingProductOnOrderImport,
      'marketplaceSettings': instance.marketplaceSettings.toJson(),
      'paymentMethods': instance.paymentMethods.map((e) => e.toJson()).toList(),
      'lastEditingDate': instance.lastEditingDate.toIso8601String(),
      'createnDate': instance.createnDate.toIso8601String(),
    };
