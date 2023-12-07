import 'package:json_annotation/json_annotation.dart';

import '../carrier/carrier.dart';
import 'bank_details.dart';
import 'opening_times.dart';
import 'packaging_box.dart';
import 'payment_method.dart';
import 'tax.dart';

part 'main_settings.g.dart';

@JsonSerializable(explicitToJson: true)
class MainSettings {
  final String settingsId;
  final String logoUrl;
  final String offerPraefix;
  final String appointmentPraefix;
  final String deliveryNotePraefix;
  final String invoicePraefix;
  final String creditPraefix;
  final String currency;
  final String smsMessage;
  final String offerDocumentText;
  final String appointmentDocumentText;
  final String deliveryNoteDocumentText;
  final String invoiceDocumentText;
  final String creditDocumentText;
  final List<Tax> taxes;
  final int nextOfferNumber;
  final int nextAppointmentNumber;
  final int nextDeliveryNoteNumber;
  final int nextInvoiceNumber;
  final int nextBranchNumber;
  final int nextCustomerNumber;
  final int nextSupplierNumber;
  final int nextReorderNumber;
  final int termOfPayment;
  final int countEmployees;
  final int countBranches;
  final int limitationNumberOfEmployees;
  final int limitationNumberOfBranches;
  final bool isSmallBusiness;
  final bool isMainSettings;
  final List<Carrier> listOfCarriers;
  final List<PaymentMethod> paymentMethods;
  final List<PackagingBox> listOfPackagingBoxes;
  final BankDetails bankDetails;
  final OpeningTimes openingTimes;

  MainSettings({
    required this.settingsId,
    required this.logoUrl,
    required this.offerPraefix,
    required this.appointmentPraefix,
    required this.deliveryNotePraefix,
    required this.invoicePraefix,
    required this.creditPraefix,
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
    required this.listOfCarriers,
    required this.paymentMethods,
    required this.listOfPackagingBoxes,
    required this.bankDetails,
    required this.openingTimes,
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
      currency: '€',
      smsMessage: '',
      offerDocumentText: '',
      appointmentDocumentText: '',
      deliveryNoteDocumentText: '',
      invoiceDocumentText: '',
      creditDocumentText: '',
      taxes: [],
      nextOfferNumber: 1,
      nextAppointmentNumber: 1,
      nextDeliveryNoteNumber: 1,
      nextInvoiceNumber: 1,
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
      listOfCarriers: [],
      paymentMethods: [],
      listOfPackagingBoxes: [],
      bankDetails: BankDetails.empty(),
      openingTimes: OpeningTimes.empty(),
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
    List<Carrier>? listOfCarriers,
    List<PaymentMethod>? paymentMethods,
    List<PackagingBox>? listOfPackagingBoxes,
    BankDetails? bankDetails,
    OpeningTimes? openingTimes,
  }) {
    return MainSettings(
      settingsId: settingsId ?? this.settingsId,
      logoUrl: logoUrl ?? this.logoUrl,
      offerPraefix: offerPraefix ?? this.offerPraefix,
      appointmentPraefix: appointmentPraefix ?? this.appointmentPraefix,
      deliveryNotePraefix: deliveryNotePraefix ?? this.deliveryNotePraefix,
      invoicePraefix: invoicePraefix ?? this.invoicePraefix,
      creditPraefix: creditPraefix ?? this.creditPraefix,
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
      listOfCarriers: listOfCarriers ?? this.listOfCarriers,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      listOfPackagingBoxes: listOfPackagingBoxes ?? this.listOfPackagingBoxes,
      bankDetails: bankDetails ?? this.bankDetails,
      openingTimes: openingTimes ?? this.openingTimes,
    );
  }

  @override
  String toString() {
    return 'MainSettings(settingsId: $settingsId, logoUrl: $logoUrl, offerPraefix: $offerPraefix, appointmentPraefix: $appointmentPraefix, deliveryNotePraefix: $deliveryNotePraefix, invoicePraefix: $invoicePraefix, creditPraefix: $creditPraefix, currency: $currency, smsMessage: $smsMessage, offerDocumentText: $offerDocumentText, appointmentDocumentText: $appointmentDocumentText, deliveryNoteDocumentText: $deliveryNoteDocumentText, invoiceDocumentText: $invoiceDocumentText, creditDocumentText: $creditDocumentText, taxes: $taxes, nextOfferNumber: $nextOfferNumber, nextAppointmentNumber: $nextAppointmentNumber, nextDeliveryNoteNumber: $nextDeliveryNoteNumber, nextInvoiceNumber: $nextInvoiceNumber, nextBranchNumber: $nextBranchNumber, nextCustomerNumber: $nextCustomerNumber, nextSupplierNumber: $nextSupplierNumber, nextReorderNumber: $nextReorderNumber, termOfPayment: $termOfPayment, countEmployees: $countEmployees, countBranches: $countBranches, limitationNumberOfEmployees: $limitationNumberOfEmployees, limitationNumberOfBranches: $limitationNumberOfBranches, isSmallBusiness: $isSmallBusiness, isMainSettings: $isMainSettings, listOfCarriers: $listOfCarriers, paymentMethods: $paymentMethods, listOfPackagingBoxes: $listOfPackagingBoxes, bankDetails: $bankDetails, openingTimes: $openingTimes)';
  }
}
