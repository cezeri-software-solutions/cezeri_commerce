// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_totals.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceTotals _$InvoiceTotalsFromJson(Map<String, dynamic> json) =>
    InvoiceTotals(
      netAmount: (json['netAmount'] as num).toDouble(),
      taxAmount: (json['taxAmount'] as num).toDouble(),
      grossAmount: (json['grossAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$InvoiceTotalsToJson(InvoiceTotals instance) =>
    <String, dynamic>{
      'netAmount': instance.netAmount,
      'taxAmount': instance.taxAmount,
      'grossAmount': instance.grossAmount,
    };
