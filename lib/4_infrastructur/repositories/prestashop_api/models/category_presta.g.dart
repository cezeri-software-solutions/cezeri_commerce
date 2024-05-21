// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_presta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoriesPresta _$CategoriesPrestaFromJson(Map<String, dynamic> json) =>
    CategoriesPresta(
      items: (json['categories'] as List<dynamic>)
          .map((e) => CategoryPresta.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoriesPrestaToJson(CategoriesPresta instance) =>
    <String, dynamic>{
      'categories': instance.items,
    };

CategoryPresta _$CategoryPrestaFromJson(Map<String, dynamic> json) =>
    CategoryPresta(
      id: (json['id'] as num).toInt(),
      idParent: json['id_parent'] as String,
      levelDepth: json['level_depth'] as String,
      active: json['active'] as String,
      name: json['name'] as String,
      names: (json['names'] as List<dynamic>?)
          ?.map((e) => Multilanguage.fromJson(e as Map<String, dynamic>))
          .toList(),
      associations: json['associations'] == null
          ? null
          : AssociationsCategoryPresta.fromJson(
              json['associations'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CategoryPrestaToJson(CategoryPresta instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_parent': instance.idParent,
      'level_depth': instance.levelDepth,
      'active': instance.active,
      'name': instance.name,
      'names': instance.names,
      'associations': instance.associations,
    };

AssociationsCategoryPresta _$AssociationsCategoryPrestaFromJson(
        Map<String, dynamic> json) =>
    AssociationsCategoryPresta(
      categoryIds: (json['categories'] as List<dynamic>?)
          ?.map((e) => CategoryId.fromJson(e as Map<String, dynamic>))
          .toList(),
      productIds: (json['products'] as List<dynamic>?)
          ?.map((e) => ProductId.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AssociationsCategoryPrestaToJson(
        AssociationsCategoryPresta instance) =>
    <String, dynamic>{
      'categories': instance.categoryIds,
      'products': instance.productIds,
    };

CategoryId _$CategoryIdFromJson(Map<String, dynamic> json) => CategoryId(
      id: json['id'] as String,
    );

Map<String, dynamic> _$CategoryIdToJson(CategoryId instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

ProductId _$ProductIdFromJson(Map<String, dynamic> json) => ProductId(
      id: json['id'] as String,
    );

Map<String, dynamic> _$ProductIdToJson(ProductId instance) => <String, dynamic>{
      'id': instance.id,
    };
