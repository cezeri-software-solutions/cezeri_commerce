import 'package:json_annotation/json_annotation.dart';

part 'field_language.g.dart';

@JsonSerializable()
class FieldLanguage {
  final int id;
  final String value;
  final String isoCode;

  const FieldLanguage({
    required this.id,
    required this.value,
    required this.isoCode,
  });

  factory FieldLanguage.empty() {
    return const FieldLanguage(
      id: 0,
      value: '',
      isoCode: '',
    );
  }

  factory FieldLanguage.fromJson(Map<String, dynamic> json) => _$FieldLanguageFromJson(json);

  Map<String, dynamic> toJson() => _$FieldLanguageToJson(this);

  FieldLanguage copyWith({
    int? id,
    String? value,
    String? isoCode,
  }) {
    return FieldLanguage(
      id: id ?? this.id,
      value: value ?? this.value,
      isoCode: isoCode ?? this.isoCode,
    );
  }

  @override
  String toString() => 'FieldLanguage(id: $id, value: $value, isoCode: $isoCode)';
}
