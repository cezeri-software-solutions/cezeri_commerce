// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_associations_product_features.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductAssociationsProductFeatures _$ProductAssociationsProductFeaturesFromJson(
        Map<String, dynamic> json) =>
    ProductAssociationsProductFeatures(
      href: json['href'] as String?,
      id: (json['id'] as num?)?.toInt(),
      idFeatureValue: json['idFeatureValue'] as String?,
    );

Map<String, dynamic> _$ProductAssociationsProductFeaturesToJson(
        ProductAssociationsProductFeatures instance) =>
    <String, dynamic>{
      'href': instance.href,
      'id': instance.id,
      'idFeatureValue': instance.idFeatureValue,
    };
