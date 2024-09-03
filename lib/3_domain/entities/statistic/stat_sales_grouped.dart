import 'package:json_annotation/json_annotation.dart';

part 'stat_sales_grouped.g.dart';

@JsonSerializable(explicitToJson: true)
class StatSalesGrouped {
  @JsonKey(name: 'total_net_sum')
  final double totalNetSum;
  final int count;
  @JsonKey(name: 'count_percent')
  final double countPercent;
  final String name;
  @JsonKey(name: 'net_grouped_sum')
  final double netGroupedSum;
  @JsonKey(name: 'net_grouped_sum_percent')
  final double netGroupedSumPercent;

  StatSalesGrouped({
    required this.totalNetSum,
    required this.count,
    required this.countPercent,
    required this.name,
    required this.netGroupedSum,
    required this.netGroupedSumPercent,
  });

  factory StatSalesGrouped.empty() {
    return StatSalesGrouped(totalNetSum: 0.0, count: 0, countPercent: 0.0, name: '', netGroupedSum: 0.0, netGroupedSumPercent: 0.0);
  }

  factory StatSalesGrouped.fromJson(Map<String, dynamic> json) => _$StatSalesGroupedFromJson(json);
  Map<String, dynamic> toJson() => _$StatSalesGroupedToJson(this);

  StatSalesGrouped copyWith({
    double? totalNetSum,
    int? count,
    double? countPercent,
    String? name,
    double? netGroupedSum,
    double? netGroupedSumPercent,
  }) {
    return StatSalesGrouped(
      totalNetSum: totalNetSum ?? this.totalNetSum,
      count: count ?? this.count,
      countPercent: countPercent ?? this.countPercent,
      name: name ?? this.name,
      netGroupedSum: netGroupedSum ?? this.netGroupedSum,
      netGroupedSumPercent: netGroupedSumPercent ?? this.netGroupedSumPercent,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class StatSalesGroupedByMarketplace {
  final String marketplace;
  final List<StatSalesGrouped> countries;

  StatSalesGroupedByMarketplace({required this.marketplace, required this.countries});

  factory StatSalesGroupedByMarketplace.empty() {
    return StatSalesGroupedByMarketplace(marketplace: '', countries: []);
  }

  factory StatSalesGroupedByMarketplace.fromJson(Map<String, dynamic> json) => _$StatSalesGroupedByMarketplaceFromJson(json);
  Map<String, dynamic> toJson() => _$StatSalesGroupedByMarketplaceToJson(this);

  StatSalesGroupedByMarketplace copyWith({
    String? marketplace,
    List<StatSalesGrouped>? countries,
  }) {
    return StatSalesGroupedByMarketplace(
      marketplace: marketplace ?? this.marketplace,
      countries: countries ?? this.countries,
    );
  }
}
