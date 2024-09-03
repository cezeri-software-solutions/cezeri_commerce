import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stat_brand.g.dart';

@JsonSerializable(explicitToJson: true)
class StatBrand extends Equatable {
  @JsonKey(name: 'brand_name')
  final String brandName;
  @JsonKey(name: 'total_net_sales')
  final double netSales;
  @JsonKey(name: 'total_profit')
  final double profit;
  @JsonKey(name: 'total_quantity')
  final int quantity;
  @JsonKey(name: 'total_profit_percent')
  final double profitPercent;
  final double totalSalesPercent;
  final double totalProfitPercent;

  const StatBrand({
    required this.brandName,
    required this.netSales,
    required this.profit,
    required this.quantity,
    required this.profitPercent,
    this.totalSalesPercent = 0.0,
    this.totalProfitPercent = 0.0,
  });

  factory StatBrand.fromJson(Map<String, dynamic> json) => _$StatBrandFromJson(json);
  Map<String, dynamic> toJson() => _$StatBrandToJson(this);

  factory StatBrand.empty() => const StatBrand(
        brandName: '',
        netSales: 0.0,
        profit: 0.0,
        quantity: 0,
        profitPercent: 0.0,
        totalSalesPercent: 0.0,
        totalProfitPercent: 0.0,
      );

  StatBrand copyWith({
    String? brandName,
    double? netSales,
    double? profit,
    int? quantity,
    double? profitPercent,
    double? totalSalesPercent,
    double? totalProfitPercent,
  }) {
    return StatBrand(
      brandName: brandName ?? this.brandName,
      netSales: netSales ?? this.netSales,
      profit: profit ?? this.profit,
      quantity: quantity ?? this.quantity,
      profitPercent: profitPercent ?? this.profitPercent,
      totalSalesPercent: totalSalesPercent ?? this.totalSalesPercent,
      totalProfitPercent: totalProfitPercent ?? this.totalProfitPercent,
    );
  }

  @override
  List<Object?> get props => [brandName, netSales, profit, quantity, profitPercent, totalSalesPercent, totalProfitPercent];

  @override
  bool get stringify => true;
}
