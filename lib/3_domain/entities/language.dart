import 'package:json_annotation/json_annotation.dart';

part 'language.g.dart';

@JsonSerializable()
class Language {
  final int id;
  final String name;
  final String nameEnglish;
  final String nameNative;
  final String isoCode;
  final bool isActive;
  final bool isDefault;

  const Language({
    required this.id,
    required this.name,
    required this.nameEnglish,
    required this.nameNative,
    required this.isoCode,
    required this.isActive,
    required this.isDefault,
  });

  factory Language.fromJson(Map<String, dynamic> json) => _$LanguageFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageToJson(this);

  factory Language.empty() {
    return const Language(
      id: 0,
      name: '',
      nameEnglish: '',
      nameNative: '',
      isoCode: '',
      isActive: false,
      isDefault: false,
    );
  }

  static List<Language> languageList = [
    Language.empty(),
    const Language(id: 1, name: 'Deutsch', nameEnglish: 'German', nameNative: 'Deutsch', isoCode: 'de', isActive: false, isDefault: false),
    const Language(id: 2, name: 'Englisch', nameEnglish: 'English', nameNative: 'English', isoCode: 'en', isActive: false, isDefault: false),
    const Language(id: 3, name: 'Italienisch', nameEnglish: 'Italian', nameNative: 'Italiano', isoCode: 'it', isActive: false, isDefault: false),
  ];

  Language copyWith({
    int? id,
    String? name,
    String? nameEnglish,
    String? nameNative,
    String? isoCode,
    bool? isActive,
    bool? isDefault,
  }) {
    return Language(
      id: id ?? this.id,
      name: name ?? this.name,
      nameEnglish: nameEnglish ?? this.nameEnglish,
      nameNative: nameNative ?? this.nameNative,
      isoCode: isoCode ?? this.isoCode,
      isActive: isActive ?? this.isActive,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  String toString() {
    return 'Language(id: $id, name: $name, nameEnglish: $nameEnglish, nameNative: $nameNative, isoCode: $isoCode, isActive: $isActive, isDefault: $isDefault)';
  }
}
