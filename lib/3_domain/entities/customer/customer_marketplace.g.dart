// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_marketplace.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerMarketplace _$CustomerMarketplaceFromJson(Map<String, dynamic> json) =>
    CustomerMarketplace(
      marketplaceId: json['marketplaceId'] as String,
      marketplaceName: json['marketplaceName'] as String,
      customerIdMarketplace: (json['customerIdMarketplace'] as num).toInt(),
      isNewsletterAccepted: json['isNewsletterAccepted'] as bool,
      isGuest: json['isGuest'] as bool,
    );

Map<String, dynamic> _$CustomerMarketplaceToJson(
        CustomerMarketplace instance) =>
    <String, dynamic>{
      'marketplaceId': instance.marketplaceId,
      'marketplaceName': instance.marketplaceName,
      'customerIdMarketplace': instance.customerIdMarketplace,
      'isNewsletterAccepted': instance.isNewsletterAccepted,
      'isGuest': instance.isGuest,
    };
