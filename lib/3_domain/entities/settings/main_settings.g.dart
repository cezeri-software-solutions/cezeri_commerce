// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MainSettings _$MainSettingsFromJson(Map<String, dynamic> json) => MainSettings(
      settingsId: json['settingsId'] as String,
      logoUrl: json['logoUrl'] as String,
      offerPraefix: json['offerPraefix'] as String,
      appointmentPraefix: json['appointmentPraefix'] as String,
      deliveryNotePraefix: json['deliveryNotePraefix'] as String,
      invoicePraefix: json['invoicePraefix'] as String,
      creditPraefix: json['creditPraefix'] as String,
      currency: json['currency'] as String,
      smsMessage: json['smsMessage'] as String,
      offerDocumentText: json['offerDocumentText'] as String,
      appointmentDocumentText: json['appointmentDocumentText'] as String,
      deliveryNoteDocumentText: json['deliveryNoteDocumentText'] as String,
      invoiceDocumentText: json['invoiceDocumentText'] as String,
      creditDocumentText: json['creditDocumentText'] as String,
      taxes: (json['taxes'] as List<dynamic>)
          .map((e) => Tax.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextOfferNumber: (json['nextOfferNumber'] as num).toInt(),
      nextAppointmentNumber: (json['nextAppointmentNumber'] as num).toInt(),
      nextDeliveryNoteNumber: (json['nextDeliveryNoteNumber'] as num).toInt(),
      nextInvoiceNumber: (json['nextInvoiceNumber'] as num).toInt(),
      nextBranchNumber: (json['nextBranchNumber'] as num).toInt(),
      nextCustomerNumber: (json['nextCustomerNumber'] as num).toInt(),
      nextSupplierNumber: (json['nextSupplierNumber'] as num).toInt(),
      nextReorderNumber: (json['nextReorderNumber'] as num).toInt(),
      termOfPayment: (json['termOfPayment'] as num).toInt(),
      countEmployees: (json['countEmployees'] as num).toInt(),
      countBranches: (json['countBranches'] as num).toInt(),
      limitationNumberOfEmployees:
          (json['limitationNumberOfEmployees'] as num).toInt(),
      limitationNumberOfBranches:
          (json['limitationNumberOfBranches'] as num).toInt(),
      isSmallBusiness: json['isSmallBusiness'] as bool,
      isMainSettings: json['isMainSettings'] as bool,
      printerMain: json['printerMain'] == null
          ? null
          : MyPrinter.fromJson(json['printerMain'] as Map<String, dynamic>),
      printerLabel: json['printerLabel'] == null
          ? null
          : MyPrinter.fromJson(json['printerLabel'] as Map<String, dynamic>),
      listOfCarriers: (json['listOfCarriers'] as List<dynamic>)
          .map((e) => Carrier.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymentMethods: (json['paymentMethods'] as List<dynamic>)
          .map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
          .toList(),
      listOfPackagingBoxes: (json['listOfPackagingBoxes'] as List<dynamic>)
          .map((e) => PackagingBox.fromJson(e as Map<String, dynamic>))
          .toList(),
      bankDetails:
          BankDetails.fromJson(json['bankDetails'] as Map<String, dynamic>),
      openingTimes:
          OpeningTimes.fromJson(json['openingTimes'] as Map<String, dynamic>),
      creationDate: DateTime.parse(json['creationDate'] as String),
      lastEditingDate: DateTime.parse(json['lastEditingDate'] as String),
    );

Map<String, dynamic> _$MainSettingsToJson(MainSettings instance) =>
    <String, dynamic>{
      'settingsId': instance.settingsId,
      'logoUrl': instance.logoUrl,
      'offerPraefix': instance.offerPraefix,
      'appointmentPraefix': instance.appointmentPraefix,
      'deliveryNotePraefix': instance.deliveryNotePraefix,
      'invoicePraefix': instance.invoicePraefix,
      'creditPraefix': instance.creditPraefix,
      'currency': instance.currency,
      'smsMessage': instance.smsMessage,
      'offerDocumentText': instance.offerDocumentText,
      'appointmentDocumentText': instance.appointmentDocumentText,
      'deliveryNoteDocumentText': instance.deliveryNoteDocumentText,
      'invoiceDocumentText': instance.invoiceDocumentText,
      'creditDocumentText': instance.creditDocumentText,
      'taxes': instance.taxes.map((e) => e.toJson()).toList(),
      'nextOfferNumber': instance.nextOfferNumber,
      'nextAppointmentNumber': instance.nextAppointmentNumber,
      'nextDeliveryNoteNumber': instance.nextDeliveryNoteNumber,
      'nextInvoiceNumber': instance.nextInvoiceNumber,
      'nextBranchNumber': instance.nextBranchNumber,
      'nextCustomerNumber': instance.nextCustomerNumber,
      'nextSupplierNumber': instance.nextSupplierNumber,
      'nextReorderNumber': instance.nextReorderNumber,
      'termOfPayment': instance.termOfPayment,
      'countEmployees': instance.countEmployees,
      'countBranches': instance.countBranches,
      'limitationNumberOfEmployees': instance.limitationNumberOfEmployees,
      'limitationNumberOfBranches': instance.limitationNumberOfBranches,
      'isSmallBusiness': instance.isSmallBusiness,
      'isMainSettings': instance.isMainSettings,
      'printerMain': instance.printerMain?.toJson(),
      'printerLabel': instance.printerLabel?.toJson(),
      'listOfCarriers': instance.listOfCarriers.map((e) => e.toJson()).toList(),
      'paymentMethods': instance.paymentMethods.map((e) => e.toJson()).toList(),
      'listOfPackagingBoxes':
          instance.listOfPackagingBoxes.map((e) => e.toJson()).toList(),
      'bankDetails': instance.bankDetails.toJson(),
      'openingTimes': instance.openingTimes.toJson(),
      'creationDate': instance.creationDate.toIso8601String(),
      'lastEditingDate': instance.lastEditingDate.toIso8601String(),
    };
