import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'currency_presta.g.dart';

@JsonSerializable()
class CurrenciesPresta {
  static const _encoder = JsonEncoder.withIndent('  ');

  @JsonKey(name: 'currencies')
  final List<CurrencyPresta> items;

  const CurrenciesPresta({required this.items});

  factory CurrenciesPresta.fromJson(Map<String, dynamic> json) => _$CurrenciesPrestaFromJson(json);
  Map<String, dynamic> toJson() => _$CurrenciesPrestaToJson(this);

  List<Object?> get props => [items];

  @override
  String toString() => _encoder.convert(toJson());
}

@JsonSerializable()
class CurrencyPresta {
  static const _encoder = JsonEncoder.withIndent('  ');

  final int id;
  final String names;
  final String name;
  final String symbol;
  @JsonKey(name: 'iso_code')
  final String isoCode;
  @JsonKey(name: 'numeric_iso_code')
  final String numericIsoCode;
  final String precision;
  @JsonKey(name: 'conversion_rate')
  final String conversionRate;
  final String deleted;
  final String active;
  final String unofficial;
  final String modified;
  final String pattern;

  const CurrencyPresta({
    required this.id,
    required this.names,
    required this.name,
    required this.symbol,
    required this.isoCode,
    required this.numericIsoCode,
    required this.precision,
    required this.conversionRate,
    required this.deleted,
    required this.active,
    required this.unofficial,
    required this.modified,
    required this.pattern,
  });

  factory CurrencyPresta.fromJson(Map<String, dynamic> json) => _$CurrencyPrestaFromJson(json);
  Map<String, dynamic> toJson() => _$CurrencyPrestaToJson(this);

  List<Object?> get props => [id];

  @override
  String toString() => _encoder.convert(toJson());
}
