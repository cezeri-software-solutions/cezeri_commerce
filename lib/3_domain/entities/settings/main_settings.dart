import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../carrier/carrier.dart';
import 'bank_details.dart';
import 'my_printer.dart';
import 'opening_times.dart';
import 'packaging_box.dart';
import 'payment_method.dart';
import 'tax.dart';

part 'main_settings.g.dart';

@JsonSerializable(explicitToJson: true)
class MainSettings extends Equatable {
//   final String id;
  final String settingsId;
  // @JsonKey(name: 'logo_url')
  final String logoUrl;
  // @JsonKey(name: 'offer_praefix')
  final String offerPraefix;
  // @JsonKey(name: 'appointment_praefix')
  final String appointmentPraefix;
  // @JsonKey(name: 'delivery_note_praefix')
  final String deliveryNotePraefix;
  // @JsonKey(name: 'invoice_praefix')
  final String invoicePraefix;
  // @JsonKey(name: 'credit_praefix')
  final String creditPraefix;
  // @JsonKey(name: 'incoming_invoice_praefix')
  final String incomingInvoicePraefix;
  final String currency;
  // @JsonKey(name: 'sms_message')
  final String smsMessage;
  // @JsonKey(name: 'offer_document_text')
  final String offerDocumentText;
  // @JsonKey(name: 'appointment_document_text')
  final String appointmentDocumentText;
  // @JsonKey(name: 'delivery_note_document_text')
  final String deliveryNoteDocumentText;
  // @JsonKey(name: 'invoice_document_text')
  final String invoiceDocumentText;
  // @JsonKey(name: 'credit_document_text')
  final String creditDocumentText;
  final List<Tax> taxes;
  // @JsonKey(name: 'next_offer_number')
  final int nextOfferNumber;
  // @JsonKey(name: 'next_appointment_number')
  final int nextAppointmentNumber;
  // @JsonKey(name: 'next_delivery_note_number')
  final int nextDeliveryNoteNumber;
  // @JsonKey(name: 'next_invoice_number')
  final int nextInvoiceNumber;
  // @JsonKey(name: 'next_incoming_invoice_number')
  final int nextIncomingInvoiceNumber;
  // @JsonKey(name: 'next_branch_number')
  final int nextBranchNumber;
  // @JsonKey(name: 'next_customer_number')
  final int nextCustomerNumber;
  // @JsonKey(name: 'next_supplier_number')
  final int nextSupplierNumber;
  // @JsonKey(name: 'next_reorder_number')
  final int nextReorderNumber;
  // @JsonKey(name: 'term_of_payment')
  final int termOfPayment;
  // @JsonKey(name: 'count_employees')
  final int countEmployees;
  // @JsonKey(name: 'count_branches')
  final int countBranches;
  // @JsonKey(name: 'limitation_number_of_employees')
  final int limitationNumberOfEmployees;
  // @JsonKey(name: 'limitation_number_of_branches')
  final int limitationNumberOfBranches;
  // @JsonKey(name: 'is_small_business')
  final bool isSmallBusiness;
  // @JsonKey(name: 'is_main_settings')
  final bool isMainSettings;
  // @JsonKey(name: 'printer_main')
  final MyPrinter? printerMain;
  // @JsonKey(name: 'printer_label')
  final MyPrinter? printerLabel;
  // @JsonKey(name: 'list_of_carriers')
  final List<Carrier> listOfCarriers;
  // @JsonKey(name: 'payment_methods')
  final List<PaymentMethod> paymentMethods;
  // @JsonKey(name: 'list_of_packaging_boxes')
  final List<PackagingBox> listOfPackagingBoxes;
  // @JsonKey(name: 'bank_details')
  final BankDetails bankDetails;
  // @JsonKey(name: 'opening_times')
  final OpeningTimes openingTimes;
  // @JsonKey(name: 'creation_date', includeToJson: false)
  final DateTime creationDate;
  // @JsonKey(name: 'last_editing_date', includeToJson: false)
  final DateTime lastEditingDate;

