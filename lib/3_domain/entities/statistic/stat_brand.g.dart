// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stat_brand.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatBrand _$StatBrandFromJson(Map<String, dynamic> json) => StatBrand(
      brandName: json['brand_name'] as String,
      totalNetSales: (json['total_net_sales'] as num).toDouble(),
      totalProfit: (json['total_profit'] as num).toDouble(),
      totalQuantity: (json['total_quantity'] as num).toInt(),
      totalProfitPercent: (json['total_profit_percent'] as num).toDouble(),
    );

Map<String, dynamic> _$StatBrandToJson(StatBrand instance) => <String, dynamic>{
      'brand_name': instance.brandName,
      'total_net_sales': instance.totalNetSales,
      'total_profit': instance.totalProfit,
      'total_quantity': instance.totalQuantity,
      'total_profit_percent': instance.totalProfitPercent,
    };
