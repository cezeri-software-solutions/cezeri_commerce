// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_marketplace.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReceiptMarketplace _$ReceiptMarketplaceFromJson(Map<String, dynamic> json) =>
    ReceiptMarketplace(
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      bankDetails:
          BankDetails.fromJson(json['bankDetails'] as Map<String, dynamic>),
      url: json['url'] as String,
    );

Map<String, dynamic> _$ReceiptMarketplaceToJson(ReceiptMarketplace instance) =>
    <String, dynamic>{
      'address': instance.address.toJson(),
      'bankDetails': instance.bankDetails.toJson(),
      'url': instance.url,
    };
