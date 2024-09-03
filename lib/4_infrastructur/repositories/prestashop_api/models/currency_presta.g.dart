// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_presta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrenciesPresta _$CurrenciesPrestaFromJson(Map<String, dynamic> json) =>
    CurrenciesPresta(
      items: (json['currencies'] as List<dynamic>)
          .map((e) => CurrencyPresta.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CurrenciesPrestaToJson(CurrenciesPresta instance) =>
    <String, dynamic>{
      'currencies': instance.items,
    };

CurrencyPresta _$CurrencyPrestaFromJson(Map<String, dynamic> json) =>
    CurrencyPresta(
      id: (json['id'] as num).toInt(),
      names: CurrencyPresta._namesFromJson(json['names']),
      name: json['name'] as String,
      symbol: CurrencyPresta._symbolFromJson(json['symbol']),
      isoCode: json['iso_code'] as String,
      numericIsoCode: json['numeric_iso_code'] as String,
      precision: json['precision'] as String,
      conversionRate: json['conversion_rate'] as String,
      deleted: json['deleted'] as String,
      active: json['active'] as String,
      unofficial: json['unofficial'] as String,
      modified: json['modified'] as String,
      pattern: CurrencyPresta._patternFromJson(json['pattern']),
    );

Map<String, dynamic> _$CurrencyPrestaToJson(CurrencyPresta instance) =>
    <String, dynamic>{
      'id': instance.id,
      'names': instance.names,
      'name': instance.name,
      'symbol': instance.symbol,
      'iso_code': instance.isoCode,
      'numeric_iso_code': instance.numericIsoCode,
      'precision': instance.precision,
      'conversion_rate': instance.conversionRate,
      'deleted': instance.deleted,
      'active': instance.active,
      'unofficial': instance.unofficial,
      'modified': instance.modified,
      'pattern': instance.pattern,
    };
