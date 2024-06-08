// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stat_brand.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatBrand _$StatBrandFromJson(Map<String, dynamic> json) => StatBrand(
      brandName: json['brand_name'] as String,
      netSales: (json['total_net_sales'] as num).toDouble(),
      profit: (json['total_profit'] as num).toDouble(),
      quantity: (json['total_quantity'] as num).toInt(),
      profitPercent: (json['total_profit_percent'] as num).toDouble(),
      totalSalesPercent: (json['totalSalesPercent'] as num?)?.toDouble() ?? 0.0,
      totalProfitPercent:
          (json['totalProfitPercent'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$StatBrandToJson(StatBrand instance) => <String, dynamic>{
      'brand_name': instance.brandName,
      'total_net_sales': instance.netSales,
      'total_profit': instance.profit,
      'total_quantity': instance.quantity,
      'total_profit_percent': instance.profitPercent,
      'totalSalesPercent': instance.totalSalesPercent,
      'totalProfitPercent': instance.totalProfitPercent,
    };
