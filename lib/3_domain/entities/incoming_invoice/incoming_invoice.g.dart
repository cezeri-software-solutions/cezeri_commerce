// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incoming_invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncomingInvoice _$IncomingInvoiceFromJson(Map<String, dynamic> json) =>
    IncomingInvoice(
      id: json['id'] as String,
      supplier: IncomingInvoiceSupplier.fromJson(
          json['supplier'] as Map<String, dynamic>),
      listOfIncomingInvoiceItems: (json['listOfIncomingInvoiceItems']
              as List<dynamic>)
          .map((e) => IncomingInvoiceItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      listOfIncomingInvoiceFiles: (json['listOfIncomingInvoiceFiles']
              as List<dynamic>?)
          ?.map((e) => IncomingInvoiceFile.fromJson(e as Map<String, dynamic>))
          .toList(),
      invoiceNumber: json['invoice_number'] as String,
      status: $enumDecode(_$IncomingInvoiceStatusEnumMap, json['status']),
      currency: json['currency'] as String,
      accountNumber: json['account_number'] as String,
      accountName: json['account_name'] as String,
      earlyPaymentDiscount:
          (json['early_payment_discount'] as num?)?.toDouble(),
      discountDeadline: json['discount_deadline'] == null
          ? null
          : DateTime.parse(json['discount_deadline'] as String),
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
      'supplier': instance.supplier.toJson(),
      'listOfIncomingInvoiceItems':
          instance.listOfIncomingInvoiceItems.map((e) => e.toJson()).toList(),
      'listOfIncomingInvoiceFiles':
          instance.listOfIncomingInvoiceFiles?.map((e) => e.toJson()).toList(),
      'invoice_number': instance.invoiceNumber,
      'status': _$IncomingInvoiceStatusEnumMap[instance.status]!,
      'currency': instance.currency,
      'account_number': instance.accountNumber,
      'account_name': instance.accountName,
      'early_payment_discount': instance.earlyPaymentDiscount,
      'discount_deadline': instance.discountDeadline?.toIso8601String(),
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
