import 'package:json_annotation/json_annotation.dart';

import '../product/product.dart';
import '../settings/tax.dart';

part 'receipt_product.g.dart';

@JsonSerializable(explicitToJson: true)
class ReceiptProduct {
  final String productId; // Id des Artikels in Firebase
  final int productAttributeId; // Feld aus Presta
  final int quantity;
  final int shippedQuantity;
  final String name;
  final String articleNumber;
  final String ean;
  final double price;
  final double unitPriceGross;
  final double unitPriceNet;
  final int customization; // Feld aus Presta
  final Tax tax;
  final double wholesalePrice;
  final double discountGrossUnit;
  final double discountNetUnit;
  final double discountGross; // Gesamtrabatt (€Rabatt + %Rabatt) * Menge
  final double discountNet; // Gesamtrabatt (€Rabatt + %Rabatt) * Menge
  final double discountPercent;
  final double discountPercentAmountGrossUnit;
  final double discountPercentAmountNetUnit;
  final double profitUnit;
  final double profit;
  final double weight;
  final bool isFromDatabase;

  const ReceiptProduct({
    required this.productId,
    required this.productAttributeId,
    required this.quantity,
    required this.shippedQuantity,
    required this.name,
    required this.articleNumber,
    required this.ean,
    required this.price,
    required this.unitPriceGross,
    required this.unitPriceNet,
    required this.customization,
    required this.tax,
    required this.wholesalePrice,
    required this.discountGross,
    required this.discountGrossUnit,
    required this.discountNetUnit,
    required this.discountNet,
    required this.discountPercent,
    required this.discountPercentAmountGrossUnit,
    required this.discountPercentAmountNetUnit,
    required this.profitUnit,
    required this.profit,
    required this.weight,
    required this.isFromDatabase,
  });

  factory ReceiptProduct.fromJson(Map<String, dynamic> json) => _$ReceiptProductFromJson(json);

  Map<String, dynamic> toJson() => _$ReceiptProductToJson(this);

  factory ReceiptProduct.empty() {
    return ReceiptProduct(
      productId: '',
      productAttributeId: 0,
      quantity: 1,
      shippedQuantity: 0,
      name: '',
      articleNumber: '',
      ean: '',
      price: 0,
      unitPriceGross: 0,
      unitPriceNet: 0,
      customization: 0,
      tax: Tax.empty(),
      wholesalePrice: 0,
      discountGrossUnit: 0,
      discountNetUnit: 0,
      discountGross: 0,
      discountNet: 0,
      discountPercent: 0,
      discountPercentAmountGrossUnit: 0,
      discountPercentAmountNetUnit: 0,
      profitUnit: 0,
      profit: 0,
      weight: 0.0,
      isFromDatabase: false,
    );
  }

  factory ReceiptProduct.fromProduct(Product product) {
    return ReceiptProduct(
      productId: product.id,
      productAttributeId: 0,
      quantity: 1,
      shippedQuantity: 0,
      name: product.name,
      articleNumber: product.articleNumber,
      ean: product.ean,
      price: product.netPrice,
      unitPriceGross: product.grossPrice,
      unitPriceNet: product.netPrice,
      customization: 0,
      tax: product.tax,
      wholesalePrice: product.wholesalePrice,
      discountGrossUnit: 0,
      discountNetUnit: 0,
      discountGross: 0,
      discountNet: 0,
      discountPercent: 0,
      discountPercentAmountGrossUnit: 0,
      discountPercentAmountNetUnit: 0,
      profitUnit: product.netPrice - product.wholesalePrice,
      profit: product.netPrice - product.wholesalePrice,
      weight: product.weight,
      isFromDatabase: true,
    );
  }

  ReceiptProduct copyWith({
    String? productId,
    int? productAttributeId,
    int? quantity,
    int? shippedQuantity,
    String? name,
    String? articleNumber,
    String? ean,
    double? price,
    double? unitPriceGross,
    double? unitPriceNet,
    int? customization,
    Tax? tax,
    double? wholesalePrice,
    double? discountGrossUnit,
    double? discountNetUnit,
    double? discountGross,
    double? discountNet,
    double? discountPercent,
    double? discountPercentAmountGrossUnit,
    double? discountPercentAmountNetUnit,
    double? profitUnit,
    double? profit,
    double? weight,
    bool? isFromDatabase,
  }) {
    return ReceiptProduct(
      productId: productId ?? this.productId,
      productAttributeId: productAttributeId ?? this.productAttributeId,
      quantity: quantity ?? this.quantity,
      shippedQuantity: shippedQuantity ?? this.shippedQuantity,
      name: name ?? this.name,
      articleNumber: articleNumber ?? this.articleNumber,
      ean: ean ?? this.ean,
      price: price ?? this.price,
      unitPriceGross: unitPriceGross ?? this.unitPriceGross,
      unitPriceNet: unitPriceNet ?? this.unitPriceNet,
      customization: customization ?? this.customization,
      tax: tax ?? this.tax,
      wholesalePrice: wholesalePrice ?? this.wholesalePrice,
      discountGrossUnit: discountGrossUnit ?? this.discountGrossUnit,
      discountNetUnit: discountNetUnit ?? this.discountNetUnit,
      discountGross: discountGross ?? this.discountGross,
      discountNet: discountNet ?? this.discountNet,
      discountPercent: discountPercent ?? this.discountPercent,
      discountPercentAmountGrossUnit: discountPercentAmountGrossUnit ?? this.discountPercentAmountGrossUnit,
      discountPercentAmountNetUnit: discountPercentAmountNetUnit ?? this.discountPercentAmountNetUnit,
      profitUnit: profitUnit ?? this.profitUnit,
      profit: profit ?? this.profit,
      weight: weight ?? this.weight,
      isFromDatabase: isFromDatabase ?? this.isFromDatabase,
    );
  }

  @override
  String toString() {
    return 'ReceiptProduct(productId: $productId, productAttributeId: $productAttributeId, quantity: $quantity, shippedQuantity: $shippedQuantity, name: $name, articleNumber: $articleNumber, ean: $ean, price: $price, unitPriceGross: $unitPriceGross, unitPriceNet: $unitPriceNet, customization: $customization, tax: $tax, wholesalePrice: $wholesalePrice, discountGrossUnit: $discountGrossUnit, discountNetUnit: $discountNetUnit, discountGross: $discountGross, discountNet: $discountNet, discountPercent: $discountPercent, discountPercentAmountGrossUnit: $discountPercentAmountGrossUnit, discountPercentAmountNetUnit: $discountPercentAmountNetUnit, profitUnit: $profitUnit, profit: $profit, weight: $weight, isFromDatabase: $isFromDatabase)';
  }
}
