// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_sales_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductSalesData _$ProductSalesDataFromJson(Map<String, dynamic> json) =>
    ProductSalesData(
      productId: json['product_id'] as String,
      month: ProductSalesData._fromJson(json['month'] as String),
      totalQuantity: (json['total_quantity'] as num).toInt(),
      totalRevenue: (json['total_revenue'] as num).toDouble(),
    );

Map<String, dynamic> _$ProductSalesDataToJson(ProductSalesData instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'month': ProductSalesData._toJson(instance.month),
      'total_quantity': instance.totalQuantity,
      'total_revenue': instance.totalRevenue,
    };
