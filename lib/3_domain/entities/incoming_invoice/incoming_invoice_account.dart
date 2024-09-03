import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../settings/tax.dart';

part 'incoming_invoice_account.g.dart';

@JsonSerializable(explicitToJson: true)
class IncomingInvoiceAccount extends Equatable {
  final String id;
  final String gLAccountId;
  final double netAmount;
  final double taxAmount;
  final double grossAmount;
  final Tax tax;

  const IncomingInvoiceAccount({
    required this.id,
    required this.gLAccountId,
    required this.netAmount,
    required this.taxAmount,
    required this.grossAmount,
    required this.tax,
  });

  factory IncomingInvoiceAccount.fromJson(Map<String, dynamic> json) => _$IncomingInvoiceAccountFromJson(json);
  Map<String, dynamic> toJson() => _$IncomingInvoiceAccountToJson(this);

  factory IncomingInvoiceAccount.empty() {
    return IncomingInvoiceAccount(id: '', gLAccountId: '', netAmount: 0.0, taxAmount: 0.0, grossAmount: 0.0, tax: Tax.empty());
  }

  IncomingInvoiceAccount copyWith({
    String? id,
    String? gLAccountId,
    double? netAmount,
    double? taxAmount,
    double? grossAmount,
    Tax? tax,
  }) {
    return IncomingInvoiceAccount(
      id: id ?? this.id,
      gLAccountId: gLAccountId ?? this.gLAccountId,
      netAmount: netAmount ?? this.netAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      grossAmount: grossAmount ?? this.grossAmount,
      tax: tax ?? this.tax,
    );
  }

  @override
  List<Object?> get props => [id, gLAccountId, netAmount, taxAmount, grossAmount, tax];

  @override
  bool get stringify => true;
}
