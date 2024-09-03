import 'package:json_annotation/json_annotation.dart';

import '/1_presentation/core/core.dart';
import '../id.dart';
import '../product/product.dart';
import '../settings/tax.dart';

part 'reorder_product.g.dart';

@JsonSerializable(explicitToJson: true)
class ReorderProduct {
  final String productId; // Id des Artikels in Firebase
  final int pos; // Position in der Liste
  final String name;
  final String articleNumber;
  final String ean;
  final Tax tax;
  final double wholesalePriceNet;
  final double wholesalePriceGross;
  final double wholesalePriceTax;
  final double totalPriceNet;
  final double totalPriceGross;
  final double totalPriceTax;
  final int quantity;
  final int bookedQuantity;
  final int openQuantity;
  final bool isFromDatabase;

  ReorderProduct({
    required this.productId,
    required this.pos,
    required this.name,
    required this.articleNumber,
    required this.ean,
    required this.tax,
    required this.wholesalePriceNet,
    // required this.wholesalePriceGross,
    // required this.wholesalePriceTax,
    // required this.totalPriceNet,
    // required this.totalPriceGross,
    // required this.totalPriceTax,
    required this.quantity,
    required this.bookedQuantity,
    required this.isFromDatabase,
  })  : wholesalePriceGross = _calcWholeSalePriceGross(wholesalePriceNet, tax.taxRate),
        wholesalePriceTax = _calcWholeSalePriceGross(wholesalePriceNet, tax.taxRate) - wholesalePriceNet,
        totalPriceNet = (wholesalePriceNet * quantity).toMyRoundedDouble(),
        totalPriceGross = (_calcWholeSalePriceGross(wholesalePriceNet, tax.taxRate) * quantity).toMyRoundedDouble(),
        totalPriceTax = (_calcWholeSalePriceGross(wholesalePriceNet, tax.taxRate) * quantity).toMyRoundedDouble() -
            (wholesalePriceNet * quantity).toMyRoundedDouble(),
        openQuantity = quantity - bookedQuantity;

  static double _calcWholeSalePriceGross(double wholesalePriceNet, int taxRate) => wholesalePriceNet * taxToCalc(taxRate);

  factory ReorderProduct.fromJson(Map<String, dynamic> json) => _$ReorderProductFromJson(json);
  Map<String, dynamic> toJson() => _$ReorderProductToJson(this);

  factory ReorderProduct.fromProduct(Product product, int pos, Tax tax) {
    return ReorderProduct(
      productId: product.id.isEmpty ? '00000${UniqueID().value}' : product.id,
      pos: pos,
      name: product.name,
      articleNumber: product.articleNumber,
      ean: product.ean,
      tax: tax,
      wholesalePriceNet: product.wholesalePrice,
      quantity: 1,
      bookedQuantity: 0,
      isFromDatabase: product.id.isEmpty ? false : true,
    );
  }

  factory ReorderProduct.empty() {
    return ReorderProduct(
      productId: '',
      pos: 0,
      name: '',
      articleNumber: '',
      ean: '',
      tax: Tax.empty(),
      wholesalePriceNet: 0.0,
      quantity: 0,
      bookedQuantity: 0,
      isFromDatabase: false,
    );
  }

  ReorderProduct copyWith({
    String? productId,
    int? pos,
    String? name,
    String? articleNumber,
    String? ean,
    Tax? tax,
    double? wholesalePriceNet,
    int? quantity,
    int? bookedQuantity,
    bool? isFromDatabase,
  }) {
    return ReorderProduct(
      productId: productId ?? this.productId,
      pos: pos ?? this.pos,
      name: name ?? this.name,
      articleNumber: articleNumber ?? this.articleNumber,
      ean: ean ?? this.ean,
      tax: tax ?? this.tax,
      wholesalePriceNet: wholesalePriceNet ?? this.wholesalePriceNet,
      quantity: quantity ?? this.quantity,
      bookedQuantity: bookedQuantity ?? this.bookedQuantity,
      isFromDatabase: isFromDatabase ?? this.isFromDatabase,
    );
  }

  @override
  String toString() {
    return 'ReorderProduct(productId: $productId, pos: $pos, name: $name, articleNumber: $articleNumber, ean: $ean, tax: $tax, wholesalePriceNet: $wholesalePriceNet, wholesalePriceGross: $wholesalePriceGross, wholesalePriceTax: $wholesalePriceTax, totalPriceNet: $totalPriceNet, totalPriceGross: $totalPriceGross, totalPriceTax: $totalPriceTax, quantity: $quantity, bookedQuantity: $bookedQuantity, isFromDatabase: $isFromDatabase)';
  }
}
