// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tax _$TaxFromJson(Map<String, dynamic> json) => Tax(
      taxId: json['taxId'] as String,
      taxName: json['taxName'] as String,
      taxRate: (json['taxRate'] as num).toInt(),
      country: Country.fromJson(json['country'] as Map<String, dynamic>),
      isDefault: json['isDefault'] as bool,
    );

Map<String, dynamic> _$TaxToJson(Tax instance) => <String, dynamic>{
      'taxId': instance.taxId,
      'taxName': instance.taxName,
      'taxRate': instance.taxRate,
      'country': instance.country.toJson(),
      'isDefault': instance.isDefault,
    };
