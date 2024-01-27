// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incoming_invoice_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncomingInvoiceAccount _$IncomingInvoiceAccountFromJson(
        Map<String, dynamic> json) =>
    IncomingInvoiceAccount(
      id: json['id'] as String,
      gLAccountId: json['gLAccountId'] as String,
      netAmount: (json['netAmount'] as num).toDouble(),
      taxAmount: (json['taxAmount'] as num).toDouble(),
      grossAmount: (json['grossAmount'] as num).toDouble(),
      tax: Tax.fromJson(json['tax'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$IncomingInvoiceAccountToJson(
        IncomingInvoiceAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'gLAccountId': instance.gLAccountId,
      'netAmount': instance.netAmount,
      'taxAmount': instance.taxAmount,
      'grossAmount': instance.grossAmount,
      'tax': instance.tax.toJson(),
    };