  const MainSettings({
    // required this.id,
    required this.settingsId,
    required this.logoUrl,
    required this.offerPraefix,
    required this.appointmentPraefix,
    required this.deliveryNotePraefix,
    required this.invoicePraefix,
    required this.creditPraefix,
    required this.incomingInvoicePraefix,
    required this.currency,
    required this.smsMessage,
    required this.offerDocumentText,
    required this.appointmentDocumentText,
    required this.deliveryNoteDocumentText,
    required this.invoiceDocumentText,
    required this.creditDocumentText,
    required this.taxes,
    required this.nextOfferNumber,
    required this.nextAppointmentNumber,
    required this.nextDeliveryNoteNumber,
    required this.nextInvoiceNumber,
    required this.nextIncomingInvoiceNumber,
    required this.nextBranchNumber,
    required this.nextCustomerNumber,
    required this.nextSupplierNumber,
    required this.nextReorderNumber,
    required this.termOfPayment,
    required this.countEmployees,
    required this.countBranches,
    required this.limitationNumberOfEmployees,
    required this.limitationNumberOfBranches,
    required this.isSmallBusiness,
    required this.isMainSettings,
    required this.printerMain,
    required this.printerLabel,
    required this.listOfCarriers,
    required this.paymentMethods,
    required this.listOfPackagingBoxes,
    required this.bankDetails,
    required this.openingTimes,
    required this.creationDate,
    required this.lastEditingDate,
  });

  factory MainSettings.fromJson(Map<String, dynamic> json) => _$MainSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$MainSettingsToJson(this);

  factory MainSettings.empty() {
    return MainSettings(
      settingsId: '',
      logoUrl: '',
      offerPraefix: 'AG-',
      appointmentPraefix: 'AT-',
      deliveryNotePraefix: 'LS-',
      invoicePraefix: 'RE-',
      creditPraefix: 'RK-',
      incomingInvoicePraefix: 'ER-',
      currency: '€',
      smsMessage: '',
      offerDocumentText: '',
      appointmentDocumentText: '',
      deliveryNoteDocumentText: '',
      invoiceDocumentText: '',
      creditDocumentText: '',
      taxes: const [],
      nextOfferNumber: 1,
      nextAppointmentNumber: 1,
      nextDeliveryNoteNumber: 1,
      nextInvoiceNumber: 1,
      nextIncomingInvoiceNumber: 1,
      nextBranchNumber: 1,
      nextCustomerNumber: 1,
      nextSupplierNumber: 1,
      nextReorderNumber: 1,
      termOfPayment: 14,
      countEmployees: 0,
      countBranches: 0,
      limitationNumberOfEmployees: 0,
      limitationNumberOfBranches: 0,
      isSmallBusiness: false,
      isMainSettings: true,
      printerMain: null,
      printerLabel: null,
      listOfCarriers: const [],
      paymentMethods: const [],
      listOfPackagingBoxes: const [],
      bankDetails: BankDetails.empty(),
      openingTimes: OpeningTimes.empty(),
      creationDate: DateTime.now(),
      lastEditingDate: DateTime.now(),
    );
  }

