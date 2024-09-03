import 'package:json_annotation/json_annotation.dart';

import '../carrier/carrier.dart';
import '../carrier/carrier_product.dart';

part 'receipt_carrier.g.dart';

@JsonSerializable(explicitToJson: true)
class ReceiptCarrier {
  final String receiptCarrierName;
  final CarrierTyp carrierTyp;
  final CarrierProduct carrierProduct;

  const ReceiptCarrier({
    required this.receiptCarrierName,
    required this.carrierTyp,
    required this.carrierProduct,
  });

  factory ReceiptCarrier.fromJson(Map<String, dynamic> json) => _$ReceiptCarrierFromJson(json);

  Map<String, dynamic> toJson() => _$ReceiptCarrierToJson(this);

  factory ReceiptCarrier.empty() {
    return ReceiptCarrier(receiptCarrierName: '', carrierTyp: CarrierTyp.empty, carrierProduct: CarrierProduct.empty());
  }

  factory ReceiptCarrier.fromCarrier(Carrier carrier) {
    final carrierProduct = carrier.carrierAutomations.where((e) => e.isDefault).firstOrNull;
   return ReceiptCarrier(
      receiptCarrierName: carrier.name,
      carrierTyp: carrier.carrierTyp,
      carrierProduct: carrierProduct ?? CarrierProduct.empty(),
    );
  }

  ReceiptCarrier copyWith({
    String? receiptCarrierName,
    CarrierTyp? carrierTyp,
    CarrierProduct? carrierProduct,
  }) {
    return ReceiptCarrier(
      receiptCarrierName: receiptCarrierName ?? this.receiptCarrierName,
      carrierTyp: carrierTyp ?? this.carrierTyp,
      carrierProduct: carrierProduct ?? this.carrierProduct,
    );
  }

  @override
  String toString() => 'ReceiptCarrier(receiptCarrierName: $receiptCarrierName, carrierTyp: $carrierTyp, carrierProduct: $carrierProduct)';
}
