import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stat_sales_per_day.g.dart';

@JsonSerializable(explicitToJson: true)
class StatSalesBetweenDates {
  @JsonKey(name: 'list_of_stat_sales_per_day')
  final List<StatSalesPerDay> listOfStatSalesPerDay;
  @JsonKey(includeFromJson: false)
  final double totalNetSum;
  @JsonKey(includeFromJson: false)
  final int countTotal;
  @JsonKey(includeFromJson: false)
  final double averageTotalAmount;
  @JsonKey(includeFromJson: false)
  final double averageTotalCount;
  @JsonKey(includeFromJson: false)
  final DateTimeRange? dateRange;

  StatSalesBetweenDates({required this.listOfStatSalesPerDay, this.dateRange})
      : totalNetSum = _calcTotalNetSum(listOfStatSalesPerDay),
        countTotal = _calcCountTotal(listOfStatSalesPerDay),
        averageTotalAmount = _calcAverageTotalAmount(listOfStatSalesPerDay),
        averageTotalCount = _calcAverageTotalCount(listOfStatSalesPerDay);

  static double _calcTotalNetSum(List<StatSalesPerDay> list) {
    if (list.isEmpty) return 0.0;
    return list.fold(0.0, (sum, item) => sum + item.totalNetSum);
  }

  static int _calcCountTotal(List<StatSalesPerDay> list) {
    if (list.isEmpty) return 0;
    return list.fold(0, (sum, item) => sum + item.countTotal);
  }

  static double _calcAverageTotalAmount(List<StatSalesPerDay> list) {
    if (list.isEmpty) return 0.0;
    return _calcTotalNetSum(list) / list.length;
  }

  static double _calcAverageTotalCount(List<StatSalesPerDay> list) {
    if (list.isEmpty) return 0.0;
    return _calcCountTotal(list) / list.length;
  }

  factory StatSalesBetweenDates.empty() => StatSalesBetweenDates(
        listOfStatSalesPerDay: [],
        dateRange: DateTimeRange(start: DateTime.now(), end: DateTime.now()),
      );

  factory StatSalesBetweenDates.fromJson(Map<String, dynamic> json) => _$StatSalesBetweenDatesFromJson(json);
  Map<String, dynamic> toJson() => _$StatSalesBetweenDatesToJson(this);
}

@JsonSerializable(explicitToJson: true)
class StatSalesPerDay {
  @JsonKey(name: 'list_of_stat_sales_per_day_per_marketplace')
  @JsonKey(includeFromJson: false)
  final double totalNetSum;
  @JsonKey(includeFromJson: false)
  final int countTotal;
  @JsonKey(includeFromJson: false)
  final double averageTotalAmount;
  @JsonKey(includeFromJson: false)
  final double averageTotalCount;
  final List<StatSalesPerDayPerMarketplace> listOfStatSalesPerDayPerMarketplace;
  final DateTime date;

  StatSalesPerDay({
    required this.listOfStatSalesPerDayPerMarketplace,
    required this.date,
  })  : totalNetSum = _calcTotalNetSum(listOfStatSalesPerDayPerMarketplace),
        countTotal = _calcCountTotal(listOfStatSalesPerDayPerMarketplace),
        averageTotalAmount = _calcAverageTotalAmount(listOfStatSalesPerDayPerMarketplace),
        averageTotalCount = _calcAverageTotalCount(listOfStatSalesPerDayPerMarketplace);

  static double _calcTotalNetSum(List<StatSalesPerDayPerMarketplace> list) {
    if (list.isEmpty) return 0.0;
    return list.fold(0.0, (sum, item) => sum + item.totalNetSum);
  }

  static int _calcCountTotal(List<StatSalesPerDayPerMarketplace> list) {
    if (list.isEmpty) return 0;
    return list.fold(0, (sum, item) => sum + item.count);
  }

  static double _calcAverageTotalAmount(List<StatSalesPerDayPerMarketplace> list) {
    if (list.isEmpty) return 0.0;
    return _calcTotalNetSum(list) / list.length;
  }

  static double _calcAverageTotalCount(List<StatSalesPerDayPerMarketplace> list) {
    if (list.isEmpty) return 0.0;
    return _calcCountTotal(list) / list.length;
  }

  factory StatSalesPerDay.empty() {
    return StatSalesPerDay(listOfStatSalesPerDayPerMarketplace: [], date: DateTime.now());
  }

  factory StatSalesPerDay.fromJson(Map<String, dynamic> json) => _$StatSalesPerDayFromJson(json);
  Map<String, dynamic> toJson() => _$StatSalesPerDayToJson(this);
}

@JsonSerializable(explicitToJson: true)
class StatSalesPerDayPerMarketplace {
  @JsonKey(name: 'marketplace_id')
  final String marketplaceId;
  @JsonKey(name: 'marketplace_name')
  final String marketplaceName;
  @JsonKey(name: 'total_net_sum')
  final double totalNetSum;
  final int count;
  @JsonKey(includeFromJson: false)
  final double averageAmount;
  final DateTime date;

  StatSalesPerDayPerMarketplace({
    required this.marketplaceId,
    required this.marketplaceName,
    required this.totalNetSum,
    required this.count,
    required this.date,
  }) : averageAmount = totalNetSum / count;

  factory StatSalesPerDayPerMarketplace.empty() {
    return StatSalesPerDayPerMarketplace(marketplaceId: '', marketplaceName: '', totalNetSum: 0.0, count: 0, date: DateTime.now());
  }

  factory StatSalesPerDayPerMarketplace.fromJson(Map<String, dynamic> json) => _$StatSalesPerDayPerMarketplaceFromJson(json);
  Map<String, dynamic> toJson() => _$StatSalesPerDayPerMarketplaceToJson(this);
}
