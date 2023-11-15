import 'package:json_annotation/json_annotation.dart';

part 'product_language.g.dart';

@JsonSerializable()
class ProductLanguage {
  final int id;
  final String value;
  final String isoCode;

  const ProductLanguage({
    required this.id,
    required this.value,
    required this.isoCode,
  });

  factory ProductLanguage.empty() {
    return const ProductLanguage(
      id: 0,
      value: '',
      isoCode: '',
    );
  }

  factory ProductLanguage.fromJson(Map<String, dynamic> json) => _$ProductLanguageFromJson(json);

  Map<String, dynamic> toJson() => _$ProductLanguageToJson(this);

  ProductLanguage copyWith({
    int? id,
    String? value,
    String? isoCode,
  }) {
    return ProductLanguage(
      id: id ?? this.id,
      value: value ?? this.value,
      isoCode: isoCode ?? this.isoCode,
    );
  }

  @override
  String toString() => 'ProductLanguage(id: $id, value: $value, isoCode: $isoCode)';
}
