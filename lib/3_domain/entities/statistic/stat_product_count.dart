import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stat_product_count.g.dart';

@JsonSerializable(explicitToJson: true)
class StatProductCount extends Equatable {
  final String id;
  @JsonKey(name: 'total_warehouse_stock')
  final int totalWarehouseStock;
  @JsonKey(name: 'total_available_stock')
  final int totalAvailableStock;
  @JsonKey(name: 'total_wholesale_price')
  final int totalWholesalePrice;
  @JsonKey(name: 'total_net_price')
  final int totalNetPrice;
  @JsonKey(name: 'total_gross_price')
  final int totalGrossPrice;
  @JsonKey(name: 'total_profit')
  final int totalProfit;
  @JsonKey(name: 'creation_date')
  final DateTime creationDate;

  const StatProductCount({
    required this.id,
    required this.totalWarehouseStock,
    required this.totalAvailableStock,
    required this.totalWholesalePrice,
    required this.totalNetPrice,
    required this.totalGrossPrice,
    required this.totalProfit,
    required this.creationDate,
  });

  factory StatProductCount.fromJson(Map<String, dynamic> json) => _$StatProductCountFromJson(json);

  @override
  List<Object?> get props =>
      [id, totalWarehouseStock, totalAvailableStock, totalWholesalePrice, totalNetPrice, totalGrossPrice, totalProfit, creationDate];

  @override
  bool get stringify => true;
}
