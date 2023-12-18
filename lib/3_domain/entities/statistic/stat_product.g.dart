// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stat_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatProduct _$StatProductFromJson(Map<String, dynamic> json) => StatProduct(
      statProductId: json['statProductId'] as String,
      name: json['name'] as String,
      articleNumber: json['articleNumber'] as String,
      ean: json['ean'] as String,
      listOfStatProductDetail:
          (json['listOfStatProductDetail'] as List<dynamic>)
              .map((e) => StatProductDetail.fromJson(e as Map<String, dynamic>))
              .toList(),
      lastEditingDate: DateTime.parse(json['lastEditingDate'] as String),
      creationDate: DateTime.parse(json['creationDate'] as String),
    );

Map<String, dynamic> _$StatProductToJson(StatProduct instance) =>
    <String, dynamic>{
      'statProductId': instance.statProductId,
      'name': instance.name,
      'articleNumber': instance.articleNumber,
      'ean': instance.ean,
      'listOfStatProductDetail':
          instance.listOfStatProductDetail.map((e) => e.toJson()).toList(),
      'lastEditingDate': instance.lastEditingDate.toIso8601String(),
      'creationDate': instance.creationDate.toIso8601String(),
    };
