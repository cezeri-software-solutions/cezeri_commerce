import 'package:json_annotation/json_annotation.dart';

import '../receipt/receipt.dart';
import '../receipt/receipt_product.dart';

part 'stat_product_detail.g.dart';

@JsonSerializable(explicitToJson: true)
class StatProductDetail {
  final ReceiptTyp receiptTyp;
  final String receiptId;
  final String uniqueReceiptId;
  final double profit;
  final double profitUnit;
  final double unitPriceNet;
  final int quantity;

  StatProductDetail({
    required this.receiptTyp,
    required this.receiptId,
    required this.uniqueReceiptId,
    required this.profit,
    required this.profitUnit,
    required this.unitPriceNet,
    required this.quantity,
  });

  factory StatProductDetail.fromJson(Map<String, dynamic> json) => _$StatProductDetailFromJson(json);
  Map<String, dynamic> toJson() => _$StatProductDetailToJson(this);

  factory StatProductDetail.fromReceitProduct(Receipt receipt, ReceiptProduct receiptProduct) {
    return StatProductDetail(
      receiptTyp: receipt.receiptTyp,
      receiptId: receipt.receiptId,
      uniqueReceiptId: receipt.id,
      profit: receiptProduct.profit,
      profitUnit: receiptProduct.profitUnit,
      unitPriceNet: receiptProduct.unitPriceNet,
      quantity: receiptProduct.quantity,
    );
  }

  factory StatProductDetail.empty() {
    return StatProductDetail(
      receiptTyp: ReceiptTyp.appointment,
      receiptId: '',
      uniqueReceiptId: '',
      profit: 0.0,
      profitUnit: 0.0,
      unitPriceNet: 0.0,
      quantity: 0,
    );
  }

  StatProductDetail copyWith({
    ReceiptTyp? receiptTyp,
    String? receiptId,
    String? uniqueReceiptId,
    double? profit,
    double? profitUnit,
    double? unitPriceNet,
    int? quantity,
  }) {
    return StatProductDetail(
      receiptTyp: receiptTyp ?? this.receiptTyp,
      receiptId: receiptId ?? this.receiptId,
      uniqueReceiptId: uniqueReceiptId ?? this.uniqueReceiptId,
      profit: profit ?? this.profit,
      profitUnit: profitUnit ?? this.profitUnit,
      unitPriceNet: unitPriceNet ?? this.unitPriceNet,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  String toString() {
    return 'StatProductDetail(receiptTyp: $receiptTyp, receiptId: $receiptId, uniqueReceiptId: $uniqueReceiptId, profit: $profit, profitUnit: $profitUnit, unitPriceNet: $unitPriceNet, quantity: $quantity)';
  }
}
