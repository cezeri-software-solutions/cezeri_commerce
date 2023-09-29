import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'language_presta.g.dart';

@JsonSerializable()
class LanguagesPresta {
  static const _encoder = JsonEncoder.withIndent('  ');

  @JsonKey(name: 'languages')
  final List<LanguagePresta> items;

  const LanguagesPresta({required this.items});

  factory LanguagesPresta.fromJson(Map<String, dynamic> json) => _$LanguagesPrestaFromJson(json);
  Map<String, dynamic> toJson() => _$LanguagesPrestaToJson(this);

  List<Object?> get props => [items];

  @override
  String toString() => _encoder.convert(toJson());
}

@JsonSerializable()
class LanguagePresta {
  static const _encoder = JsonEncoder.withIndent('  ');

  final int id;
  final String name;
  @JsonKey(name: 'iso_code')
  final String isoCode;
  final String locale;
  @JsonKey(name: 'language_code')
  final String languageCode;
  final String active;
  @JsonKey(name: 'is_rtl')
  final String isRtl;
  @JsonKey(name: 'date_format_lite')
  final String dateFormatLite;
  @JsonKey(name: 'date_format_full')
  final String dateFormatFull;

  const LanguagePresta({
    required this.id,
    required this.name,
    required this.isoCode,
    required this.locale,
    required this.languageCode,
    required this.active,
    required this.isRtl,
    required this.dateFormatLite,
    required this.dateFormatFull,
  });

  factory LanguagePresta.fromJson(Map<String, dynamic> json) => _$LanguagePrestaFromJson(json);
  Map<String, dynamic> toJson() => _$LanguagePrestaToJson(this);

  List<Object?> get props => [id];

  @override
  String toString() => _encoder.convert(toJson());
}
