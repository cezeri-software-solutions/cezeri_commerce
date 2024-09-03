// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Country _$CountryFromJson(Map<String, dynamic> json) => Country(
      id: json['id'] as String,
      isoCode: json['isoCode'] as String,
      name: json['name'] as String,
      nameEnglish: json['nameEnglish'] as String,
      dialCode: json['dialCode'] as String,
    );

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
      'id': instance.id,
      'isoCode': instance.isoCode,
      'name': instance.name,
      'nameEnglish': instance.nameEnglish,
      'dialCode': instance.dialCode,
    };
