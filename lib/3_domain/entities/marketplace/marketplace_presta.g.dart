// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marketplace_presta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketplacePresta _$MarketplacePrestaFromJson(Map<String, dynamic> json) =>
    MarketplacePresta(
      id: json['id'] as String,
      name: json['name'] as String,
      shortName: json['shortName'] as String,
      logoUrl: json['logoUrl'] as String,
      isPresta8: json['isPresta8'] as bool,
      endpointUrl: json['endpointUrl'] as String,
      url: json['url'] as String,
      shopSuffix: json['shopSuffix'] as String,
      key: json['key'] as String,
      isActive: json['isActive'] as bool,
      orderStatusIdList: (json['orderStatusIdList'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      orderStatusOnSuccessImport:
          (json['orderStatusOnSuccessImport'] as num?)?.toInt(),
      orderStatusOnSuccessShipping:
          (json['orderStatusOnSuccessShipping'] as num?)?.toInt(),
      warehouseForProductImport: json['warehouseForProductImport'] as String,
      createMissingProductOnOrderImport:
          json['createMissingProductOnOrderImport'] as bool,
      marketplaceSettings: MarketplaceSettings.fromJson(
          json['marketplaceSettings'] as Map<String, dynamic>),
      paymentMethods: (json['paymentMethods'] as List<dynamic>)
          .map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
          .toList(),
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      bankDetails:
          BankDetails.fromJson(json['bankDetails'] as Map<String, dynamic>),
      lastEditingDate: DateTime.parse(json['lastEditingDate'] as String),
      createnDate: DateTime.parse(json['createnDate'] as String),
    );

Map<String, dynamic> _$MarketplacePrestaToJson(MarketplacePresta instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'shortName': instance.shortName,
      'logoUrl': instance.logoUrl,
      'isActive': instance.isActive,
      'address': instance.address.toJson(),
      'marketplaceSettings': instance.marketplaceSettings.toJson(),
      'bankDetails': instance.bankDetails.toJson(),
      'lastEditingDate': instance.lastEditingDate.toIso8601String(),
      'createnDate': instance.createnDate.toIso8601String(),
      'isPresta8': instance.isPresta8,
      'endpointUrl': instance.endpointUrl,
      'url': instance.url,
      'shopSuffix': instance.shopSuffix,
      'key': instance.key,
      'orderStatusIdList': instance.orderStatusIdList,
      'orderStatusOnSuccessImport': instance.orderStatusOnSuccessImport,
      'orderStatusOnSuccessShipping': instance.orderStatusOnSuccessShipping,
      'warehouseForProductImport': instance.warehouseForProductImport,
      'createMissingProductOnOrderImport':
          instance.createMissingProductOnOrderImport,
      'paymentMethods': instance.paymentMethods.map((e) => e.toJson()).toList(),
    };
