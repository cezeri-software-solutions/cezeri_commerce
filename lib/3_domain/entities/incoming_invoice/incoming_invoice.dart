import 'package:cezeri_commerce/1_presentation/core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../enums/enums.dart';
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
  @JsonKey(name: 'invoice_items')
  final List<IncomingInvoiceItem> listOfIncomingInvoiceItems;
  @JsonKey(name: 'invoice_files')
  final List<IncomingInvoiceFile>? listOfIncomingInvoiceFiles;
  @JsonKey(name: 'incoming_invoice_number')
  final int incomingInvoiceNumber; // Fortlaufende Eingangsrechnungsnummer
  @JsonKey(name: 'incoming_invoice_number_as_string')
  final String incomingInvoiceNumberAsString; // Fortlaufende Eingangsrechnungsnummer mit Präfix
  @JsonKey(name: 'invoice_number')
  final String invoiceNumber; // Externe Rechnungsnummer der Eingangsrechnung
  final IncomingInvoiceStatus status;
  // final String? reviewerId; // Die Person, die diese Eingangsrechnung prüfen soll (not implemented yet)
  final String currency;
  @JsonKey(name: 'payment_method')
  final String paymentMethod;
  @JsonKey(name: 'account_number')
  final String accountNumber; // Nummer Sachkonto
  @JsonKey(name: 'account_name')
  final String accountName; // Name Sachkonto
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String accountAsString; // Nummer Sachkonto + Name Sachkonto
  final String? comment;
  @JsonKey(name: 'total_positions', includeFromJson: false)
  final InvoiceTotals totalPositions;
  @JsonKey(name: 'total_invoice', includeFromJson: false, includeToJson: true)
  final InvoiceTotals totalInvoice;
  @JsonKey(name: 'discount_percentage')
  final double discountPercentage; // Rabatt in %
  @JsonKey(name: 'discount_amount')
  final double discountAmount; // Rabattbetrag
  @JsonKey(name: 'early_payment_discount')
  final double earlyPaymentDiscount; // Skonto
  @JsonKey(name: 'discount_deadline')
  final DateTime? discountDeadline; // Skonto bis Datum
  @JsonKey(name: 'invoice_date')
  final DateTime invoiceDate; // Rechnungsdatum
  @JsonKey(name: 'booking_date')
  final DateTime? bookingDate; // Buchungsdatum
  @JsonKey(name: 'due_date')
  final DateTime? dueDate; // Fälligkeitsdatum
  @JsonKey(name: 'delivery_date')
  final DateTime? deliveryDate; // Lieferdatum
  @JsonKey(name: 'creation_date')
  final DateTime creationDate;
  @JsonKey(name: 'last_editing_date')
  final DateTime lastEditingDate;

  IncomingInvoice({
    required this.id,
    required this.supplier,
    required this.listOfIncomingInvoiceItems,
    this.listOfIncomingInvoiceFiles,
    required this.incomingInvoiceNumber,
    required this.incomingInvoiceNumberAsString,
    required this.invoiceNumber,
    required this.status,
    // this.reviewerId,
    required this.currency,
    required this.paymentMethod,
    required this.accountNumber,
    required this.accountName,
    this.comment,
    required this.discountAmount,
    required this.discountPercentage,
    required this.earlyPaymentDiscount,
    required this.discountDeadline,
    required this.invoiceDate,
    required this.bookingDate,
    this.dueDate,
    this.deliveryDate,
    required this.creationDate,
    required this.lastEditingDate,
  })  : totalPositions = _calcTotalPositions(listOfIncomingInvoiceItems),
        totalInvoice = _calcTotalInvoice(_calcTotalPositions(listOfIncomingInvoiceItems), discountPercentage, discountAmount, earlyPaymentDiscount),
        accountAsString = _createAccountName(accountNumber, accountName);

  static InvoiceTotals _calcTotalPositions(List<IncomingInvoiceItem> listOfIncomingInvoiceItems) {
    if (listOfIncomingInvoiceItems.isEmpty || listOfIncomingInvoiceItems.every((account) => account == IncomingInvoiceItem.empty())) {
      return InvoiceTotals.empty();
    }

    InvoiceTotals totalPositions = InvoiceTotals.empty();

    for (final item in listOfIncomingInvoiceItems) {
      final type = item.itemType;
      if (type == ItemType.account || type == ItemType.position || type == ItemType.shipping || type == ItemType.otherSurcharge) {
        totalPositions = totalPositions.copyWith(
          netAmount: (totalPositions.netAmount + item.totalNetAmount).toMyRoundedDouble(),
          taxAmount: (totalPositions.taxAmount + item.taxAmount).toMyRoundedDouble(),
          grossAmount: (totalPositions.grossAmount + item.totalGrossAmount).toMyRoundedDouble(),
        );
      }

      if (type == ItemType.discount) {
        if (item.discountType == DiscountType.amount) {
          final newPriceGross = totalPositions.grossAmount - item.discount;
          final discountPercentage = ((totalPositions.grossAmount - newPriceGross) / totalPositions.grossAmount) * 100;

          totalPositions = totalPositions.copyWith(
            netAmount: (totalPositions.netAmount - (totalPositions.netAmount * (discountPercentage / 100))).toMyRoundedDouble(),
            taxAmount: (totalPositions.taxAmount - (totalPositions.taxAmount * (discountPercentage / 100))).toMyRoundedDouble(),
            grossAmount: newPriceGross.toMyRoundedDouble(),
          );
        } else {
          totalPositions = totalPositions.copyWith(
            netAmount: (totalPositions.netAmount - (totalPositions.netAmount * (item.discount / 100))).toMyRoundedDouble(),
            taxAmount: (totalPositions.taxAmount - (totalPositions.taxAmount * (item.discount / 100))).toMyRoundedDouble(),
            grossAmount: (totalPositions.grossAmount - (totalPositions.grossAmount * (item.discount / 100))).toMyRoundedDouble(),
          );
        }
      }
    }

    return totalPositions;
  }

  static InvoiceTotals _calcTotalInvoice(
    InvoiceTotals totalPositions,
    double discountPercentage,
    double discountAmount,
    double earlyPaymentDiscount,
  ) {
    if (discountPercentage == 0.0 && discountAmount == 0.0 && earlyPaymentDiscount == 0.0) return totalPositions;

    InvoiceTotals totalInvoice = totalPositions;

    if (discountPercentage > 0.0) {
      totalInvoice = totalInvoice.copyWith(
        netAmount: (totalInvoice.netAmount - (totalInvoice.netAmount * (discountPercentage / 100))).toMyRoundedDouble(),
        taxAmount: (totalInvoice.taxAmount - (totalInvoice.taxAmount * (discountPercentage / 100))).toMyRoundedDouble(),
        grossAmount: (totalInvoice.grossAmount - (totalInvoice.grossAmount * (discountPercentage / 100))).toMyRoundedDouble(),
      );
    }

    if (discountAmount > 0.0) {
      final newPriceGross = totalInvoice.grossAmount - discountAmount;
      final discountPercentage = ((totalInvoice.grossAmount - newPriceGross) / totalInvoice.grossAmount) * 100;

      totalInvoice = totalInvoice.copyWith(
        netAmount: (totalInvoice.netAmount - (totalInvoice.netAmount * (discountPercentage / 100))).toMyRoundedDouble(),
        taxAmount: (totalInvoice.taxAmount - (totalInvoice.taxAmount * (discountPercentage / 100))).toMyRoundedDouble(),
        grossAmount: newPriceGross.toMyRoundedDouble(),
      );
    }

    if (earlyPaymentDiscount > 0.0) {
      totalInvoice = totalInvoice.copyWith(
        netAmount: (totalInvoice.netAmount - (totalInvoice.netAmount * (earlyPaymentDiscount / 100))).toMyRoundedDouble(),
        taxAmount: (totalInvoice.taxAmount - (totalInvoice.taxAmount * (earlyPaymentDiscount / 100))).toMyRoundedDouble(),
        grossAmount: (totalInvoice.grossAmount - (totalInvoice.grossAmount * (earlyPaymentDiscount / 100))).toMyRoundedDouble(),
      );
    }

    return totalInvoice;
  }

  static String _createAccountName(String number, String name) {
    final names = [number, name].where((element) => element.isNotEmpty);

    if (names.isEmpty) return '';
    return names.join(' ');
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
      incomingInvoiceNumber: 0,
      incomingInvoiceNumberAsString: '',
      invoiceNumber: '',
      status: IncomingInvoiceStatus.forReview,
      currency: '',
      paymentMethod: '',
      accountNumber: '',
      accountName: '',
      comment: null,
      discountPercentage: 0.0,
      discountAmount: 0.0,
      earlyPaymentDiscount: 0.0,
      discountDeadline: null,
      invoiceDate: now,
      bookingDate: null,
      dueDate: null,
      deliveryDate: null,
      creationDate: now,
      lastEditingDate: now,
    );
  }

  IncomingInvoice copyWith({
    String? id,
    IncomingInvoiceSupplier? supplier,
    List<IncomingInvoiceItem>? listOfIncomingInvoiceItems,
    List<IncomingInvoiceFile>? listOfIncomingInvoiceFiles,
    int? incomingInvoiceNumber,
    String? incomingInvoiceNumberAsString,
    String? invoiceNumber,
    IncomingInvoiceStatus? status,
    String? currency,
    String? paymentMethod,
    String? accountNumber,
    String? accountName,
    String? comment,
    double? discountPercentage,
    double? discountAmount,
    double? earlyPaymentDiscount,
    DateTime? discountDeadline,
    bool? resetDiscountDeadline,
    DateTime? invoiceDate,
    DateTime? bookingDate,
    bool? resetBookingDate,
    DateTime? dueDate,
    bool? resetDueDate,
    DateTime? deliveryDate,
    bool? resetDeliveryDate,
    DateTime? creationDate,
    DateTime? lastEditingDate,
  }) {
    return IncomingInvoice(
      id: id ?? this.id,
      supplier: supplier ?? this.supplier,
      listOfIncomingInvoiceItems: listOfIncomingInvoiceItems ?? this.listOfIncomingInvoiceItems,
      listOfIncomingInvoiceFiles: listOfIncomingInvoiceFiles ?? this.listOfIncomingInvoiceFiles,
      incomingInvoiceNumber: incomingInvoiceNumber ?? this.incomingInvoiceNumber,
      incomingInvoiceNumberAsString: incomingInvoiceNumberAsString ?? this.incomingInvoiceNumberAsString,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      status: status ?? this.status,
      currency: currency ?? this.currency,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      accountNumber: accountNumber ?? this.accountNumber,
      accountName: accountName ?? this.accountName,
      comment: comment ?? this.comment,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      discountAmount: discountAmount ?? this.discountAmount,
      earlyPaymentDiscount: earlyPaymentDiscount ?? this.earlyPaymentDiscount,
      discountDeadline: resetDiscountDeadline == true ? null : discountDeadline ?? this.discountDeadline,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      bookingDate: resetBookingDate == true ? null : bookingDate ?? this.bookingDate,
      dueDate: resetDueDate == true ? null : dueDate ?? this.dueDate,
      deliveryDate: resetDeliveryDate == true ? null : deliveryDate ?? this.deliveryDate,
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
        incomingInvoiceNumber,
        incomingInvoiceNumberAsString,
        invoiceNumber,
        status,
        currency,
        paymentMethod,
        accountNumber,
        accountName,
        accountAsString,
        comment,
        totalPositions,
        totalInvoice,
        discountPercentage,
        discountAmount,
        earlyPaymentDiscount,
        discountDeadline,
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

extension ConvertIncomingInvoiceStatusToString on IncomingInvoiceStatus {
  String convert() {
    return switch (this) {
      IncomingInvoiceStatus.forReview => 'Zur Überprüfung',
      IncomingInvoiceStatus.reviewed => 'Überprüft',
      IncomingInvoiceStatus.booked => 'Gebucht',
    };
  }
}

extension GetIncomingInvoiceStatusColor on IncomingInvoiceStatus {
  Color toColor({bool withAlpha = false}) {
    if (withAlpha) {
      return switch (this) {
        IncomingInvoiceStatus.forReview => Colors.grey[200]!,
        IncomingInvoiceStatus.reviewed => Colors.orange[200]!,
        IncomingInvoiceStatus.booked => Colors.green[200]!,
      };
    }

    return switch (this) {
      IncomingInvoiceStatus.forReview => Colors.grey,
      IncomingInvoiceStatus.reviewed => Colors.orange,
      IncomingInvoiceStatus.booked => Colors.green,
    };
  }
}
