// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marketplace_shop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketplaceShop _$MarketplaceShopFromJson(Map<String, dynamic> json) =>
    MarketplaceShop(
      id: json['id'] as String,
      name: json['name'] as String,
      shortName: json['shortName'] as String,
      logoUrl: json['logoUrl'] as String,
      isActive: json['isActive'] as bool,
      defaultCustomerId: json['defaultCustomerId'] as String?,
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      marketplaceSettings: MarketplaceSettings.fromJson(
          json['marketplaceSettings'] as Map<String, dynamic>),
      bankDetails:
          BankDetails.fromJson(json['bankDetails'] as Map<String, dynamic>),
      lastEditingDate: DateTime.parse(json['lastEditingDate'] as String),
      createnDate: DateTime.parse(json['createnDate'] as String),
    );

Map<String, dynamic> _$MarketplaceShopToJson(MarketplaceShop instance) =>
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
      'defaultCustomerId': instance.defaultCustomerId,
    };
