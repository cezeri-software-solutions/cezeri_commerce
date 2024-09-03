// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_stock_difference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductStockDifference _$ProductStockDifferenceFromJson(
        Map<String, dynamic> json) =>
    ProductStockDifference(
      id: json['id'] as String,
      name: json['name'] as String,
      articleNumber: json['articlenumber'] as String,
      warehouseStock: (json['warehousestock'] as num).toInt(),
      availableStock: (json['availablestock'] as num).toInt(),
      stockDifference: (json['stock_difference'] as num).toInt(),
      salesQuantity: (json['sales_quantity'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductStockDifferenceToJson(
        ProductStockDifference instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'articlenumber': instance.articleNumber,
      'warehousestock': instance.warehouseStock,
      'availablestock': instance.availableStock,
      'stock_difference': instance.stockDifference,
      'sales_quantity': instance.salesQuantity,
    };
