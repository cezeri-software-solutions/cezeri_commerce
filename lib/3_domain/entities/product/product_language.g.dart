// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_language.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductLanguage _$ProductLanguageFromJson(Map<String, dynamic> json) =>
    ProductLanguage(
      id: json['id'] as int,
      value: json['value'] as String,
      isoCode: json['isoCode'] as String,
    );

Map<String, dynamic> _$ProductLanguageToJson(ProductLanguage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
      'isoCode': instance.isoCode,
    };
