// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_totals.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceTotals _$InvoiceTotalsFromJson(Map<String, dynamic> json) =>
    InvoiceTotals(
      netAmount: (json['net_amount'] as num).toDouble(),
      taxAmount: (json['tax_amount'] as num).toDouble(),
      grossAmount: (json['gross_amount'] as num).toDouble(),
    );

Map<String, dynamic> _$InvoiceTotalsToJson(InvoiceTotals instance) =>
    <String, dynamic>{
      'net_amount': instance.netAmount,
      'tax_amount': instance.taxAmount,
      'gross_amount': instance.grossAmount,
    };
