import 'package:json_annotation/json_annotation.dart';

import '../../../1_presentation/core/core.dart';
import '../settings/tax.dart';
import 'reorder_product.dart';
import 'reorder_supplier.dart';

part 'reorder.g.dart';

enum ReorderStatus { open, partiallyCompleted, completed }

@JsonSerializable(explicitToJson: true)
class Reorder {
  @JsonKey(includeToJson: false)
  final String id;
  final int reorderNumber;
  final String reorderNumberInternal;
  final bool closedManually;
  final ReorderStatus reorderStatus;
  final ReorderSupplier reorderSupplier;
  final List<ReorderProduct> listOfReorderProducts;
  final Tax tax;
  final String currency;
  final double totalPriceNet;
  final double totalPriceGross;
  final double totalPriceTax;
  final double productsTotalNet;
  final double productsTotalGross;
  final double productsTotalTax;
  final double shippingPriceNet;
  final double shippingPriceGross;
  final double shippingPriceTax;
  final double additionalAmountNet;
  final double additionalAmountGross;
  final double additionalAmountTax;
  final double discountTotalNet;
  final double discountTotalGross;
  final double discountTotalTax;
  final double discountAmountNet;
  final double discountAmountGross;
  final double discountAmountTax;
  final double discountPercent; //* % Rabatt
  final double discountPercentAmountGross; //* % Rabatt in € Brutto
  final double discountPercentAmountNet; //* % Rabatt in € Netto
  final double discountPercentAmountTax; //* % Rabatt in € Steuer
  final DateTime creationDate;
  final DateTime? deliveryDate;
  final DateTime lastEditingDate;

  Reorder({
    required this.id,
    required this.reorderNumber,
    required this.reorderNumberInternal,
    required this.closedManually,
    required this.reorderStatus,
    required this.reorderSupplier,
    required this.listOfReorderProducts,
    required this.tax,
    required this.currency,
    required this.shippingPriceNet,
    required this.additionalAmountNet,
    required this.discountAmountNet,
    required this.discountPercent,
    required this.creationDate,
    required this.deliveryDate,
    required this.lastEditingDate,
  })  : productsTotalNet = _calcProductsTotalNet(listOfReorderProducts),
        productsTotalGross = _calcProductsTotalGross(listOfReorderProducts),
        productsTotalTax = _calcProductsTotalTax(_calcProductsTotalGross(listOfReorderProducts), _calcProductsTotalGross(listOfReorderProducts)),
        shippingPriceGross = _calcShippingPriceGross(shippingPriceNet, tax),
        shippingPriceTax = _calcShippingPriceTax(shippingPriceNet, tax),
        additionalAmountGross = _calcAdditionalAmountGross(additionalAmountNet, tax),
        additionalAmountTax = _calcAdditionalAmountTax(additionalAmountNet, tax),
        discountAmountGross = _calcDiscountAmountGross(discountAmountNet, tax),
        discountAmountTax = _calcDiscountAmountTax(discountAmountNet, tax),
        discountPercentAmountNet = _calcDiscountPercentAmountNet(_calcProductsTotalNet(listOfReorderProducts), discountPercent),
        discountPercentAmountGross = _calcDiscountPercentAmountGross(_calcProductsTotalNet(listOfReorderProducts), discountPercent, tax),
        discountPercentAmountTax = _calcDiscountPercentAmountTax(
            _calcDiscountPercentAmountGross(_calcProductsTotalNet(listOfReorderProducts), discountPercent, tax),
            _calcDiscountPercentAmountNet(_calcProductsTotalNet(listOfReorderProducts), discountPercent)),
        discountTotalNet =
            _calcDiscountTotalNet(_calcDiscountPercentAmountNet(_calcProductsTotalNet(listOfReorderProducts), discountPercent), discountAmountNet),
        discountTotalGross = _calcDiscountTotalGross(
            _calcDiscountPercentAmountGross(_calcProductsTotalNet(listOfReorderProducts), discountPercent, tax),
            _calcDiscountAmountGross(discountAmountNet, tax)),
        discountTotalTax = _calcDiscountTotalTax(
            _calcDiscountTotalGross(_calcDiscountPercentAmountGross(_calcProductsTotalNet(listOfReorderProducts), discountPercent, tax),
                _calcDiscountAmountGross(discountAmountNet, tax)),
            _calcDiscountTotalNet(_calcDiscountPercentAmountNet(_calcProductsTotalNet(listOfReorderProducts), discountPercent), discountAmountNet)),
        totalPriceNet = _calcTotalPriceNet(_calcProductsTotalNet(listOfReorderProducts), shippingPriceNet, additionalAmountNet,
            _calcDiscountTotalNet(_calcDiscountPercentAmountNet(_calcProductsTotalNet(listOfReorderProducts), discountPercent), discountAmountNet)),
        totalPriceGross = _calcTotalPriceGross(
            _calcTotalPriceNet(
                _calcProductsTotalNet(listOfReorderProducts),
                shippingPriceNet,
                additionalAmountNet,
                _calcDiscountTotalNet(
                    _calcDiscountPercentAmountNet(_calcProductsTotalNet(listOfReorderProducts), discountPercent), discountAmountNet)),
            tax),
        totalPriceTax = _calcTotalPriceTax(
          _calcTotalPriceGross(
              _calcTotalPriceNet(
                  _calcProductsTotalNet(listOfReorderProducts),
                  shippingPriceNet,
                  additionalAmountNet,
                  _calcDiscountTotalNet(
                      _calcDiscountPercentAmountNet(_calcProductsTotalNet(listOfReorderProducts), discountPercent), discountAmountNet)),
              tax),
          _calcTotalPriceNet(_calcProductsTotalNet(listOfReorderProducts), shippingPriceNet, additionalAmountNet,
              _calcDiscountTotalNet(_calcDiscountPercentAmountNet(_calcProductsTotalNet(listOfReorderProducts), discountPercent), discountAmountNet)),
        );

