import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../../../../3_domain/entities/country.dart';

part 'country_presta.g.dart';

@JsonSerializable()
class CountriesPresta {
  static const _encoder = JsonEncoder.withIndent('  ');

  @JsonKey(name: 'countries')
  final List<CountryPresta> items;

  const CountriesPresta({required this.items});

  factory CountriesPresta.fromJson(Map<String, dynamic> json) => _$CountriesPrestaFromJson(json);
  Map<String, dynamic> toJson() => _$CountriesPrestaToJson(this);

  List<Object?> get props => [items];

  @override
  String toString() => _encoder.convert(toJson());
}

@JsonSerializable()
class CountryPresta {
  static const _encoder = JsonEncoder.withIndent('  ');

  final int id;
  @JsonKey(name: 'id_zone')
  final String idZone;
  @JsonKey(name: 'id_currency')
  final String idCurrency;
  @JsonKey(name: 'call_prefix')
  final String callPrefix;
  @JsonKey(name: 'iso_code')
  final String isoCode;
  final String active;
  @JsonKey(name: 'contains_states')
  final String containsStates;
  @JsonKey(name: 'need_identification_number')
  final String needIdentificationNumber;
  @JsonKey(name: 'need_zip_code')
  final String needZipCode;
  @JsonKey(name: 'zip_code_format')
  final String zipCodeFormat;
  @JsonKey(name: 'display_tax_label')
  final String displayTaxLabel;
  @JsonKey(fromJson: _nameFromJson)
  final String name;

  const CountryPresta({
    required this.id,
    required this.idZone,
    required this.idCurrency,
    required this.callPrefix,
    required this.isoCode,
    required this.active,
    required this.containsStates,
    required this.needIdentificationNumber,
    required this.needZipCode,
    required this.zipCodeFormat,
    required this.displayTaxLabel,
    required this.name,
  });

  static String _nameFromJson(dynamic name) {
    if (name is List) {
      final List<String> values = name.map((e) => e['value'] as String).toList();
      final countries = Country.countryList.map((e) => e.name).toList();
      final toReturnValue = values.firstWhere((e) => countries.contains(e), orElse: () => '');
      return toReturnValue;
    }
    return name as String;
  }

  factory CountryPresta.fromJson(Map<String, dynamic> json) => _$CountryPrestaFromJson(json);
  Map<String, dynamic> toJson() => _$CountryPrestaToJson(this);

  List<Object?> get props => [id];

  @override
  String toString() => _encoder.convert(toJson());
}
