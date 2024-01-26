// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../settings/tax.dart';
import 'incoming_invoice_file.dart';
import 'invoice_totals.dart';

part 'incoming_invoice.g.dart';

enum IncomingInvoiceStatus { forReview, reviewed, booked }

@JsonSerializable(explicitToJson: true)
class IncomingInvoice extends Equatable {
  final String id;
  final String invoiceNumber;
  final IncomingInvoiceStatus status;
  final String? reviewerId; // Die Person, die diese Eingangsrechnung prüfen soll (not implemented yet)
  final Tax tax;
  final String currency;
  final InvoiceTotals totalPositions;
  final InvoiceTotals totalReceipt;
  final List<IncomingInvoiceFile>? listOfIncomingInvoiceFiles;
  final DateTime invoiceDate; // Rechnungsdatum
  final DateTime bookingDate; // Buchungsdatum
  final DateTime? dueDate; // Fälligkeitsdatum
  final DateTime? deliveryDate; // Lieferdatum
  final DateTime creationDate;
  final DateTime lastEditingDate;
  //TODO: Konto

  const IncomingInvoice({
    required this.id,
    required this.invoiceNumber,
    required this.status,
    this.reviewerId,
    required this.tax,
    required this.currency,
    required this.totalPositions,
    required this.totalReceipt,
    this.listOfIncomingInvoiceFiles,
    required this.invoiceDate,
    required this.bookingDate,
    this.dueDate,
    this.deliveryDate,
    required this.creationDate,
    required this.lastEditingDate,
  });

  factory IncomingInvoice.fromJson(Map<String, dynamic> json) => _$IncomingInvoiceFromJson(json);
  Map<String, dynamic> toJson() => _$IncomingInvoiceToJson(this);

  factory IncomingInvoice.empty() {
    final now = DateTime.now();
    return IncomingInvoice(
      id: '',
      invoiceNumber: '',
      status: IncomingInvoiceStatus.forReview,
      tax: Tax.empty(),
      currency: '',
      totalPositions: InvoiceTotals.empty(),
      totalReceipt: InvoiceTotals.empty(),
      invoiceDate: now,
      bookingDate: now,
      creationDate: now,
      lastEditingDate: now,
    );
  }

  IncomingInvoice copyWith({
    String? id,
    String? invoiceNumber,
    IncomingInvoiceStatus? status,
    String? reviewerId,
    Tax? tax,
    String? currency,
    InvoiceTotals? totalPositions,
    InvoiceTotals? totalReceipt,
    DateTime? invoiceDate,
    DateTime? bookingDate,
    DateTime? dueDate,
    DateTime? deliveryDate,
    DateTime? creationDate,
    DateTime? lastEditingDate,
  }) {
    return IncomingInvoice(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      status: status ?? this.status,
      reviewerId: reviewerId ?? this.reviewerId,
      tax: tax ?? this.tax,
      currency: currency ?? this.currency,
      totalPositions: totalPositions ?? this.totalPositions,
      totalReceipt: totalReceipt ?? this.totalReceipt,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      bookingDate: bookingDate ?? this.bookingDate,
      dueDate: dueDate ?? this.dueDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      creationDate: creationDate ?? this.creationDate,
      lastEditingDate: lastEditingDate ?? this.lastEditingDate,
    );
  }

  @override
  List<Object?> get props => [];

  @override
  bool get stringify => true;
}