  static double _calcProductsTotalNet(List<ReorderProduct> reorderProducts) {
    if (reorderProducts.isEmpty) return 0.0;
    return (reorderProducts.map((e) => (e.wholesalePriceNet * e.quantity).toMyRoundedDouble()).toList().reduce((value, element) => value + element))
        .toMyRoundedDouble();
  }

  static double _calcProductsTotalGross(List<ReorderProduct> reorderProducts) {
    if (reorderProducts.isEmpty) return 0.0;
    return (reorderProducts.map((e) => (e.wholesalePriceGross * e.quantity).toMyRoundedDouble()).toList().reduce((value, element) => value + element))
        .toMyRoundedDouble();
  }

  static double _calcProductsTotalTax(double productsTotalNet, double productsTotalGross) {
    return productsTotalGross - productsTotalNet.toMyRoundedDouble();
  }

  static double _calcShippingPriceGross(double shippingPriceNet, Tax tax) {
    return (shippingPriceNet * taxToCalc(tax.taxRate)).toMyRoundedDouble();
  }

  static double _calcShippingPriceTax(double shippingPriceNet, Tax tax) {
    return (shippingPriceNet * taxToCalc(tax.taxRate)).toMyRoundedDouble() - shippingPriceNet;
  }

  static double _calcAdditionalAmountGross(double additionalAmountNet, Tax tax) {
    return (additionalAmountNet * taxToCalc(tax.taxRate)).toMyRoundedDouble();
  }

  static double _calcAdditionalAmountTax(double additionalAmountNet, Tax tax) {
    return (additionalAmountNet * taxToCalc(tax.taxRate)).toMyRoundedDouble() - additionalAmountNet;
  }

  static double _calcDiscountAmountGross(double discountAmountNet, Tax tax) {
    return (discountAmountNet * taxToCalc(tax.taxRate)).toMyRoundedDouble();
  }

  static double _calcDiscountAmountTax(double discountAmountNet, Tax tax) {
    return (discountAmountNet * taxToCalc(tax.taxRate)).toMyRoundedDouble() - discountAmountNet;
  }

  static double _calcDiscountPercentAmountNet(double productsTotalNet, double discountPercent) {
    return calcPercentageAmount(productsTotalNet, discountPercent).toMyRoundedDouble();
  }

  static double _calcDiscountPercentAmountGross(double productsTotalNet, double discountPercent, Tax tax) {
    return (calcPercentageAmount(productsTotalNet, discountPercent).toMyRoundedDouble() * taxToCalc(tax.taxRate)).toMyRoundedDouble();
  }

  static double _calcDiscountPercentAmountTax(double discountPercentAmountGross, double discountPercentAmountNet) {
    return discountPercentAmountGross - discountPercentAmountNet;
  }

  static double _calcDiscountTotalNet(double discountPercentAmountNet, double discountAmountNet) {
    return discountPercentAmountNet + discountAmountNet;
  }

  static double _calcDiscountTotalGross(double discountPercentAmountGross, double discountAmountGross) {
    return discountPercentAmountGross + discountAmountGross;
  }

