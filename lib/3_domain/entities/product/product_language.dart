import 'package:json_annotation/json_annotation.dart';

part 'product_language.g.dart';

@JsonSerializable()
class ProductLanguage {
  final int id;
  final String description;
  final String isoCode;

  const ProductLanguage({
    required this.id,
    required this.description,
    required this.isoCode,
  });

  factory ProductLanguage.empty() {
    return const ProductLanguage(
      id: 0,
      description: '',
      isoCode: '',
    );
  }

  factory ProductLanguage.fromJson(Map<String, dynamic> json) => _$ProductLanguageFromJson(json);

  Map<String, dynamic> toJson() => _$ProductLanguageToJson(this);

  ProductLanguage copyWith({
    int? id,
    String? description,
    String? isoCode,
  }) {
    return ProductLanguage(
      id: id ?? this.id,
      description: description ?? this.description,
      isoCode: isoCode ?? this.isoCode,
    );
  }

  @override
  String toString() => 'ProductLanguage(id: $id, description: $description, isoCode: $isoCode)';
}
