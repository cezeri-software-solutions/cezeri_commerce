// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marketplace_shopify.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketplaceShopify _$MarketplaceShopifyFromJson(Map<String, dynamic> json) =>
    MarketplaceShopify(
      id: json['id'] as String,
      name: json['name'] as String,
      shortName: json['shortName'] as String,
      logoUrl: json['logoUrl'] as String,
      endpointUrl: json['endpointUrl'] as String,
      storeName: json['storeName'] as String,
      shopSuffix: json['shopSuffix'] as String,
      url: json['url'] as String,
      adminAccessToken: json['adminAccessToken'] as String,
      storefrontAccessToken: json['storefrontAccessToken'] as String,
      isActive: json['isActive'] as bool,
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

Map<String, dynamic> _$MarketplaceShopifyToJson(MarketplaceShopify instance) =>
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
      'endpointUrl': instance.endpointUrl,
      'storeName': instance.storeName,
      'shopSuffix': instance.shopSuffix,
      'url': instance.url,
      'adminAccessToken': instance.adminAccessToken,
      'storefrontAccessToken': instance.storefrontAccessToken,
      'paymentMethods': instance.paymentMethods.map((e) => e.toJson()).toList(),
    };
