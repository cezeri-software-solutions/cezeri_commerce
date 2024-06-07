import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stat_brand.g.dart';

@JsonSerializable(explicitToJson: true)
class StatBrand extends Equatable {
  @JsonKey(name: 'brand_name')
  final String brandName;
  @JsonKey(name: 'total_net_sales')
  final double totalNetSales;
  @JsonKey(name: 'total_profit')
  final double totalProfit;
  @JsonKey(name: 'total_quantity')
  final int totalQuantity;
  @JsonKey(name: 'total_profit_percent')
  final double totalProfitPercent;

  const StatBrand({
    required this.brandName,
    required this.totalNetSales,
    required this.totalProfit,
    required this.totalQuantity,
    required this.totalProfitPercent,
  });

  factory StatBrand.fromJson(Map<String, dynamic> json) => _$StatBrandFromJson(json);
  Map<String, dynamic> toJson() => _$StatBrandToJson(this);

  factory StatBrand.empty() => const StatBrand(brandName: '', totalNetSales: 0.0, totalProfit: 0.0, totalQuantity: 0, totalProfitPercent: 0.0);

  StatBrand copyWith({
    String? brandName,
    double? totalNetSales,
    double? totalProfit,
    int? totalQuantity,
    double? totalProfitPercent,
  }) {
    return StatBrand(
      brandName: brandName ?? this.brandName,
      totalNetSales: totalNetSales ?? this.totalNetSales,
      totalProfit: totalProfit ?? this.totalProfit,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      totalProfitPercent: totalProfitPercent ?? this.totalProfitPercent,
    );
  }

  @override
  List<Object?> get props => [brandName, totalNetSales, totalProfit, totalQuantity, totalProfitPercent];

  @override
  bool get stringify => true;
}
