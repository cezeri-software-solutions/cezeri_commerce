// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_associations_product_bundle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductAssociationsProductBundle _$ProductAssociationsProductBundleFromJson(
        Map<String, dynamic> json) =>
    ProductAssociationsProductBundle(
      id: (json['id'] as num?)?.toInt(),
      idProductAttribute: (json['idProductAttribute'] as num?)?.toInt(),
      quantity: (json['quantity'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductAssociationsProductBundleToJson(
        ProductAssociationsProductBundle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idProductAttribute': instance.idProductAttribute,
      'quantity': instance.quantity,
    };
