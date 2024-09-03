import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'product_id_presta.g.dart';

@JsonSerializable()
class ProductsIdPresta {
  static const _encoder = JsonEncoder.withIndent('  ');

  @JsonKey(name: 'products')
  final List<ProductIdPresta> items;

  const ProductsIdPresta({required this.items});

  factory ProductsIdPresta.fromJson(Map<String, dynamic> json) => _$ProductsIdPrestaFromJson(json);
  Map<String, dynamic> toJson() => _$ProductsIdPrestaToJson(this);

  List<Object?> get props => [items];

  @override
  String toString() => _encoder.convert(toJson());
}

@JsonSerializable()
class ProductIdPresta {
  static const _encoder = JsonEncoder.withIndent('  ');

  final int id;

  const ProductIdPresta({required this.id});

  factory ProductIdPresta.fromJson(Map<String, dynamic> json) => _$ProductIdPrestaFromJson(json);
  Map<String, dynamic> toJson() => _$ProductIdPrestaToJson(this);

  List<Object?> get props => [id];

  @override
  String toString() => _encoder.convert(toJson());
}
