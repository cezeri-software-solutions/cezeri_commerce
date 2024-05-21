// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_presta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LanguagesPresta _$LanguagesPrestaFromJson(Map<String, dynamic> json) =>
    LanguagesPresta(
      items: (json['languages'] as List<dynamic>)
          .map((e) => LanguagePresta.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LanguagesPrestaToJson(LanguagesPresta instance) =>
    <String, dynamic>{
      'languages': instance.items,
    };

LanguagePresta _$LanguagePrestaFromJson(Map<String, dynamic> json) =>
    LanguagePresta(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      isoCode: json['iso_code'] as String,
      locale: json['locale'] as String,
      languageCode: json['language_code'] as String,
      active: json['active'] as String,
      isRtl: json['is_rtl'] as String,
      dateFormatLite: json['date_format_lite'] as String,
      dateFormatFull: json['date_format_full'] as String,
    );

Map<String, dynamic> _$LanguagePrestaToJson(LanguagePresta instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'iso_code': instance.isoCode,
      'locale': instance.locale,
      'language_code': instance.languageCode,
      'active': instance.active,
      'is_rtl': instance.isRtl,
      'date_format_lite': instance.dateFormatLite,
      'date_format_full': instance.dateFormatFull,
    };
