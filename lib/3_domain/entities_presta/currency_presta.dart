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
  @JsonKey(fromJson: _namesFromJson)
  final String names;
  final String name;
  @JsonKey(fromJson: _symbolFromJson)
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
  @JsonKey(fromJson: _patternFromJson)
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

  static String _namesFromJson(dynamic names) {
    if (names is List) {
      return (names).map((e) => e['value']).toList().first as String;
    }
    return names as String;
  }

  static String _symbolFromJson(dynamic symbol) {
    if (symbol is List) {
      return (symbol).map((e) => e['value']).toList().first as String;
    }
    return symbol as String;
  }

  static String _patternFromJson(dynamic pattern) {
    if (pattern is List) {
      return (pattern).map((e) => e['value']).toList().first as String;
    }
    return pattern as String;
  }

  factory CurrencyPresta.fromJson(Map<String, dynamic> json) => _$CurrencyPrestaFromJson(json);
  Map<String, dynamic> toJson() => _$CurrencyPrestaToJson(this);

  List<Object?> get props => [id];

  @override
  String toString() => _encoder.convert(toJson());
}
