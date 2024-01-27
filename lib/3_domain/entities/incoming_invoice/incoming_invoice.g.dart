// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incoming_invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncomingInvoice _$IncomingInvoiceFromJson(Map<String, dynamic> json) =>
    IncomingInvoice(
      id: json['id'] as String,
      supplierId: json['supplierId'] as String,
      invoiceNumber: json['invoiceNumber'] as String,
      status: $enumDecode(_$IncomingInvoiceStatusEnumMap, json['status']),
      reviewerId: json['reviewerId'] as String?,
      tax: Tax.fromJson(json['tax'] as Map<String, dynamic>),
      currency: json['currency'] as String,
      totalReceipt:
          InvoiceTotals.fromJson(json['totalReceipt'] as Map<String, dynamic>),
      listOfIncomingInvoiceAccounts: (json['listOfIncomingInvoiceAccounts']
              as List<dynamic>)
          .map(
              (e) => IncomingInvoiceAccount.fromJson(e as Map<String, dynamic>))
          .toList(),
      listOfIncomingInvoiceFiles: (json['listOfIncomingInvoiceFiles']
              as List<dynamic>?)
          ?.map((e) => IncomingInvoiceFile.fromJson(e as Map<String, dynamic>))
          .toList(),
      invoiceDate: DateTime.parse(json['invoiceDate'] as String),
      bookingDate: DateTime.parse(json['bookingDate'] as String),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      deliveryDate: json['deliveryDate'] == null
          ? null
          : DateTime.parse(json['deliveryDate'] as String),
      creationDate: DateTime.parse(json['creationDate'] as String),
      lastEditingDate: DateTime.parse(json['lastEditingDate'] as String),
    );

Map<String, dynamic> _$IncomingInvoiceToJson(IncomingInvoice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'supplierId': instance.supplierId,
      'invoiceNumber': instance.invoiceNumber,
      'status': _$IncomingInvoiceStatusEnumMap[instance.status]!,
      'reviewerId': instance.reviewerId,
      'tax': instance.tax.toJson(),
      'currency': instance.currency,
      'totalReceipt': instance.totalReceipt.toJson(),
      'listOfIncomingInvoiceAccounts': instance.listOfIncomingInvoiceAccounts
          .map((e) => e.toJson())
          .toList(),
      'listOfIncomingInvoiceFiles':
          instance.listOfIncomingInvoiceFiles?.map((e) => e.toJson()).toList(),
      'invoiceDate': instance.invoiceDate.toIso8601String(),
      'bookingDate': instance.bookingDate.toIso8601String(),
      'dueDate': instance.dueDate?.toIso8601String(),
      'deliveryDate': instance.deliveryDate?.toIso8601String(),
      'creationDate': instance.creationDate.toIso8601String(),
      'lastEditingDate': instance.lastEditingDate.toIso8601String(),
    };

const _$IncomingInvoiceStatusEnumMap = {
  IncomingInvoiceStatus.forReview: 'forReview',
  IncomingInvoiceStatus.reviewed: 'reviewed',
  IncomingInvoiceStatus.booked: 'booked',
};
