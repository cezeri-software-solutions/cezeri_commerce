// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stat_product_count.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatProductCount _$StatProductCountFromJson(Map<String, dynamic> json) =>
    StatProductCount(
      id: json['id'] as String,
      totalWarehouseStock: (json['total_warehouse_stock'] as num).toInt(),
      totalAvailableStock: (json['total_available_stock'] as num).toInt(),
      totalWholesalePrice: (json['total_wholesale_price'] as num).toInt(),
      totalNetPrice: (json['total_net_price'] as num).toInt(),
      totalGrossPrice: (json['total_gross_price'] as num).toInt(),
      totalProfit: (json['total_profit'] as num).toInt(),
      creationDate: DateTime.parse(json['creation_date'] as String),
    );

Map<String, dynamic> _$StatProductCountToJson(StatProductCount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'total_warehouse_stock': instance.totalWarehouseStock,
      'total_available_stock': instance.totalAvailableStock,
      'total_wholesale_price': instance.totalWholesalePrice,
      'total_net_price': instance.totalNetPrice,
      'total_gross_price': instance.totalGrossPrice,
      'total_profit': instance.totalProfit,
      'creation_date': instance.creationDate.toIso8601String(),
    };
