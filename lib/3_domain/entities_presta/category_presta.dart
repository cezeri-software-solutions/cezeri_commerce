import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'category_presta.g.dart';

@JsonSerializable()
class CategoriesPresta {
  static const _encoder = JsonEncoder.withIndent('  ');

  @JsonKey(name: 'categories')
  final List<CategoryPresta> items;

  const CategoriesPresta({required this.items});

  factory CategoriesPresta.fromJson(Map<String, dynamic> json) => _$CategoriesPrestaFromJson(json);
  Map<String, dynamic> toJson() => _$CategoriesPrestaToJson(this);

  @override
  String toString() => _encoder.convert(toJson());
}

@JsonSerializable()
class CategoryPresta {
  static const _encoder = JsonEncoder.withIndent('  ');

  final int id;
  @JsonKey(name: 'id_parent')
  final String idParent;
  @JsonKey(name: 'level_depth')
  final String levelDepth;
  // @JsonKey(name: 'nb_products_recursive')
  // final String nbProductsRecursive;
  final String active;
  // @JsonKey(name: 'id_shop_default')
  // final String idShopDefault;
  // @JsonKey(name: 'is_root_category')
  // final String isRootCategory;
  // final String position;
  // @JsonKey(name: 'date_add')
  // final String dateAdd;
  // @JsonKey(name: 'date_upd')
  // final String dateUpd;
  final String name;
  // @JsonKey(name: 'link_rewrite')
  // final String linkRewrite;
  // final String description;
  // @JsonKey(name: 'additional_description')
  // final String additionalDescription;
  // @JsonKey(name: 'meta_title')
  // final String metaTitle;
  // @JsonKey(name: 'meta_description')
  // final String metaDescription;
  // @JsonKey(name: 'meta_keywords')
  // final String metaKeywords;
  final AssociationsCategory? associations;

  CategoryPresta({
    required this.id,
    required this.idParent,
    required this.levelDepth,
    // required this.nbProductsRecursive,
    required this.active,
    // required this.idShopDefault,
    // required this.isRootCategory,
    // required this.position,
    // required this.dateAdd,
    // required this.dateUpd,
    required this.name,
    // required this.linkRewrite,
    // required this.description,
    // required this.additionalDescription,
    // required this.metaTitle,
    // required this.metaDescription,
    // required this.metaKeywords,
    required this.associations,
  });

  factory CategoryPresta.fromJson(Map<String, dynamic> json) => _$CategoryPrestaFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryPrestaToJson(this);

  @override
  String toString() => _encoder.convert(toJson());
}

@JsonSerializable()
class AssociationsCategory {
  static const _encoder = JsonEncoder.withIndent('  ');

  @JsonKey(name: 'categories')
  final List<CategoryId>? categoryIds;

  @JsonKey(name: 'products')
  final List<ProductId>? productIds;

  AssociationsCategory({required this.categoryIds, required this.productIds});

  factory AssociationsCategory.fromJson(Map<String, dynamic> json) => _$AssociationsCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$AssociationsCategoryToJson(this);

  @override
  String toString() => _encoder.convert(toJson());
}

@JsonSerializable()
class CategoryId {
  final String id;

  CategoryId({required this.id});

  factory CategoryId.fromJson(Map<String, dynamic> json) => _$CategoryIdFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryIdToJson(this);
}

@JsonSerializable()
class ProductId {
  final String id;

  ProductId({required this.id});

  factory ProductId.fromJson(Map<String, dynamic> json) => _$ProductIdFromJson(json);
  Map<String, dynamic> toJson() => _$ProductIdToJson(this);
}
