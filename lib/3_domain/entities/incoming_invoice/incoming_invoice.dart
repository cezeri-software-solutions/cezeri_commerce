// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../settings/tax.dart';
import 'incoming_invoice_account.dart';
import 'incoming_invoice_file.dart';
import 'invoice_totals.dart';

part 'incoming_invoice.g.dart';

enum IncomingInvoiceStatus { forReview, reviewed, booked }

@JsonSerializable(explicitToJson: true)
class IncomingInvoice extends Equatable {
  final String id;
  final String supplierId;
  final String invoiceNumber;
  final IncomingInvoiceStatus status;
  final String? reviewerId; // Die Person, die diese Eingangsrechnung prüfen soll (not implemented yet)
  final Tax tax;
  final String currency;
  final InvoiceTotals totalPositions;
  final InvoiceTotals totalReceipt;
  final List<IncomingInvoiceAccount> listOfIncomingInvoiceAccounts;
  final List<IncomingInvoiceFile>? listOfIncomingInvoiceFiles;
  final DateTime invoiceDate; // Rechnungsdatum
  final DateTime bookingDate; // Buchungsdatum
  final DateTime? dueDate; // Fälligkeitsdatum
  final DateTime? deliveryDate; // Lieferdatum
  final DateTime creationDate;
  final DateTime lastEditingDate;

  IncomingInvoice({
    required this.id,
    required this.supplierId,
    required this.invoiceNumber,
    required this.status,
    this.reviewerId,
    required this.tax,
    required this.currency,
    required this.totalReceipt,
    required this.listOfIncomingInvoiceAccounts,
    this.listOfIncomingInvoiceFiles,
    required this.invoiceDate,
    required this.bookingDate,
    this.dueDate,
    this.deliveryDate,
    required this.creationDate,
    required this.lastEditingDate,
  }) : totalPositions = _calcTotalPositions(listOfIncomingInvoiceAccounts);

  static InvoiceTotals _calcTotalPositions(List<IncomingInvoiceAccount> listOfIncomingInvoiceAccounts) {
    if (listOfIncomingInvoiceAccounts.isEmpty || listOfIncomingInvoiceAccounts.every((account) => account == IncomingInvoiceAccount.empty())) {
      return InvoiceTotals.empty();
    }

    final totals = listOfIncomingInvoiceAccounts.fold(
      InvoiceTotals.empty(),
      (InvoiceTotals currentTotals, IncomingInvoiceAccount account) => InvoiceTotals(
        netAmount: currentTotals.netAmount + account.netAmount,
        taxAmount: currentTotals.taxAmount + account.taxAmount,
        grossAmount: currentTotals.grossAmount + account.grossAmount,
      ),
    );

    return totals;
  }

  factory IncomingInvoice.fromJson(Map<String, dynamic> json) => _$IncomingInvoiceFromJson(json);
  Map<String, dynamic> toJson() => _$IncomingInvoiceToJson(this);

  factory IncomingInvoice.empty() {
    final now = DateTime.now();
    return IncomingInvoice(
      id: '',
      supplierId: '',
      invoiceNumber: '',
      status: IncomingInvoiceStatus.forReview,
      tax: Tax.empty(),
      currency: '',
      totalReceipt: InvoiceTotals.empty(),
      listOfIncomingInvoiceAccounts: [IncomingInvoiceAccount.empty()],
      invoiceDate: now,
      bookingDate: now,
      creationDate: now,
      lastEditingDate: now,
    );
  }

  IncomingInvoice copyWith({
    String? id,
    String? supplierId,
    String? invoiceNumber,
    IncomingInvoiceStatus? status,
    String? reviewerId,
    Tax? tax,
    String? currency,
    InvoiceTotals? totalReceipt,
    List<IncomingInvoiceAccount>? listOfIncomingInvoiceAccounts,
    List<IncomingInvoiceFile>? listOfIncomingInvoiceFiles,
    DateTime? invoiceDate,
    DateTime? bookingDate,
    DateTime? dueDate,
    DateTime? deliveryDate,
    DateTime? creationDate,
    DateTime? lastEditingDate,
  }) {
    return IncomingInvoice(
      id: id ?? this.id,
      supplierId: supplierId ?? this.supplierId,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      status: status ?? this.status,
      reviewerId: reviewerId ?? this.reviewerId,
      tax: tax ?? this.tax,
      currency: currency ?? this.currency,
      totalReceipt: totalReceipt ?? this.totalReceipt,
      listOfIncomingInvoiceAccounts: listOfIncomingInvoiceAccounts ?? this.listOfIncomingInvoiceAccounts,
      listOfIncomingInvoiceFiles: listOfIncomingInvoiceFiles ?? this.listOfIncomingInvoiceFiles,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      bookingDate: bookingDate ?? this.bookingDate,
      dueDate: dueDate ?? this.dueDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      creationDate: creationDate ?? this.creationDate,
      lastEditingDate: lastEditingDate ?? this.lastEditingDate,
    );
  }

  @override
  List<Object?> get props => [
        id,
        supplierId,
        invoiceNumber,
        status,
        reviewerId,
        tax,
        currency,
        totalPositions,
        totalReceipt,
        listOfIncomingInvoiceAccounts,
        listOfIncomingInvoiceFiles,
        invoiceDate,
        bookingDate,
        dueDate,
        deliveryDate,
        creationDate,
        lastEditingDate,
      ];

  @override
  bool get stringify => true;
}
