import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_stock_difference.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductStockDifference extends Equatable {
  final String id;
  final String name;
  @JsonKey(name: 'articlenumber')
  final String articleNumber;
   @JsonKey(name: 'warehousestock')
  final int warehouseStock;
   @JsonKey(name: 'availablestock')
  final int availableStock;
   @JsonKey(name: 'stock_difference')
  final int stockDifference;
  @JsonKey(name: 'sales_quantity')
  final int? salesQuantity;

  const ProductStockDifference({
    required this.id,
    required this.name,
    required this.articleNumber,
    required this.warehouseStock,
    required this.availableStock,
    required this.stockDifference,
    required this.salesQuantity,
  });

  factory ProductStockDifference.fromJson(Map<String, dynamic> json) => _$ProductStockDifferenceFromJson(json);
  Map<String, dynamic> toJson() => _$ProductStockDifferenceToJson(this);

  factory ProductStockDifference.empty() {
    return const ProductStockDifference(
      id: '',
      name: '',
      articleNumber: '',
      warehouseStock: 0,
      availableStock: 0,
      stockDifference: 0,
      salesQuantity: null,
    );
  }

  ProductStockDifference copyWith({
    String? id,
    String? name,
    String? articleNumber,
    int? warehouseStock,
    int? availableStock,
    int? stockDifference,
    int? salesQuantity,
  }) {
    return ProductStockDifference(
      id: id ?? this.id,
      name: name ?? this.name,
      articleNumber: articleNumber ?? this.articleNumber,
      warehouseStock: warehouseStock ?? this.warehouseStock,
      availableStock: availableStock ?? this.availableStock,
      stockDifference: stockDifference ?? this.stockDifference,
      salesQuantity: salesQuantity ?? this.salesQuantity,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  bool get stringify => true;
}
