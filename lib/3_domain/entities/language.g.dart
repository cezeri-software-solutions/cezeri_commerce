// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Language _$LanguageFromJson(Map<String, dynamic> json) => Language(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      nameEnglish: json['nameEnglish'] as String,
      nameNative: json['nameNative'] as String,
      isoCode: json['isoCode'] as String,
      isActive: json['isActive'] as bool,
      isDefault: json['isDefault'] as bool,
    );

Map<String, dynamic> _$LanguageToJson(Language instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nameEnglish': instance.nameEnglish,
      'nameNative': instance.nameNative,
      'isoCode': instance.isoCode,
      'isActive': instance.isActive,
      'isDefault': instance.isDefault,
    };
