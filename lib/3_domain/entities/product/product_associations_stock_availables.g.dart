// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_associations_stock_availables.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductAssociationsStockAvailables _$ProductAssociationsStockAvailablesFromJson(
        Map<String, dynamic> json) =>
    ProductAssociationsStockAvailables(
      href: json['href'] as String?,
      id: (json['id'] as num?)?.toInt(),
      idProductAttribute: (json['idProductAttribute'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductAssociationsStockAvailablesToJson(
        ProductAssociationsStockAvailables instance) =>
    <String, dynamic>{
      'href': instance.href,
      'id': instance.id,
      'idProductAttribute': instance.idProductAttribute,
    };
