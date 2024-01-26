import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'invoice_totals.g.dart';

@JsonSerializable()
class InvoiceTotals extends Equatable {
  final double netAmount;
  final double taxAmount;
  final double grossAmount;

  const InvoiceTotals({required this.netAmount, required this.taxAmount, required this.grossAmount});

  factory InvoiceTotals.fromJson(Map<String, dynamic> json) => _$InvoiceTotalsFromJson(json);
  Map<String, dynamic> toJson() => _$InvoiceTotalsToJson(this);

  factory InvoiceTotals.empty() {
    return const InvoiceTotals(netAmount: 0.0, taxAmount: 0.0, grossAmount: 0.0);
  }

  InvoiceTotals copyWith({
    double? netAmount,
    double? taxAmount,
    double? grossAmount,
  }) {
    return InvoiceTotals(
      netAmount: netAmount ?? this.netAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      grossAmount: grossAmount ?? this.grossAmount,
    );
  }

  
  @override
  List<Object?> get props => [netAmount, taxAmount, grossAmount];

  @override
  bool get stringify => true;
}
