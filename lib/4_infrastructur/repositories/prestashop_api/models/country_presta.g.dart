// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_presta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountriesPresta _$CountriesPrestaFromJson(Map<String, dynamic> json) =>
    CountriesPresta(
      items: (json['countries'] as List<dynamic>)
          .map((e) => CountryPresta.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CountriesPrestaToJson(CountriesPresta instance) =>
    <String, dynamic>{
      'countries': instance.items,
    };

CountryPresta _$CountryPrestaFromJson(Map<String, dynamic> json) =>
    CountryPresta(
      id: (json['id'] as num).toInt(),
      idZone: json['id_zone'] as String,
      idCurrency: json['id_currency'] as String,
      callPrefix: json['call_prefix'] as String,
      isoCode: json['iso_code'] as String,
      active: json['active'] as String,
      containsStates: json['contains_states'] as String,
      needIdentificationNumber: json['need_identification_number'] as String,
      needZipCode: json['need_zip_code'] as String,
      zipCodeFormat: json['zip_code_format'] as String,
      displayTaxLabel: json['display_tax_label'] as String,
      name: CountryPresta._nameFromJson(json['name']),
    );

Map<String, dynamic> _$CountryPrestaToJson(CountryPresta instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_zone': instance.idZone,
      'id_currency': instance.idCurrency,
      'call_prefix': instance.callPrefix,
      'iso_code': instance.isoCode,
      'active': instance.active,
      'contains_states': instance.containsStates,
      'need_identification_number': instance.needIdentificationNumber,
      'need_zip_code': instance.needZipCode,
      'zip_code_format': instance.zipCodeFormat,
      'display_tax_label': instance.displayTaxLabel,
      'name': instance.name,
    };
