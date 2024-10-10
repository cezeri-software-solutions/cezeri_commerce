import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../1_presentation/core/core.dart';

part 'incoming_invoice_item.g.dart';

enum DiscountType { percentage, amount }

@JsonSerializable(explicitToJson: true)
class IncomingInvoiceItem extends Equatable {
  final String id; // id des incoming_invoice
  @JsonKey(name: 'sort_id')
  final int sortId;
  @JsonKey(name: 'account_number')
  final String accountNumber; // Nummer Sachkonto
  @JsonKey(name: 'account_name')
  final String accountName; // Name Sachkonto
  final String title; // z.B. Name des Artikels oder Dienstleistungsname
  final int quantity; // bei Dienstleisungen oder Gebühren immer 1
  @JsonKey(name: 'unit_price_net')
  final double unitPriceNet; // Netto-Preis pro Einheit
  @JsonKey(name: 'unit_price_gross', includeFromJson: false)
  final double unitPriceGross; // Brutto-Preis pro Einheit
  @JsonKey(name: 'tax_rate')
  final int taxRate; // Steuersatz
  @JsonKey(name: 'tax_amount', includeFromJson: false)
  final double taxAmount; // Steuerbetrag
  @JsonKey(name: 'discount_type')
  final DiscountType discountType; // Rabatttyp
  final double discount; // Rabatt
  @JsonKey(name: 'discount_amount', includeFromJson: false)
  final double discountAmount; // Rabattbetrag (_DiscountType.amount ? discountAmount = discount : discountAmount = discount * (unitPriceGross / 100))
  @JsonKey(name: 'sub_total_net_amount', includeFromJson: false)
  final double subTotalNetAmount; // Gesamt-Netto-Preis ohne Rabattabzüge
  @JsonKey(name: 'sub_total_gross_amount', includeFromJson: false)
  final double subTotalGrossAmount; // Gesamt-Brutto-Preis ohne Rabattabzüge
  @JsonKey(name: 'total_net_amount')
  final double totalNetAmount; // Gesamt-Netto-Preis
  @JsonKey(name: 'total_gross_amount')
  final double totalGrossAmount; // Gesamt-Brutto-Preis

  IncomingInvoiceItem({
    required this.id,
    required this.sortId,
    required this.accountNumber,
    required this.accountName,
    required this.title,
    required this.quantity,
    required this.unitPriceNet,
    required this.taxRate,
    required this.discountType,
    required this.discount,
  })  : unitPriceGross = _calcUnitPriceGross(unitPriceNet, taxRate),
        subTotalNetAmount = _calcSubTotalNetAmount(unitPriceNet, quantity),
        subTotalGrossAmount = _calcSubTotalGrossAmount(_calcUnitPriceGross(unitPriceNet, taxRate), quantity),
        discountAmount = _calcDiscountAmount(discountType, discount, _calcSubTotalGrossAmount(_calcUnitPriceGross(unitPriceNet, taxRate), quantity)),
        totalGrossAmount = _calcTotalGrossAmount(_calcSubTotalGrossAmount(_calcUnitPriceGross(unitPriceNet, taxRate), quantity),
            _calcDiscountAmount(discountType, discount, _calcSubTotalGrossAmount(_calcUnitPriceGross(unitPriceNet, taxRate), quantity))),
        totalNetAmount = _calcTotalNetAmount(
            _calcTotalGrossAmount(_calcSubTotalGrossAmount(_calcUnitPriceGross(unitPriceNet, taxRate), quantity),
                _calcDiscountAmount(discountType, discount, _calcSubTotalGrossAmount(_calcUnitPriceGross(unitPriceNet, taxRate), quantity))),
            taxRate),
        taxAmount = _calcTaxAmount(
            _calcTotalGrossAmount(_calcSubTotalGrossAmount(_calcUnitPriceGross(unitPriceNet, taxRate), quantity),
                _calcDiscountAmount(discountType, discount, _calcSubTotalGrossAmount(_calcUnitPriceGross(unitPriceNet, taxRate), quantity))),
            _calcTotalNetAmount(
                _calcTotalGrossAmount(_calcSubTotalGrossAmount(_calcUnitPriceGross(unitPriceNet, taxRate), quantity),
                    _calcDiscountAmount(discountType, discount, _calcSubTotalGrossAmount(_calcUnitPriceGross(unitPriceNet, taxRate), quantity))),
                taxRate));

  static double _calcUnitPriceGross(double unitPriceNet, int taxRate) {
    if (unitPriceNet == 0 || taxRate == 0) return unitPriceNet;
    final taxMultiplier = taxToCalc(taxRate);
    return (unitPriceNet * taxMultiplier).toMyRoundedDouble();
  }

  static double _calcSubTotalNetAmount(double unitPriceNet, int quantity) {
    if (unitPriceNet == 0) return 0.0;
    return (unitPriceNet * quantity).toMyRoundedDouble();
  }

  static double _calcSubTotalGrossAmount(double unitPriceGross, int quantity) {
    if (unitPriceGross == 0) return 0.0;
    return (unitPriceGross * quantity).toMyRoundedDouble();
  }

  static double _calcDiscountAmount(DiscountType discountType, double discount, double subTotalGrossAmount) {
    if (discount == 0.0) return 0.0;
    if (discountType == DiscountType.amount) return discount;
    return (discount * (subTotalGrossAmount / 100)).toMyRoundedDouble();
  }

  static double _calcTotalGrossAmount(double subTotalGrossAmount, double discountAmount) {
    return (subTotalGrossAmount - discountAmount).toMyRoundedDouble();
  }

  static double _calcTotalNetAmount(double totalGrossAmount, int taxRate) {
    return (totalGrossAmount / taxToCalc(taxRate)).toMyRoundedDouble();
  }

  static double _calcTaxAmount(double totalGrossAmount, double totalNetAmount) {
    return (totalGrossAmount - totalNetAmount).toMyRoundedDouble();
  }

  factory IncomingInvoiceItem.fromJson(Map<String, dynamic> json) => _$IncomingInvoiceItemFromJson(json);
  Map<String, dynamic> toJson() => _$IncomingInvoiceItemToJson(this);

  factory IncomingInvoiceItem.empty() {
    return IncomingInvoiceItem(
      id: '',
      sortId: 0,
      accountNumber: '',
      accountName: '',
      title: '',
      quantity: 1,
      unitPriceNet: 0.0,
      taxRate: 0,
      discountType: DiscountType.amount,
      discount: 0,
    );
  }

  IncomingInvoiceItem copyWith({
    String? id,
    int? sortId,
    String? accountNumber,
    String? accountName,
    String? title,
    int? quantity,
    double? unitPriceNet,
    int? taxRate,
    DiscountType? discountType,
    double? discount,
  }) {
    return IncomingInvoiceItem(
      id: id ?? this.id,
      sortId: sortId ?? this.sortId,
      accountNumber: accountNumber ?? this.accountNumber,
      accountName: accountName ?? this.accountName,
      title: title ?? this.title,
      quantity: quantity ?? this.quantity,
      unitPriceNet: unitPriceNet ?? this.unitPriceNet,
      taxRate: taxRate ?? this.taxRate,
      discountType: discountType ?? this.discountType,
      discount: discount ?? this.discount,
    );
  }

  @override
  List<Object?> get props => [id, sortId, accountNumber, accountName, title, quantity, unitPriceNet, taxRate, discountType, discount];

  @override
  bool get stringify => true;
}
