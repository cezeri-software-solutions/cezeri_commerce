// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tax _$TaxFromJson(Map<String, dynamic> json) => Tax(
      taxId: json['taxId'] as String,
      taxName: json['taxName'] as String,
      taxRate: json['taxRate'] as int,
      country: json['country'] as String,
      countryIsoCode: json['countryIsoCode'] as String,
      isDefault: json['isDefault'] as bool,
    );

Map<String, dynamic> _$TaxToJson(Tax instance) => <String, dynamic>{
      'taxId': instance.taxId,
      'taxName': instance.taxName,
      'taxRate': instance.taxRate,
      'country': instance.country,
      'countryIsoCode': instance.countryIsoCode,
      'isDefault': instance.isDefault,
    };
