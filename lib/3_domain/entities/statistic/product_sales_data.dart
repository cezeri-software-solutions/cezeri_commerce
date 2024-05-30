import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_sales_data.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductSalesData extends Equatable {
  @JsonKey(name: 'product_id')
  final String productId;
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  final DateTime month; // z.B. 202405
  @JsonKey(name: 'total_quantity')
  final int totalQuantity;
  @JsonKey(name: 'total_revenue')
  final double totalRevenue;

  const ProductSalesData({
    required this.productId,
    required this.month,
    required this.totalQuantity,
    required this.totalRevenue,
  });

  factory ProductSalesData.fromJson(Map<String, dynamic> json) => _$ProductSalesDataFromJson(json);
  Map<String, dynamic> toJson() => _$ProductSalesDataToJson(this);

  static DateTime _fromJson(String date) => DateTime.parse('$date-01');
  static String _toJson(DateTime date) => date.toIso8601String().substring(0, 7);

  factory ProductSalesData.empty() => ProductSalesData(productId: '', month: DateTime.now(), totalQuantity: 0, totalRevenue: 0);

  @override
  List<Object?> get props => [productId];

  @override
  bool get stringify => true;

  ProductSalesData copyWith({
    String? productId,
    DateTime? month,
    int? totalQuantity,
    double? totalRevenue,
  }) {
    return ProductSalesData(
      productId: productId ?? this.productId,
      month: month ?? this.month,
      totalQuantity: totalQuantity ?? this.totalQuantity,
      totalRevenue: totalRevenue ?? this.totalRevenue,
    );
  }
}
