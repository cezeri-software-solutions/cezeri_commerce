// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_language.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FieldLanguage _$FieldLanguageFromJson(Map<String, dynamic> json) =>
    FieldLanguage(
      id: (json['id'] as num).toInt(),
      value: json['value'] as String,
      isoCode: json['isoCode'] as String,
    );

Map<String, dynamic> _$FieldLanguageToJson(FieldLanguage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
      'isoCode': instance.isoCode,
    };
