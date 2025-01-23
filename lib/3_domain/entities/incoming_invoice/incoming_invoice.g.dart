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
      listOfIncomingInvoiceItems: (json['invoice_items'] as List<dynamic>)
          .map((e) => IncomingInvoiceItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      listOfIncomingInvoiceFiles: (json['invoice_files'] as List<dynamic>?)
          ?.map((e) => IncomingInvoiceFile.fromJson(e as Map<String, dynamic>))
          .toList(),
      incomingInvoiceNumber: (json['incoming_invoice_number'] as num).toInt(),
      incomingInvoiceNumberAsString:
          json['incoming_invoice_number_as_string'] as String,
      invoiceNumber: json['invoice_number'] as String,
      status: $enumDecode(_$IncomingInvoiceStatusEnumMap, json['status']),
      currency: json['currency'] as String,
      paymentMethod: json['payment_method'] as String,
      accountNumber: json['account_number'] as String,
      accountName: json['account_name'] as String,
      comment: json['comment'] as String?,
      discountAmount: (json['discount_amount'] as num).toDouble(),
      discountPercentage: (json['discount_percentage'] as num).toDouble(),
      earlyPaymentDiscount: (json['early_payment_discount'] as num).toDouble(),
      discountDeadline: json['discount_deadline'] == null
          ? null
          : DateTime.parse(json['discount_deadline'] as String),
      invoiceDate: DateTime.parse(json['invoice_date'] as String),
      bookingDate: json['booking_date'] == null
          ? null
          : DateTime.parse(json['booking_date'] as String),
      dueDate: json['due_date'] == null
          ? null
          : DateTime.parse(json['due_date'] as String),
      deliveryDate: json['delivery_date'] == null
          ? null
          : DateTime.parse(json['delivery_date'] as String),
      creationDate: DateTime.parse(json['creation_date'] as String),
      lastEditingDate: DateTime.parse(json['last_editing_date'] as String),
    );

Map<String, dynamic> _$IncomingInvoiceToJson(IncomingInvoice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'supplier': instance.supplier.toJson(),
      'invoice_items':
          instance.listOfIncomingInvoiceItems.map((e) => e.toJson()).toList(),
      'invoice_files':
          instance.listOfIncomingInvoiceFiles?.map((e) => e.toJson()).toList(),
      'incoming_invoice_number': instance.incomingInvoiceNumber,
      'incoming_invoice_number_as_string':
          instance.incomingInvoiceNumberAsString,
      'invoice_number': instance.invoiceNumber,
      'status': _$IncomingInvoiceStatusEnumMap[instance.status]!,
      'currency': instance.currency,
      'payment_method': instance.paymentMethod,
      'account_number': instance.accountNumber,
      'account_name': instance.accountName,
      'comment': instance.comment,
      'total_invoice': instance.totalInvoice.toJson(),
      'discount_percentage': instance.discountPercentage,
      'discount_amount': instance.discountAmount,
      'early_payment_discount': instance.earlyPaymentDiscount,
      'discount_deadline': instance.discountDeadline?.toIso8601String(),
      'invoice_date': instance.invoiceDate.toIso8601String(),
      'booking_date': instance.bookingDate?.toIso8601String(),
      'due_date': instance.dueDate?.toIso8601String(),
      'delivery_date': instance.deliveryDate?.toIso8601String(),
      'creation_date': instance.creationDate.toIso8601String(),
      'last_editing_date': instance.lastEditingDate.toIso8601String(),
    };

const _$IncomingInvoiceStatusEnumMap = {
  IncomingInvoiceStatus.forReview: 'forReview',
  IncomingInvoiceStatus.reviewed: 'reviewed',
  IncomingInvoiceStatus.booked: 'booked',
};
