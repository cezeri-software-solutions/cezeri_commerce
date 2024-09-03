import 'package:json_annotation/json_annotation.dart';

import '../id.dart';
import '../receipt/receipt.dart';
import '../receipt/receipt_product.dart';

part 'stat_product_detail.g.dart';

@JsonSerializable(explicitToJson: true)
class StatProductDetail {
  final String id;
  final String productId;
  final ReceiptType receiptTyp;
  final String receiptId;
  final String uniqueReceiptId;
  final int receiptNumber;
  final double profit;
  final double profitUnit;
  final double unitPriceNet;
  final int quantity;
  final DateTime creationDate;

  StatProductDetail({
    required this.id,
    required this.productId,
    required this.receiptTyp,
    required this.receiptId,
    required this.uniqueReceiptId,
    required this.receiptNumber,
    required this.profit,
    required this.profitUnit,
    required this.unitPriceNet,
    required this.quantity,
    required this.creationDate,
  });

  factory StatProductDetail.fromJson(Map<String, dynamic> json) => _$StatProductDetailFromJson(json);
  Map<String, dynamic> toJson() => _$StatProductDetailToJson(this);

  factory StatProductDetail.fromReceitProduct(Receipt receipt, ReceiptProduct receiptProduct) {
    return StatProductDetail(
      id: UniqueID().value,
      productId: receiptProduct.productId,
      receiptTyp: receipt.receiptTyp,
      receiptId: receipt.receiptId,
      uniqueReceiptId: receipt.id,
      receiptNumber: switch (receipt.receiptTyp) {
        ReceiptType.offer => receipt.offerId,
        ReceiptType.appointment => receipt.appointmentId,
        ReceiptType.deliveryNote => receipt.deliveryNoteId,
        ReceiptType.invoice || ReceiptType.credit => receipt.invoiceId,
      },
      profit: receiptProduct.profit,
      profitUnit: receiptProduct.profitUnit,
      unitPriceNet: receiptProduct.unitPriceNet,
      quantity: receiptProduct.quantity,
      creationDate: receipt.creationDate, //DateTime.now(),
    );
  }

  factory StatProductDetail.empty() {
    return StatProductDetail(
      id: UniqueID().value,
      productId: '',
      receiptTyp: ReceiptType.appointment,
      receiptId: '',
      uniqueReceiptId: '',
      receiptNumber: 0,
      profit: 0.0,
      profitUnit: 0.0,
      unitPriceNet: 0.0,
      quantity: 0,
      creationDate: DateTime.now(),
    );
  }

  StatProductDetail copyWith({
    String? id,
    String? productId,
    ReceiptType? receiptTyp,
    String? receiptId,
    String? uniqueReceiptId,
    int? receiptNumber,
    double? profit,
    double? profitUnit,
    double? unitPriceNet,
    int? quantity,
    DateTime? creationDate,
  }) {
    return StatProductDetail(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      receiptTyp: receiptTyp ?? this.receiptTyp,
      receiptId: receiptId ?? this.receiptId,
      uniqueReceiptId: uniqueReceiptId ?? this.uniqueReceiptId,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      profit: profit ?? this.profit,
      profitUnit: profitUnit ?? this.profitUnit,
      unitPriceNet: unitPriceNet ?? this.unitPriceNet,
      quantity: quantity ?? this.quantity,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  @override
  String toString() {
    return 'StatProductDetail(id: $id, productId: $productId, receiptTyp: $receiptTyp, receiptId: $receiptId, uniqueReceiptId: $uniqueReceiptId, receiptNumber: $receiptNumber, profit: $profit, profitUnit: $profitUnit, unitPriceNet: $unitPriceNet, quantity: $quantity, creationDate: $creationDate)';
  }
}
