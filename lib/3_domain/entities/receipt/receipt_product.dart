import 'package:json_annotation/json_annotation.dart';

part 'receipt_product.g.dart';

@JsonSerializable()
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
  final int tax;
  final double wholesalePrice;
  final double discountGrossUnit;
  final double discountNetUnit;
  final double discountGross;
  final double discountNet;
  final double discountPercent;
  final double profitUnit;
  final double profit;

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
    required this.profitUnit,
    required this.profit,
  });

  factory ReceiptProduct.fromJson(Map<String, dynamic> json) => _$ReceiptProductFromJson(json);

  Map<String, dynamic> toJson() => _$ReceiptProductToJson(this);

  factory ReceiptProduct.empty() {
    return const ReceiptProduct(
      productId: '',
      productAttributeId: 0,
      quantity: 0,
      shippedQuantity: 0,
      name: '',
      articleNumber: '',
      ean: '',
      price: 0,
      unitPriceGross: 0,
      unitPriceNet: 0,
      customization: 0,
      tax: 0,
      wholesalePrice: 0,
      discountGrossUnit: 0,
      discountNetUnit: 0,
      discountGross: 0,
      discountNet: 0,
      discountPercent: 0,
      profitUnit: 0,
      profit: 0,
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
    int? tax,
    double? wholesalePrice,
    double? discountGrossUnit,
    double? discountNetUnit,
    double? discountGross,
    double? discountNet,
    double? discountPercent,
    double? profitUnit,
    double? profit,
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
      profitUnit: profitUnit ?? this.profitUnit,
      profit: profit ?? this.profit,
    );
  }

  @override
  String toString() {
    return 'ReceiptProduct(productId: $productId, productAttributeId: $productAttributeId, quantity: $quantity, shippedQuantity: $shippedQuantity, name: $name, articleNumber: $articleNumber, ean: $ean, price: $price, unitPriceGross: $unitPriceGross, unitPriceNet: $unitPriceNet, customization: $customization, tax: $tax, wholesalePrice: $wholesalePrice, discountGrossUnit: $discountGrossUnit, discountNetUnit: $discountNetUnit, discountGross: $discountGross, discountNet: $discountNet, discountPercent: $discountPercent, profitUnit: $profitUnit, profit: $profit)';
  }
}
