// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stat_sales_per_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatSalesBetweenDates _$StatSalesBetweenDatesFromJson(
        Map<String, dynamic> json) =>
    StatSalesBetweenDates(
      listOfStatSalesPerDay:
          (json['list_of_stat_sales_per_day'] as List<dynamic>)
              .map((e) => StatSalesPerDay.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$StatSalesBetweenDatesToJson(
        StatSalesBetweenDates instance) =>
    <String, dynamic>{
      'list_of_stat_sales_per_day':
          instance.listOfStatSalesPerDay.map((e) => e.toJson()).toList(),
    };

StatSalesPerDay _$StatSalesPerDayFromJson(Map<String, dynamic> json) =>
    StatSalesPerDay(
      listOfStatSalesPerDayPerMarketplace:
          (json['listOfStatSalesPerDayPerMarketplace'] as List<dynamic>)
              .map((e) => StatSalesPerDayPerMarketplace.fromJson(
                  e as Map<String, dynamic>))
              .toList(),
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$StatSalesPerDayToJson(StatSalesPerDay instance) =>
    <String, dynamic>{
      'listOfStatSalesPerDayPerMarketplace': instance
          .listOfStatSalesPerDayPerMarketplace
          .map((e) => e.toJson())
          .toList(),
      'date': instance.date.toIso8601String(),
    };

StatSalesPerDayPerMarketplace _$StatSalesPerDayPerMarketplaceFromJson(
        Map<String, dynamic> json) =>
    StatSalesPerDayPerMarketplace(
      marketplaceId: json['marketplace_id'] as String,
      marketplaceName: json['marketplace_name'] as String,
      totalNetSum: (json['total_net_sum'] as num).toDouble(),
      count: (json['count'] as num).toInt(),
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$StatSalesPerDayPerMarketplaceToJson(
        StatSalesPerDayPerMarketplace instance) =>
    <String, dynamic>{
      'marketplace_id': instance.marketplaceId,
      'marketplace_name': instance.marketplaceName,
      'total_net_sum': instance.totalNetSum,
      'count': instance.count,
      'date': instance.date.toIso8601String(),
    };
