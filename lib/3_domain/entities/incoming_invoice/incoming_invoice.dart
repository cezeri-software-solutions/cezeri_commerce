import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'incoming_invoice_file.dart';
import 'incoming_invoice_item.dart';
import 'incoming_invoice_supplier.dart';
import 'invoice_totals.dart';

part 'incoming_invoice.g.dart';

enum IncomingInvoiceStatus { forReview, reviewed, booked }

@JsonSerializable(explicitToJson: true)
class IncomingInvoice extends Equatable {
  final String id;
  final IncomingInvoiceSupplier supplier;
  final List<IncomingInvoiceItem> listOfIncomingInvoiceItems;
  final List<IncomingInvoiceFile>? listOfIncomingInvoiceFiles;
  @JsonKey(name: 'invoice_number')
  final String invoiceNumber;
  final IncomingInvoiceStatus status;
  // final String? reviewerId; // Die Person, die diese Eingangsrechnung prüfen soll (not implemented yet)
  final String currency;
  @JsonKey(name: 'account_number')
  final String accountNumber;
  @JsonKey(name: 'account_name')
  final String accountName;
  @JsonKey(name: 'total_positions', includeFromJson: false)
  final InvoiceTotals totalPositions;
  @JsonKey(name: 'early_payment_discount')
  final double? earlyPaymentDiscount;
  @JsonKey(name: 'discount_deadline')
  final DateTime? discountDeadline;
  final DateTime invoiceDate; // Rechnungsdatum
  final DateTime bookingDate; // Buchungsdatum
  final DateTime? dueDate; // Fälligkeitsdatum
  final DateTime? deliveryDate; // Lieferdatum
  final DateTime creationDate;
  final DateTime lastEditingDate;

  IncomingInvoice({
    required this.id,
    required this.supplier,
    required this.listOfIncomingInvoiceItems,
    this.listOfIncomingInvoiceFiles,
    required this.invoiceNumber,
    required this.status,
    // this.reviewerId,
    required this.currency,
    required this.accountNumber,
    required this.accountName,
    required this.earlyPaymentDiscount,
    required this.discountDeadline,
    required this.invoiceDate,
    required this.bookingDate,
    this.dueDate,
    this.deliveryDate,
    required this.creationDate,
    required this.lastEditingDate,
  }) : totalPositions = _calcTotalPositions(listOfIncomingInvoiceItems);

  static InvoiceTotals _calcTotalPositions(List<IncomingInvoiceItem> listOfIncomingInvoiceItems) {
    if (listOfIncomingInvoiceItems.isEmpty || listOfIncomingInvoiceItems.every((account) => account == IncomingInvoiceItem.empty())) {
      return InvoiceTotals.empty();
    }

    final totals = listOfIncomingInvoiceItems.fold(
      InvoiceTotals.empty(),
      (InvoiceTotals currentTotals, IncomingInvoiceItem account) => InvoiceTotals(
        netAmount: currentTotals.netAmount + account.totalNetAmount,
        taxAmount: currentTotals.taxAmount + account.taxAmount,
        grossAmount: currentTotals.grossAmount + account.totalGrossAmount,
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
      supplier: IncomingInvoiceSupplier.empty(),
      listOfIncomingInvoiceItems: [IncomingInvoiceItem.empty()],
      listOfIncomingInvoiceFiles: null,
      invoiceNumber: '',
      status: IncomingInvoiceStatus.forReview,
      currency: '',
      accountNumber: '',
      accountName: '',
      earlyPaymentDiscount: null,
      discountDeadline: null,
      invoiceDate: now,
      bookingDate: now,
      creationDate: now,
      lastEditingDate: now,
    );
  }

  IncomingInvoice copyWith({
    String? id,
    IncomingInvoiceSupplier? supplier,
    List<IncomingInvoiceItem>? listOfIncomingInvoiceItems,
    List<IncomingInvoiceFile>? listOfIncomingInvoiceFiles,
    String? invoiceNumber,
    IncomingInvoiceStatus? status,
    // String? reviewerId,
    String? currency,
    String? accountNumber,
    String? accountName,
    double? earlyPaymentDiscount,
    DateTime? discountDeadline,
    DateTime? invoiceDate,
    DateTime? bookingDate,
    DateTime? dueDate,
    DateTime? deliveryDate,
    DateTime? creationDate,
    DateTime? lastEditingDate,
  }) {
    return IncomingInvoice(
      id: id ?? this.id,
      supplier: supplier ?? this.supplier,
      listOfIncomingInvoiceItems: listOfIncomingInvoiceItems ?? this.listOfIncomingInvoiceItems,
      listOfIncomingInvoiceFiles: listOfIncomingInvoiceFiles ?? this.listOfIncomingInvoiceFiles,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      status: status ?? this.status,
      // reviewerId: reviewerId ?? this.reviewerId,
      currency: currency ?? this.currency,
      accountNumber: accountNumber ?? this.accountNumber,
      accountName: accountName ?? this.accountName,
      earlyPaymentDiscount: earlyPaymentDiscount ?? this.earlyPaymentDiscount,
      discountDeadline: discountDeadline ?? this.discountDeadline,
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
        supplier,
        listOfIncomingInvoiceItems,
        listOfIncomingInvoiceFiles,
        invoiceNumber,
        status,
        // reviewerId,
        currency,
        accountNumber,
        earlyPaymentDiscount,
        discountDeadline,
        totalPositions,
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
