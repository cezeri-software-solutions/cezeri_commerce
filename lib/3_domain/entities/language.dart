import 'package:json_annotation/json_annotation.dart';

part 'language.g.dart';

@JsonSerializable()
class Language {
  final int id;
  final String name;
  final String isoCode;
  final String locale;
  final String languageCode;
  final bool active;
  final bool isRtl;
  final String dateFormatLite;
  final String dateFormatFull;
  final bool isDefault;

  const Language({
    required this.id,
    required this.name,
    required this.isoCode,
    required this.locale,
    required this.languageCode,
    required this.active,
    required this.isRtl,
    required this.dateFormatLite,
    required this.dateFormatFull,
    required this.isDefault,
  });

  factory Language.fromJson(Map<String, dynamic> json) => _$LanguageFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageToJson(this);

  factory Language.empty() {
    return const Language(
      id: 0,
      name: '',
      isoCode: '',
      locale: '',
      languageCode: '',
      active: false,
      isRtl: false,
      dateFormatLite: '',
      dateFormatFull: '',
      isDefault: false,
    );
  }

  factory Language.emptyDe() {
    return const Language(
      id: 1,
      name: 'Deutsch (German)',
      isoCode: 'de',
      locale: 'de-DE',
      languageCode: 'de-de',
      active: false,
      isRtl: false,
      dateFormatLite: 'd.m.Y',
      dateFormatFull: 'd.m.Y H:i:s',
      isDefault: true,
    );
  }

  factory Language.emptyEn() {
    return const Language(
      id: 2,
      name: 'English (English)',
      isoCode: 'en',
      locale: 'en-US',
      languageCode: 'en-en',
      active: false,
      isRtl: false,
      dateFormatLite: 'm/d/Y',
      dateFormatFull: 'm/d/Y H:i:s',
      isDefault: false,
    );
  }

  factory Language.emptyIt() {
    return const Language(
      id: 3,
      name: 'Italiano (Italian)',
      isoCode: 'it',
      locale: 'it-IT',
      languageCode: 'it-it',
      active: false,
      isRtl: false,
      dateFormatLite: 'd/m/Y',
      dateFormatFull: 'd/m/Y H:i:s',
      isDefault: false,
    );
  }

  Language copyWith({
    int? id,
    String? name,
    String? isoCode,
    String? locale,
    String? languageCode,
    bool? active,
    bool? isRtl,
    String? dateFormatLite,
    String? dateFormatFull,
    bool? isDefault,
  }) {
    return Language(
      id: id ?? this.id,
      name: name ?? this.name,
      isoCode: isoCode ?? this.isoCode,
      locale: locale ?? this.locale,
      languageCode: languageCode ?? this.languageCode,
      active: active ?? this.active,
      isRtl: isRtl ?? this.isRtl,
      dateFormatLite: dateFormatLite ?? this.dateFormatLite,
      dateFormatFull: dateFormatFull ?? this.dateFormatFull,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  String toString() {
    return 'Language(id: $id, name: $name, isoCode: $isoCode, locale: $locale, languageCode: $languageCode, active: $active, isRtl: $isRtl, dateFormatLite: $dateFormatLite, dateFormatFull: $dateFormatFull, isDefault: $isDefault)';
  }
}
