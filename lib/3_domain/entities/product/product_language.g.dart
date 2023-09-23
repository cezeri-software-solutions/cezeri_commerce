// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_language.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductLanguage _$ProductLanguageFromJson(Map<String, dynamic> json) =>
    ProductLanguage(
      id: json['id'] as int,
      description: json['description'] as String,
      isoCode: json['isoCode'] as String,
    );

Map<String, dynamic> _$ProductLanguageToJson(ProductLanguage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'isoCode': instance.isoCode,
    };