  static double _calcDiscountTotalTax(double discountTotalGross, double discountTotalNet) {
    return discountTotalGross - discountTotalNet;
  }

  static double _calcTotalPriceNet(double productsTotalNet, double shippingPriceNet, double additionalAmountNet, double discountTotalNet) {
    return productsTotalNet + shippingPriceNet + additionalAmountNet - discountTotalNet;
  }

  static double _calcTotalPriceGross(double totalPriceNet, Tax tax) {
    return (totalPriceNet * taxToCalc(tax.taxRate)).toMyRoundedDouble();
  }

  static double _calcTotalPriceTax(double totalPriceGross, double totalPriceNet) {
    return totalPriceGross - totalPriceNet;
  }

  factory Reorder.fromJson(Map<String, dynamic> json) => _$ReorderFromJson(json);
  Map<String, dynamic> toJson() => _$ReorderToJson(this);

  factory Reorder.empty() {
    return Reorder(
      id: '',
      reorderNumber: 0,
      reorderNumberInternal: '',
      closedManually: false,
      reorderStatus: ReorderStatus.open,
      reorderSupplier: ReorderSupplier.empty(),
      listOfReorderProducts: [],
      tax: Tax.empty(),
      currency: '€',
      shippingPriceNet: 0.0,
      additionalAmountNet: 0.0,
      discountAmountNet: 0.0,
      discountPercent: 0,
      creationDate: DateTime.now(),
      deliveryDate: DateTime.now(),
      lastEditingDate: DateTime.now(),
    );
  }

  Reorder copyWith({
    String? id,
    int? reorderNumber,
    String? reorderNumberInternal,
    bool? closedManually,
    ReorderStatus? reorderStatus,
    ReorderSupplier? reorderSupplier,
    List<ReorderProduct>? listOfReorderProducts,
    Tax? tax,
    String? currency,
    double? shippingPriceNet,
    double? additionalAmountNet,
    double? discountAmountNet,
    double? discountPercent,
    DateTime? creationDate,
    DateTime? deliveryDate,
    DateTime? lastEditingDate,
  }) {
    return Reorder(
      id: id ?? this.id,
      reorderNumber: reorderNumber ?? this.reorderNumber,
      reorderNumberInternal: reorderNumberInternal ?? this.reorderNumberInternal,
      closedManually: closedManually ?? this.closedManually,
      reorderStatus: reorderStatus ?? this.reorderStatus,
      reorderSupplier: reorderSupplier ?? this.reorderSupplier,
      listOfReorderProducts: listOfReorderProducts ?? this.listOfReorderProducts,
      tax: tax ?? this.tax,
      currency: currency ?? this.currency,
      shippingPriceNet: shippingPriceNet ?? this.shippingPriceNet,
      additionalAmountNet: additionalAmountNet ?? this.additionalAmountNet,
      discountAmountNet: discountAmountNet ?? this.discountAmountNet,
      discountPercent: discountPercent ?? this.discountPercent,
      creationDate: creationDate ?? this.creationDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      lastEditingDate: lastEditingDate ?? this.lastEditingDate,
    );
  }

  @override
  String toString() {
    return 'Reorder(id: $id, reorderNumber: $reorderNumber, reorderNumberInternal: $reorderNumberInternal, closedManually: $closedManually, reorderStatus: $reorderStatus, reorderSupplier: $reorderSupplier, listOfReorderProducts: $listOfReorderProducts, tax: $tax, currency: $currency, totalPriceNet: $totalPriceNet, totalPriceGross: $totalPriceGross, totalPriceTax: $totalPriceTax, productsTotalNet: $productsTotalNet, productsTotalGross: $productsTotalGross, productsTotalTax: $productsTotalTax, shippingPriceNet: $shippingPriceNet, shippingPriceGross: $shippingPriceGross, shippingPriceTax: $shippingPriceTax, additionalAmountNet: $additionalAmountNet, additionalAmountGross: $additionalAmountGross, additionalAmountTax: $additionalAmountTax, discountTotalNet: $discountTotalNet, discountTotalGross: $discountTotalGross, discountTotalTax: $discountTotalTax, discountAmountNet: $discountAmountNet, discountAmountGross: $discountAmountGross, discountAmountTax: $discountAmountTax, discountPercent: $discountPercent, discountPercentAmountGross: $discountPercentAmountGross, discountPercentAmountNet: $discountPercentAmountNet, discountPercentAmountTax: $discountPercentAmountTax, creationDate: $creationDate, deliveryDate: $deliveryDate, lastEditingDate: $lastEditingDate)';
  }
}
