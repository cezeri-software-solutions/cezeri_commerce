import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'product_raw_presta.dart';

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
  final List<Multilanguage>? names;
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
  final AssociationsCategoryPresta? associations;

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
    required this.names,
    // required this.linkRewrite,
    // required this.description,
    // required this.additionalDescription,
    // required this.metaTitle,
    // required this.metaDescription,
    // required this.metaKeywords,
    required this.associations,
  });

  // factory CategoryPresta.fromJson(Map<String, dynamic> json) => _$CategoryPrestaFromJson(json);
  factory CategoryPresta.fromJson(Map<String, dynamic> json) {
    String? name;
    List<Multilanguage>? names;
    if (json['name'] is String) {
      name = json['name'] as String;
    } else if (json['name'] is List) {
      var firstItem = json['name'][0];
      if (firstItem is Map<String, dynamic> && firstItem['value'] is String) {
        name = firstItem['value'];
      }
      names = (json['name'] as List).map((e) => Multilanguage.fromJson(e as Map<String, dynamic>)).toList();
    }

    return CategoryPresta(
      id: json['id'] as int,
      idParent: json['id_parent'] as String,
      levelDepth: json['level_depth'] as String,
      active: json['active'] as String,
      name: name!,
      names: names,
      associations: json['associations'] == null ? null : AssociationsCategoryPresta.fromJson(json['associations'] as Map<String, dynamic>),
    );
  }
  Map<String, dynamic> toJson() => _$CategoryPrestaToJson(this);

  @override
  String toString() => _encoder.convert(toJson());
}

@JsonSerializable()
class AssociationsCategoryPresta {
  static const _encoder = JsonEncoder.withIndent('  ');

  @JsonKey(name: 'categories')
  final List<CategoryId>? categoryIds;

  @JsonKey(name: 'products')
  final List<ProductId>? productIds;

  AssociationsCategoryPresta({required this.categoryIds, required this.productIds});

  factory AssociationsCategoryPresta.fromJson(Map<String, dynamic> json) => _$AssociationsCategoryPrestaFromJson(json);
  Map<String, dynamic> toJson() => _$AssociationsCategoryPrestaToJson(this);

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