  MainSettings copyWith({
    String? settingsId,
    String? logoUrl,
    String? offerPraefix,
    String? appointmentPraefix,
    String? deliveryNotePraefix,
    String? invoicePraefix,
    String? creditPraefix,
    String? incomingInvoicePraefix,
    String? currency,
    String? smsMessage,
    String? offerDocumentText,
    String? appointmentDocumentText,
    String? deliveryNoteDocumentText,
    String? invoiceDocumentText,
    String? creditDocumentText,
    List<Tax>? taxes,
    int? nextOfferNumber,
    int? nextAppointmentNumber,
    int? nextDeliveryNoteNumber,
    int? nextInvoiceNumber,
    int? nextIncomingInvoiceNumber,
    int? nextBranchNumber,
    int? nextCustomerNumber,
    int? nextSupplierNumber,
    int? nextReorderNumber,
    int? termOfPayment,
    int? countEmployees,
    int? countBranches,
    int? limitationNumberOfEmployees,
    int? limitationNumberOfBranches,
    bool? isSmallBusiness,
    bool? isMainSettings,
    MyPrinter? printerMain,
    MyPrinter? printerLabel,
    List<Carrier>? listOfCarriers,
    List<PaymentMethod>? paymentMethods,
    List<PackagingBox>? listOfPackagingBoxes,
    BankDetails? bankDetails,
    OpeningTimes? openingTimes,
    DateTime? creationDate,
    DateTime? lastEditingDate,
  }) {
    return MainSettings(
      settingsId: settingsId ?? this.settingsId,
      logoUrl: logoUrl ?? this.logoUrl,
      offerPraefix: offerPraefix ?? this.offerPraefix,
      appointmentPraefix: appointmentPraefix ?? this.appointmentPraefix,
      deliveryNotePraefix: deliveryNotePraefix ?? this.deliveryNotePraefix,
      invoicePraefix: invoicePraefix ?? this.invoicePraefix,
      creditPraefix: creditPraefix ?? this.creditPraefix,
      incomingInvoicePraefix: incomingInvoicePraefix ?? this.incomingInvoicePraefix,
      currency: currency ?? this.currency,
      smsMessage: smsMessage ?? this.smsMessage,
      offerDocumentText: offerDocumentText ?? this.offerDocumentText,
      appointmentDocumentText: appointmentDocumentText ?? this.appointmentDocumentText,
      deliveryNoteDocumentText: deliveryNoteDocumentText ?? this.deliveryNoteDocumentText,
      invoiceDocumentText: invoiceDocumentText ?? this.invoiceDocumentText,
      creditDocumentText: creditDocumentText ?? this.creditDocumentText,
      taxes: taxes ?? this.taxes,
      nextOfferNumber: nextOfferNumber ?? this.nextOfferNumber,
      nextAppointmentNumber: nextAppointmentNumber ?? this.nextAppointmentNumber,
      nextDeliveryNoteNumber: nextDeliveryNoteNumber ?? this.nextDeliveryNoteNumber,
      nextInvoiceNumber: nextInvoiceNumber ?? this.nextInvoiceNumber,
      nextIncomingInvoiceNumber: nextIncomingInvoiceNumber ?? this.nextIncomingInvoiceNumber,
      nextBranchNumber: nextBranchNumber ?? this.nextBranchNumber,
      nextCustomerNumber: nextCustomerNumber ?? this.nextCustomerNumber,
      nextSupplierNumber: nextSupplierNumber ?? this.nextSupplierNumber,
      nextReorderNumber: nextReorderNumber ?? this.nextReorderNumber,
      termOfPayment: termOfPayment ?? this.termOfPayment,
      countEmployees: countEmployees ?? this.countEmployees,
      countBranches: countBranches ?? this.countBranches,
      limitationNumberOfEmployees: limitationNumberOfEmployees ?? this.limitationNumberOfEmployees,
      limitationNumberOfBranches: limitationNumberOfBranches ?? this.limitationNumberOfBranches,
      isSmallBusiness: isSmallBusiness ?? this.isSmallBusiness,
      isMainSettings: isMainSettings ?? this.isMainSettings,
      printerMain: printerMain ?? this.printerMain,
      printerLabel: printerLabel ?? this.printerLabel,
      listOfCarriers: listOfCarriers ?? this.listOfCarriers,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      listOfPackagingBoxes: listOfPackagingBoxes ?? this.listOfPackagingBoxes,
      bankDetails: bankDetails ?? this.bankDetails,
      openingTimes: openingTimes ?? this.openingTimes,
      creationDate: creationDate ?? this.creationDate,
      lastEditingDate: lastEditingDate ?? this.lastEditingDate,
    );
  }

  @override
  List<Object?> get props => [settingsId];

  @override
  bool get stringify => true;
}
