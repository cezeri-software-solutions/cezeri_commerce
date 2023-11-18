import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:json_annotation/json_annotation.dart';

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
  final bool isFromDatabase;

  ReorderProduct({
    required this.productId,
    required this.pos,
    required this.name,
    required this.articleNumber,
    required this.ean,
    required this.tax,
    required this.wholesalePriceNet,
    required this.wholesalePriceGross,
    // required this.wholesalePriceTax,
    // required this.totalPriceNet,
    // required this.totalPriceGross,
    // required this.totalPriceTax,
    required this.quantity,
    required this.bookedQuantity,
    required this.isFromDatabase,
  })  : wholesalePriceTax = wholesalePriceGross - wholesalePriceNet,
        totalPriceNet = (wholesalePriceNet * quantity).toMyRoundedDouble(),
        totalPriceGross = (wholesalePriceGross * quantity).toMyRoundedDouble(),
        totalPriceTax = (wholesalePriceGross * quantity).toMyRoundedDouble() - (wholesalePriceNet * quantity).toMyRoundedDouble();

  factory ReorderProduct.fromJson(Map<String, dynamic> json) => _$ReorderProductFromJson(json);
  Map<String, dynamic> toJson() => _$ReorderProductToJson(this);

  factory ReorderProduct.empty() {
    return ReorderProduct(
      productId: '',
      pos: 0,
      name: '',
      articleNumber: '',
      ean: '',
      tax: Tax.empty(),
      wholesalePriceNet: 0.0,
      wholesalePriceGross: 0.0,
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
    double? wholesalePriceGross,
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
      wholesalePriceGross: wholesalePriceGross ?? this.wholesalePriceGross,
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
