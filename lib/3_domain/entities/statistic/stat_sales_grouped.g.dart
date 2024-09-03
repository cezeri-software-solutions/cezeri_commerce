// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stat_sales_grouped.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatSalesGrouped _$StatSalesGroupedFromJson(Map<String, dynamic> json) =>
    StatSalesGrouped(
      totalNetSum: (json['total_net_sum'] as num).toDouble(),
      count: (json['count'] as num).toInt(),
      countPercent: (json['count_percent'] as num).toDouble(),
      name: json['name'] as String,
      netGroupedSum: (json['net_grouped_sum'] as num).toDouble(),
      netGroupedSumPercent: (json['net_grouped_sum_percent'] as num).toDouble(),
    );

Map<String, dynamic> _$StatSalesGroupedToJson(StatSalesGrouped instance) =>
    <String, dynamic>{
      'total_net_sum': instance.totalNetSum,
      'count': instance.count,
      'count_percent': instance.countPercent,
      'name': instance.name,
      'net_grouped_sum': instance.netGroupedSum,
      'net_grouped_sum_percent': instance.netGroupedSumPercent,
    };

StatSalesGroupedByMarketplace _$StatSalesGroupedByMarketplaceFromJson(
        Map<String, dynamic> json) =>
    StatSalesGroupedByMarketplace(
      marketplace: json['marketplace'] as String,
      countries: (json['countries'] as List<dynamic>)
          .map((e) => StatSalesGrouped.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StatSalesGroupedByMarketplaceToJson(
        StatSalesGroupedByMarketplace instance) =>
    <String, dynamic>{
      'marketplace': instance.marketplace,
      'countries': instance.countries.map((e) => e.toJson()).toList(),
    };
