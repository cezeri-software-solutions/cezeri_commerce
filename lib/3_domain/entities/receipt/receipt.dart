import 'package:cezeri_commerce/3_domain/entities/carrier/carrier_product.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../1_presentation/core/core.dart';
import '../../../4_infrastructur/repositories/prestashop_api/models/address_presta.dart';
import '../../../4_infrastructur/repositories/prestashop_api/models/carrier_presta.dart';
import '../../../4_infrastructur/repositories/prestashop_api/models/country_presta.dart';
import '../../../4_infrastructur/repositories/prestashop_api/models/currency_presta.dart';
import '../../../4_infrastructur/repositories/prestashop_api/models/customer_presta.dart';
import '../../../4_infrastructur/repositories/prestashop_api/models/order_presta.dart';
import '../../../4_infrastructur/repositories/shopify_api/shopify.dart';
import '../../enums/enums.dart';
import '../address.dart';
import '../carrier/carrier.dart';
import '../carrier/parcel_tracking.dart';
import '../customer/customer.dart';
import '../marketplace/marketplace_presta.dart';
import '../marketplace/marketplace_shopify.dart';
import '../settings/bank_details.dart';
import '../settings/main_settings.dart';
import '../settings/packaging_box.dart';
import '../settings/payment_method.dart';
import '../settings/tax.dart';
import 'payment.dart';
import 'receipt_carrier.dart';
import 'receipt_customer.dart';
import 'receipt_marketplace.dart';
import 'receipt_product.dart';

part 'receipt.g.dart';

// Ob es eine Rechnung oder eine Gutschrift ist
enum ReceiptType {
  appointment,
  offer,
  deliveryNote,
  invoice,
  credit,
}

// Status für Angebote
// Gibt an, ob ein Angebot zu einem Auftrag geführt hat, oder ob es noch offen ist.
enum OfferStatus { noOffer, open, closed }

// Status des Auftrages (Ob daraus eine Rechnung entstanden ist)
enum AppointmentStatus { open, partiallyCompleted, completed }

// Zahlungsstatus
enum PaymentStatus { open, partiallyPaid, paid }

@JsonSerializable(explicitToJson: true)
class Receipt extends Equatable {
  final String id;
  final String receiptId;
  final int offerId;
  final String offerNumberAsString;
  final int appointmentId;
  final String appointmentNumberAsString;
  final int deliveryNoteId;
  final String deliveryNoteNumberAsString;
  final List<int>? listOfDeliveryNoteIds; // Wenn aus mehereren Lieferscheinen eine Rechnung generieret wird
  final int invoiceId;
  final String invoiceNumberAsString;
  final int creditId;
  final String creditNumberAsString;
  final String marketplaceId; // Id des Marketplace aus der dieses Dokument importiert bzw. erstellt wurde.
  final int receiptMarketplaceId; // Nur wenn es wirklich von einem Marktplatz geladen wurde z.B.: 12050
  final String receiptMarketplaceReference; // Nur wenn es wirklich von einem Marktplatz geladen wurde z.B.: CCF_12050
  final PaymentMethod paymentMethod;
  final String commentInternal;
  final String commentGlobal;
  final String currency;
  final String receiptDocumentText;
  final String uidNumber;
  final String searchField;
  final String customerId;
  final ReceiptCustomer receiptCustomer; //* damit nicht zu jeder Bestellung zusätzlich der Kunde von Firebase geladen werden muss.
  final Address addressInvoice;
  final Address addressDelivery;
  final ReceiptType receiptTyp;
  final OfferStatus offerStatus;
  final AppointmentStatus appointmentStatus;
  final PaymentStatus paymentStatus;
  final Tax tax;
  final bool isSmallBusiness;
  final bool isPicked;
  final bool isDeliveryBlocked;
  final int termOfPayment;
  final double weight;
  final double totalGross;
  final double totalNet;
  final double totalTax;
  final double subTotalNet;
  final double subTotalTax;
  final double subTotalGross;
  final double totalPaidGross;
  final double totalPaidNet;
  final double totalPaidTax;
  final double totalShippingGross;
  final double totalShippingNet;
  final double totalShippingTax;
  final double totalWrappingGross;
  final double totalWrappingNet;
  final double totalWrappingTax;
  final double discountGross; //* € Rabatt Brutto
  final double discountNet; //* € Rabatt Netto
  final double discountTax; //* € Rabatt Steuer
  final double discountPercent; //* % Rabatt
  final double discountPercentAmountGross; //* % Rabatt in € Brutto
  final double discountPercentAmountNet; //* % Rabatt in € Netto
  final double discountPercentAmountTax; //* % Rabatt in € Steuer
  final double posDiscountPercentAmountGross; //* % Rabatt in € Brutto die von den einzelnen Artikeln addiert wird
  final double posDiscountPercentAmountNet; //* % Rabatt in € Netto die von den einzelnen Artikeln addiert wird
  final double posDiscountPercentAmountTax; //* % Rabatt in € Steuer die von den einzelnen Artikeln addiert wird
  final double additionalAmountNet;
  final double additionalAmountTax;
  final double additionalAmountGross;
  final double profit;
  final double profitExclShipping;
  final double profitExclWrapping;
  final double profitExclShippingAndWrapping;
  final BankDetails bankDetails;
  final List<Payment> listOfPayments;
  final List<ReceiptProduct> listOfReceiptProduct;
  final List<ParcelTracking> listOfParcelTracking;
  final ReceiptCarrier receiptCarrier;
  final ReceiptMarketplace receiptMarketplace;
  final DateTime creationDateMarektplace;
  final PackagingBox? packagingBox;
  final DateTime creationDate; // Wenn importiert: DateTime import // Wenn dirkt angelegt: Datum Erstellung
  final int? creationDateInt;
  final DateTime lastEditingDate;

  const Receipt({
    required this.id,
    required this.receiptId,
    required this.offerId,
    required this.offerNumberAsString,
    required this.appointmentId,
    required this.appointmentNumberAsString,
    required this.deliveryNoteId,
    required this.deliveryNoteNumberAsString,
    required this.listOfDeliveryNoteIds,
    required this.invoiceId,
    required this.invoiceNumberAsString,
    required this.creditId,
    required this.creditNumberAsString,
    required this.marketplaceId,
    required this.receiptMarketplaceId,
    required this.receiptMarketplaceReference,
    required this.paymentMethod,
    required this.commentInternal,
    required this.commentGlobal,
    required this.currency,
    required this.receiptDocumentText,
    required this.uidNumber,
    required this.searchField,
    required this.customerId,
    required this.receiptCustomer,
    required this.addressInvoice,
    required this.addressDelivery,
    required this.receiptTyp,
    required this.offerStatus,
    required this.appointmentStatus,
    required this.paymentStatus,
    required this.tax,
    required this.isSmallBusiness,
    required this.isPicked,
    required this.isDeliveryBlocked,
    required this.termOfPayment,
    required this.weight,
    required this.totalGross,
    required this.totalNet,
    required this.totalTax,
    required this.subTotalNet,
    required this.subTotalTax,
    required this.subTotalGross,
    required this.totalPaidGross,
    required this.totalPaidNet,
    required this.totalPaidTax,
    required this.totalShippingGross,
    required this.totalShippingNet,
    required this.totalShippingTax,
    required this.totalWrappingGross,
    required this.totalWrappingNet,
    required this.totalWrappingTax,
    required this.discountGross,
    required this.discountNet,
    required this.discountTax,
    required this.discountPercent,
    required this.discountPercentAmountGross,
    required this.discountPercentAmountNet,
    required this.discountPercentAmountTax,
    required this.posDiscountPercentAmountGross,
    required this.posDiscountPercentAmountNet,
    required this.posDiscountPercentAmountTax,
    required this.additionalAmountNet,
    required this.additionalAmountTax,
    required this.additionalAmountGross,
    required this.profit,
    required this.profitExclShipping,
    required this.profitExclWrapping,
    required this.profitExclShippingAndWrapping,
    required this.bankDetails,
    required this.listOfPayments,
    required this.listOfReceiptProduct,
    required this.listOfParcelTracking,
    required this.receiptCarrier,
    required this.receiptMarketplace,
    required this.creationDateMarektplace,
    this.packagingBox,
    required this.creationDate,
    required this.creationDateInt,
    required this.lastEditingDate,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) => _$ReceiptFromJson(json);

  Map<String, dynamic> toJson() => _$ReceiptToJson(this);

  factory Receipt.fromOfferGenAppointment({
    required Receipt offer,
    required MainSettings settings,
    required int nextAppointmentNumber,
  }) {
    final now = DateTime.now();
    return offer.copyWith(
      appointmentId: nextAppointmentNumber,
      appointmentNumberAsString: settings.appointmentPraefix + nextAppointmentNumber.toString(),
      receiptTyp: ReceiptType.appointment,
      receiptDocumentText: settings.appointmentDocumentText,
      commentInternal: '',
      creationDate: now,
      creationDateInt: now.microsecondsSinceEpoch,
      lastEditingDate: now,
    );
  }

  factory Receipt.fromAppointmentGenDeliveryNote({
    required Receipt appointment,
    required MainSettings settings,
    required int nextDeliveryNoteNumber,
    required int nextInvoiceNumber,
    required bool generateInvoice,
  }) {
    final now = DateTime.now();

    return appointment.copyWith(
      deliveryNoteId: nextDeliveryNoteNumber,
      deliveryNoteNumberAsString: settings.deliveryNotePraefix + nextDeliveryNoteNumber.toString(),
      invoiceId: generateInvoice ? nextInvoiceNumber : appointment.invoiceId,
      invoiceNumberAsString: generateInvoice ? settings.invoicePraefix + nextInvoiceNumber.toString() : appointment.invoiceNumberAsString,
      receiptTyp: ReceiptType.deliveryNote,
      receiptDocumentText: settings.deliveryNoteDocumentText,
      commentInternal: '',
      creationDate: now,
      creationDateInt: now.microsecondsSinceEpoch,
      lastEditingDate: now,
    );
  }

  factory Receipt.fromAppointmentGenInvoice({
    required Receipt appointment,
    required MainSettings settings,
    required int nextDeliveryNoteNumber,
    required int nextInvoiceNumber,
    required bool generateDeliveryNote,
  }) {
    final now = DateTime.now();

    return appointment.copyWith(
      deliveryNoteId: generateDeliveryNote ? nextDeliveryNoteNumber : appointment.deliveryNoteId,
      deliveryNoteNumberAsString:
          generateDeliveryNote ? settings.deliveryNotePraefix + nextDeliveryNoteNumber.toString() : appointment.deliveryNoteNumberAsString,
      invoiceId: nextInvoiceNumber,
      invoiceNumberAsString: settings.invoicePraefix + nextInvoiceNumber.toString(),
      receiptTyp: ReceiptType.invoice,
      appointmentStatus: AppointmentStatus.completed,
      receiptDocumentText: settings.invoiceDocumentText,
      commentInternal: '',
      creationDate: now,
      creationDateInt: now.microsecondsSinceEpoch,
      lastEditingDate: now,
    );
  }

  factory Receipt.fromDeliveryNotesGenInvoice({
    required List<Receipt> deliveryNotes,
    required MainSettings settings,
  }) {
    final now = DateTime.now();

    if (deliveryNotes.length == 1) {
      return deliveryNotes.first.copyWith(
        deliveryNoteId: deliveryNotes.first.deliveryNoteId,
        deliveryNoteNumberAsString: deliveryNotes.first.deliveryNoteNumberAsString,
        invoiceId: settings.nextInvoiceNumber,
        invoiceNumberAsString: settings.invoicePraefix + settings.nextInvoiceNumber.toString(),
        receiptTyp: ReceiptType.invoice,
        appointmentStatus: AppointmentStatus.completed,
        receiptDocumentText: settings.invoiceDocumentText,
        commentInternal: '',
        creationDate: now,
        creationDateInt: now.microsecondsSinceEpoch,
        lastEditingDate: now,
      );
    }

    final listOfDeliveryNoteIds = deliveryNotes.map((e) => e.deliveryNoteId).toList();
    final weight = deliveryNotes.map((e) => e.weight).toList().fold(0.0, (a, b) => a + b);
    final totalGross = deliveryNotes.map((e) => e.totalGross).toList().fold(0.0, (a, b) => a + b);
    final totalNet = totalGross / taxToCalc(deliveryNotes.first.tax.taxRate);
    final totalTax = totalGross - totalNet;
    final subTotalGross = deliveryNotes.map((e) => e.subTotalGross).toList().fold(0.0, (a, b) => a + b);
    final subTotalNet = subTotalGross / taxToCalc(deliveryNotes.first.tax.taxRate);
    final subTotalTax = subTotalGross - subTotalNet;
    final totalShippingGross = deliveryNotes.map((e) => e.totalShippingGross).toList().fold(0.0, (a, b) => a + b);
    final totalShippingNet = totalShippingGross / taxToCalc(deliveryNotes.first.tax.taxRate);
    final totalShippingTax = totalShippingGross - totalShippingNet;
    final discountGross = deliveryNotes.map((e) => e.discountGross).toList().fold(0.0, (a, b) => a + b);
    final discountNet = discountGross / taxToCalc(deliveryNotes.first.tax.taxRate);
    final discountTax = discountGross - discountNet;
    final discountPercentAmountGross = deliveryNotes.map((e) => e.discountPercentAmountGross).toList().fold(0.0, (a, b) => a + b);
    final discountPercentAmountNet = discountPercentAmountGross / taxToCalc(deliveryNotes.first.tax.taxRate);
    final discountPercentAmountTax = discountPercentAmountGross - discountPercentAmountNet;
    final additionalAmountGross = deliveryNotes.map((e) => e.additionalAmountGross).toList().fold(0.0, (a, b) => a + b);
    final additionalAmountNet = additionalAmountGross / taxToCalc(deliveryNotes.first.tax.taxRate);
    final additionalAmountTax = additionalAmountGross - additionalAmountNet;
    List<Payment> listOfPayments = [];
    for (final deliveryNote in deliveryNotes) {
      listOfPayments.addAll(deliveryNote.listOfPayments);
    }
    List<ReceiptProduct> listOfReceiptProduct = [];
    for (final deliveryNote in deliveryNotes) {
      listOfReceiptProduct.addAll(deliveryNote.listOfReceiptProduct);
    }
    List<ParcelTracking> listOfParcelTracking = [];
    for (final deliveryNote in deliveryNotes) {
      listOfParcelTracking.addAll(deliveryNote.listOfParcelTracking);
    }

    return deliveryNotes.first.copyWith(
      listOfDeliveryNoteIds: listOfDeliveryNoteIds,
      invoiceId: settings.nextInvoiceNumber,
      invoiceNumberAsString: settings.invoicePraefix + settings.nextInvoiceNumber.toString(),
      receiptTyp: ReceiptType.invoice,
      appointmentStatus: AppointmentStatus.completed,
      receiptDocumentText: settings.invoiceDocumentText,
      weight: weight,
      totalGross: totalGross,
      totalNet: totalNet,
      totalTax: totalTax,
      subTotalGross: subTotalGross,
      subTotalNet: subTotalNet,
      subTotalTax: subTotalTax,
      totalShippingGross: totalShippingGross,
      totalShippingNet: totalShippingNet,
      totalShippingTax: totalShippingTax,
      discountGross: discountGross,
      discountNet: discountNet,
      discountTax: discountTax,
      discountPercentAmountGross: discountPercentAmountGross,
      discountPercentAmountNet: discountPercentAmountNet,
      discountPercentAmountTax: discountPercentAmountTax,
      additionalAmountGross: additionalAmountGross,
      additionalAmountNet: additionalAmountNet,
      additionalAmountTax: additionalAmountTax,
      profit: deliveryNotes.map((e) => e.profit).toList().fold(0.0, (a, b) => a! + b),
      profitExclShipping: deliveryNotes.map((e) => e.profitExclShipping).toList().fold(0.0, (a, b) => a! + b),
      profitExclWrapping: deliveryNotes.map((e) => e.profitExclWrapping).toList().fold(0.0, (a, b) => a! + b),
      profitExclShippingAndWrapping: deliveryNotes.map((e) => e.profitExclShippingAndWrapping).toList().fold(0.0, (a, b) => a! + b),
      listOfPayments: listOfPayments,
      listOfReceiptProduct: listOfReceiptProduct,
      listOfParcelTracking: listOfParcelTracking,
      commentInternal: '',
      creationDate: now,
      creationDateInt: now.microsecondsSinceEpoch,
      lastEditingDate: now,
    );
  }

  factory Receipt.fromInvoiceGenCredit({
    required Receipt invoice,
    required MainSettings settings,
    required int nextInvoiceNumber,
  }) {
    final now = DateTime.now();
    return invoice.copyWith(
      invoiceId: nextInvoiceNumber,
      invoiceNumberAsString: settings.creditPraefix + nextInvoiceNumber.toString(),
      receiptTyp: ReceiptType.credit,
      receiptDocumentText: settings.creditDocumentText,
      commentInternal: '',
      creationDate: now,
      creationDateInt: now.microsecondsSinceEpoch,
      lastEditingDate: now,
    );
  }

  factory Receipt.genPartial(GenType genType, Receipt originalAppointment) {
    List<ReceiptProduct> receiptProducts = [];
    for (final receiptProduct in originalAppointment.listOfReceiptProduct) {
      if (genType == GenType.partialRest) {
        if (receiptProduct.shippedQuantity >= receiptProduct.quantity || receiptProduct.shippedQuantity < 0) continue;
      }
      if (genType == GenType.partialToCreate) {
        if (receiptProduct.shippedQuantity == 0) continue;
      }

      final discountPercentAmountGrossUnit =
          (calcPercentageAmount(receiptProduct.unitPriceGross, receiptProduct.discountPercent)).toMyRoundedDouble();
      final discountPercentAmountNetUnit = (discountPercentAmountGrossUnit / taxToCalc(receiptProduct.tax.taxRate)).toMyRoundedDouble();
      final profitUnit = receiptProduct.unitPriceNet - receiptProduct.wholesalePrice - receiptProduct.discountNetUnit;
      final quantity = switch (genType) {
        GenType.partialToCreate => receiptProduct.shippedQuantity,
        GenType.partialRest => receiptProduct.quantity - receiptProduct.shippedQuantity,
      };
      final shippedQuantity = switch (genType) {
        GenType.partialToCreate => receiptProduct.shippedQuantity,
        GenType.partialRest => 0,
      };
      final profit = switch (genType) {
        GenType.partialToCreate => profitUnit * shippedQuantity,
        GenType.partialRest => profitUnit * quantity,
      };
      final discountGross = switch (genType) {
        GenType.partialToCreate => ((discountPercentAmountGrossUnit + receiptProduct.discountGrossUnit) * shippedQuantity).toMyRoundedDouble(),
        GenType.partialRest => ((discountPercentAmountGrossUnit + receiptProduct.discountGrossUnit) * quantity).toMyRoundedDouble(),
      };
      final discountNet = switch (genType) {
        GenType.partialToCreate => ((discountPercentAmountNetUnit + receiptProduct.discountNetUnit) * shippedQuantity).toMyRoundedDouble(),
        GenType.partialRest => ((discountPercentAmountNetUnit + receiptProduct.discountNetUnit) * quantity).toMyRoundedDouble(),
      };
      final newReceiptProduct = receiptProduct.copyWith(
        quantity: quantity,
        shippedQuantity: shippedQuantity,
        discountGross: discountGross,
        discountNet: discountNet,
        discountPercentAmountGrossUnit: discountPercentAmountGrossUnit,
        discountPercentAmountNetUnit: discountPercentAmountNetUnit,
        profitUnit: profitUnit,
        profit: profit,
      );
      receiptProducts.add(newReceiptProduct);
    }

    final phAppointment = switch (originalAppointment.appointmentStatus) {
      AppointmentStatus.open => genType == GenType.partialRest
          ? originalAppointment
          : originalAppointment.copyWith(
              listOfReceiptProduct: receiptProducts,
            ),
      AppointmentStatus.partiallyCompleted => originalAppointment.copyWith(
          listOfReceiptProduct: receiptProducts,
          totalShippingGross: 0,
          totalShippingNet: 0,
          totalShippingTax: 0,
          totalWrappingGross: 0,
          totalWrappingNet: 0,
          totalWrappingTax: 0,
          discountGross: 0,
          discountNet: 0,
          discountTax: 0,
          additionalAmountNet: 0,
          additionalAmountTax: 0,
          additionalAmountGross: 0,
        ),
      _ => throw Error(),
    };

    final productsTotalNet =
        (receiptProducts.map((e) => e.unitPriceNet * e.quantity).toList().reduce((value, element) => value + element)).toMyRoundedDouble();
    final productsTotalGross =
        (receiptProducts.map((e) => e.unitPriceGross * e.quantity).toList().reduce((value, element) => value + element)).toMyRoundedDouble();
    final double posDiscountPercentAmount = receiptProducts.fold(
        0, (prev, product) => prev + (calcPercentageAmount(product.unitPriceGross * product.quantity, product.discountPercent)).toMyRoundedDouble());
    final discountPercentageAmountGross = (calcPercentageAmount(productsTotalGross, phAppointment.discountPercent)).toMyRoundedDouble();
    final tax = phAppointment.tax.taxRate;
    final taxAmount = productsTotalGross -
        productsTotalNet -
        calcTaxAmountFromGross(posDiscountPercentAmount, tax).toMyRoundedDouble() -
        calcTaxAmountFromGross(discountPercentageAmountGross, tax).toMyRoundedDouble() -
        calcTaxAmountFromGross(phAppointment.discountGross, tax).toMyRoundedDouble() +
        calcTaxAmountFromGross(phAppointment.totalShippingGross, tax).toMyRoundedDouble() +
        calcTaxAmountFromGross(phAppointment.additionalAmountGross, tax).toMyRoundedDouble();
    final totalGross = productsTotalGross -
        posDiscountPercentAmount -
        discountPercentageAmountGross -
        phAppointment.discountGross +
        phAppointment.totalShippingGross +
        phAppointment.additionalAmountGross;
    double profit = switch (genType) {
      GenType.partialRest => 0,
      GenType.partialToCreate => switch (originalAppointment.appointmentStatus) {
          AppointmentStatus.open => phAppointment.totalShippingNet,
          AppointmentStatus.partiallyCompleted => 0,
          _ => throw Error(),
        }
    };
    for (var product in receiptProducts) {
      profit += product.profit;
    }
    final newReceipt = phAppointment.copyWith(
      totalGross: totalGross,
      totalNet: (totalGross / taxToCalc(tax)).toMyRoundedDouble(),
      totalTax: taxAmount,
      subTotalNet: productsTotalNet,
      subTotalTax: productsTotalGross - productsTotalNet,
      subTotalGross: productsTotalGross,
      discountPercent: phAppointment.discountPercent,
      discountPercentAmountGross: discountPercentageAmountGross,
      discountPercentAmountNet: (discountPercentageAmountGross / taxToCalc(tax)).toMyRoundedDouble(),
      discountPercentAmountTax: (discountPercentageAmountGross - (discountPercentageAmountGross / taxToCalc(tax))).toMyRoundedDouble(),
      posDiscountPercentAmountGross: posDiscountPercentAmount,
      posDiscountPercentAmountNet: (posDiscountPercentAmount / taxToCalc(tax)).toMyRoundedDouble(),
      posDiscountPercentAmountTax: (posDiscountPercentAmount - (posDiscountPercentAmount / taxToCalc(tax))).toMyRoundedDouble(),
      profit: profit,
      profitExclShipping: profit - phAppointment.totalShippingNet,
      profitExclWrapping: profit - phAppointment.totalWrappingNet,
      profitExclShippingAndWrapping: profit - phAppointment.totalShippingNet - phAppointment.totalWrappingNet,
      listOfReceiptProduct: receiptProducts,
      commentInternal: '',
    );

    return newReceipt;
  }

  factory Receipt.fromOrderPresta({
    required MarketplacePresta marketplace,
    required MainSettings mainSettings,
    required List<ReceiptProduct> listOfReceiptproduct,
    required OrderPresta orderPresta,
    required CurrencyPresta currencyPresta,
    required CustomerPresta customerPresta,
    required AddressPresta addressInvoicePresta,
    required AddressPresta addressDeliveryPresta,
    required CountryPresta countryInvoicePresta,
    required CountryPresta countryDeliveryPresta,
    required CarrierPresta carrierPresta,
    required Customer customer,
  }) {
    double getTotalNet() =>
        (orderPresta.totalProducts).toMyDouble() +
        (orderPresta.totalShippingTaxExcl).toMyDouble() +
        (orderPresta.totalWrappingTaxExcl).toMyDouble() -
        (orderPresta.totalDiscountsTaxExcl).toMyDouble();

    double getTotalGross() =>
        (orderPresta.totalProductsWt).toMyDouble() +
        (orderPresta.totalShippingTaxIncl).toMyDouble() +
        (orderPresta.totalWrappingTaxIncl).toMyDouble() -
        (orderPresta.totalDiscountsTaxIncl).toMyDouble();

    PaymentMethod getPaymentMethod() {
      // TODO: sobald PaymentMethod in AddEditMarketplace gemappt werden kann, muss payment Methods darüber aufegrufen werden
      // TODO:  marketplace.paymentMethods.where((e) => e.nameInMarketplace == orderPresta.payment).firstOrNull;
      final paymentMethod = mainSettings.paymentMethods.where((e) => e.nameInMarketplace == orderPresta.payment).firstOrNull;
      if (paymentMethod != null) return paymentMethod;
      return PaymentMethod.empty().copyWith(
        name: orderPresta.payment,
        nameInMarketplace: orderPresta.payment,
        isPaidAutomatically: false,
        logoPath: 'assets/payment_methods/unknown_payment.png',
      );
    }

    PaymentStatus getPaymentStatus() {
      final totalGross = getTotalGross();
      if (getPaymentMethod().isPaidAutomatically) return PaymentStatus.paid;
      if ((orderPresta.totalPaidReal).toMyDouble().roundToDouble() >= totalGross.round()) return PaymentStatus.paid;
      if ((orderPresta.totalPaidReal).toMyDouble() > 0 && (orderPresta.totalPaidReal).toMyDouble() < totalGross) return PaymentStatus.partiallyPaid;
      return PaymentStatus.open;
    }

    final addressInvoice = Address.fromPresta(addressInvoicePresta, countryInvoicePresta, AddressType.invoice);

    final addressDelivery = Address.fromPresta(addressDeliveryPresta, countryDeliveryPresta, AddressType.delivery);

    String getUidNumber(String uidFromAddressInvoice, String uidFromAddressDelivery) {
      if (uidFromAddressInvoice != '') return uidFromAddressInvoice;
      if (uidFromAddressDelivery != '') return uidFromAddressDelivery;
      return '';
    }

    double profit = 0;
    for (final receiptProduct in listOfReceiptproduct) {
      profit += receiptProduct.profit;
    }
    profit = profit - (orderPresta.totalDiscountsTaxExcl).toMyDouble() + (orderPresta.totalShippingTaxExcl).toMyDouble();
    final profitExclShipping = profit - (orderPresta.totalShippingTaxExcl).toMyDouble();
    final profitExclWrapping = profit - (orderPresta.totalWrappingTaxExcl).toMyDouble();
    final profitExclShippingAndWrapping = profit - (orderPresta.totalShippingTaxExcl).toMyDouble() - (orderPresta.totalWrappingTaxExcl).toMyDouble();

    final carrierMapping = mainSettings.listOfCarriers.where((e) => e.marketplaceMapping == carrierPresta.name).firstOrNull;
    final carrier = switch (carrierMapping) {
      null => mainSettings.listOfCarriers.where((e) => e.isDefault).first,
      _ => carrierMapping,
    };
    CarrierProduct getCarrierProduct() {
      final isAutomationGiven = carrier.carrierAutomations.any((e) => e.country.isoCode == countryDeliveryPresta.isoCode && !e.isReturn);
      return switch (isAutomationGiven) {
        true => carrier.carrierAutomations.where((e) => e.country.isoCode == countryDeliveryPresta.isoCode && !e.isReturn).first,
        false => carrier.carrierAutomations.where((e) => e.country.name == '').firstOrNull ?? carrier.carrierAutomations.first,
      };
    }

    final carrierProduct = switch (carrier.carrierAutomations) {
      [] => switch (carrier.carrierTyp) {
          CarrierTyp.austrianPost => CarrierProduct.carrierProductListAustrianPost.first,
          CarrierTyp.dpd => CarrierProduct.carrierProductListDpd.first,
          CarrierTyp.empty => CarrierProduct.empty(),
        },
      _ => getCarrierProduct(),
    };
    final receiptCarrier = ReceiptCarrier(receiptCarrierName: carrier.name, carrierTyp: carrier.carrierTyp, carrierProduct: carrierProduct);

    final receiptMarketplace = ReceiptMarketplace(address: marketplace.address, bankDetails: marketplace.bankDetails, url: marketplace.url);

    // TODO: Look if needed or just solve in bloc
    //final searchField = '${customer.name} / ${customer.company} / ${customer.name} / ';

    return Receipt(
      id: '',
      receiptId: '',
      offerId: 0,
      offerNumberAsString: '',
      appointmentId: mainSettings.nextAppointmentNumber,
      appointmentNumberAsString: mainSettings.appointmentPraefix + mainSettings.nextAppointmentNumber.toString(),
      deliveryNoteId: 0,
      deliveryNoteNumberAsString: '',
      listOfDeliveryNoteIds: const [],
      invoiceId: 0,
      invoiceNumberAsString: '',
      creditId: 0,
      creditNumberAsString: '',
      marketplaceId: marketplace.id,
      receiptMarketplaceId: orderPresta.id,
      receiptMarketplaceReference: orderPresta.reference,
      paymentMethod: getPaymentMethod(),
      commentInternal: '',
      commentGlobal: '',
      currency: currencyPresta.symbol,
      receiptDocumentText: mainSettings.appointmentDocumentText,
      uidNumber: getUidNumber(addressInvoicePresta.vatNumber, addressDeliveryPresta.vatNumber),
      searchField: '', // TODO: searchfield
      customerId: customer.id,
      receiptCustomer: ReceiptCustomer.fromCustomer(customer),
      addressInvoice: addressInvoice,
      addressDelivery: addressDelivery,
      receiptTyp: ReceiptType.appointment,
      offerStatus: OfferStatus.noOffer,
      appointmentStatus: AppointmentStatus.open,
      paymentStatus: getPaymentStatus(),
      tax: mainSettings.taxes.where((e) => e.taxRate.round() == calcTaxPercent(getTotalGross(), getTotalNet()).round()).firstOrNull ??
          mainSettings.taxes.where((e) => e.isDefault).first,
      isSmallBusiness: mainSettings.isSmallBusiness,
      isPicked: false,
      isDeliveryBlocked: false,
      termOfPayment: mainSettings.termOfPayment,
      weight: listOfReceiptproduct.map((e) => e.weight).toList().fold(0.0, (a, b) => a + b),
      totalGross: getTotalGross(),
      totalNet: getTotalNet(),
      totalTax: getTotalGross() - getTotalNet(),
      subTotalNet: (orderPresta.totalProducts).toMyDouble(),
      subTotalTax: (orderPresta.totalProductsWt).toMyDouble() - (orderPresta.totalProducts).toMyDouble(),
      subTotalGross: (orderPresta.totalProductsWt).toMyDouble(),
      totalPaidGross: (orderPresta.totalPaidTaxIncl).toMyDouble(),
      totalPaidNet: (orderPresta.totalPaidTaxExcl).toMyDouble(),
      totalPaidTax: ((orderPresta.totalPaidTaxIncl).toMyDouble()) - ((orderPresta.totalPaidTaxExcl).toMyDouble()),
      totalShippingGross: (orderPresta.totalShippingTaxIncl).toMyDouble(),
      totalShippingNet: (orderPresta.totalShippingTaxExcl).toMyDouble(),
      totalShippingTax: (orderPresta.totalShippingTaxIncl).toMyDouble() - (orderPresta.totalShippingTaxExcl).toMyDouble(),
      totalWrappingGross: (orderPresta.totalWrappingTaxIncl).toMyDouble(),
      totalWrappingNet: (orderPresta.totalWrappingTaxExcl).toMyDouble(),
      totalWrappingTax: (orderPresta.totalWrappingTaxIncl).toMyDouble() - (orderPresta.totalWrappingTaxExcl).toMyDouble(),
      discountGross: (orderPresta.totalDiscountsTaxIncl).toMyDouble(),
      discountNet: (orderPresta.totalDiscountsTaxExcl).toMyDouble(),
      discountTax: (orderPresta.totalDiscountsTaxIncl).toMyDouble() - (orderPresta.totalDiscountsTaxExcl).toMyDouble(),
      // Von Prestashop kommen sowohl normale Rabatte als auch Prozenrabatte als normales Rabatt
      discountPercent: 0, //calcDiscountPercentage((orderPresta.totalProducts).toMyDouble(), (orderPresta.totalDiscountsTaxExcl).toMyDouble()),
      discountPercentAmountGross: 0,
      discountPercentAmountNet: 0,
      discountPercentAmountTax: 0,
      posDiscountPercentAmountGross: 0,
      posDiscountPercentAmountNet: 0,
      posDiscountPercentAmountTax: 0,
      additionalAmountNet: 0.0,
      additionalAmountTax: 0.0,
      additionalAmountGross: 0.0,
      profit: profit,
      profitExclShipping: profitExclShipping,
      profitExclWrapping: profitExclWrapping,
      profitExclShippingAndWrapping: profitExclShippingAndWrapping,
      bankDetails: mainSettings.bankDetails,
      listOfPayments: getPaymentStatus() != PaymentStatus.open
          ? [Payment((orderPresta.totalPaidReal).toMyDouble(), orderPresta.payment, DateTime.parse(orderPresta.dateAdd))]
          : [],
      listOfReceiptProduct: listOfReceiptproduct,
      listOfParcelTracking: const [],
      receiptCarrier: receiptCarrier,
      receiptMarketplace: receiptMarketplace,
      creationDateMarektplace: DateTime.parse(orderPresta.dateAdd),
      creationDate: DateTime.now(),
      creationDateInt: DateTime.parse(orderPresta.dateAdd).microsecondsSinceEpoch,
      lastEditingDate: DateTime.parse(orderPresta.dateAdd),
    );
  }

  factory Receipt.fromOrderShopify({
    required MarketplaceShopify marketplace,
    required MainSettings mainSettings,
    required List<ReceiptProduct> listOfReceiptproduct,
    required OrderShopify orderShopify,
    required Customer customer,
  }) {
    final tax = mainSettings.taxes.where((e) => e.taxRate.round() == ((orderShopify.taxLines.first.rate * 100).toStringAsFixed(0)).toMyInt()).first;
    final taxPercent = (orderShopify.taxLines.first.rate * 100).toInt();

    // Summer aller Artikel ohne Rabatte
    final subTotalGross = (orderShopify.totalLineItemsPrice).toMyDouble();
    final subTotalNet = (orderShopify.totalLineItemsPrice.toMyDouble() / taxToCalc(taxPercent)).toMyRoundedDouble();
    final subTotalTax = subTotalGross - subTotalNet;

    final totalGross = orderShopify.totalPrice.toMyDouble();
    final totalNet = totalGross - orderShopify.totalTax.toMyDouble();

    String getCurrency(String? currencyString) {
      return switch (currencyString) {
        null => '€',
        'EUR' => '€',
        _ => '€',
      };
    }

    PaymentMethod getPaymentMethod() {
      // TODO: sobald PaymentMethod in AddEditMarketplace gemappt werden kann, muss payment Methods darüber aufegrufen werden
      // TODO:  marketplace.paymentMethods.where((e) => e.nameInMarketplace == orderPresta.payment).firstOrNull;
      final paymentMethod = mainSettings.paymentMethods
          .where((e) => e.nameInMarketplace.toLowerCase() == orderShopify.paymentGatewayNames.first.toLowerCase())
          .firstOrNull;
      if (paymentMethod != null) return paymentMethod;
      return PaymentMethod.empty().copyWith(
        name: orderShopify.paymentGatewayNames.first,
        nameInMarketplace: orderShopify.paymentGatewayNames.first,
        isPaidAutomatically: false,
        logoPath: 'assets/payment_methods/unknown_payment.png',
      );
    }

    PaymentStatus getPaymentStatus() {
      if (getPaymentMethod().isPaidAutomatically) return PaymentStatus.paid;
      if (orderShopify.financialStatus == OrderShopifyFinancialStatus.paid) return PaymentStatus.paid;
      return PaymentStatus.open;
    }

    final addressInvoice = Address.fromShopify(orderShopify.billingAddress, AddressType.invoice);

    final addressDelivery = Address.fromShopify(orderShopify.shippingAddress, AddressType.delivery);

    // String getUidNumber(String uidFromAddressInvoice, String uidFromAddressDelivery) {
    //   if (uidFromAddressInvoice != '') return uidFromAddressInvoice;
    //   if (uidFromAddressDelivery != '') return uidFromAddressDelivery;
    //   return '';
    // }

    double profit = 0;
    for (final receiptProduct in listOfReceiptproduct) {
      profit += receiptProduct.profit;
    }

    final totalDiscountGross = orderShopify.totalDiscounts.toMyDouble();
    final totalDiscountNet = (orderShopify.totalDiscounts.toMyDouble() / taxToCalc(taxPercent)).toMyRoundedDouble();
    final totalShippingGross = orderShopify.totalShippingPriceSet.shopMoney.amount.toMyDouble();
    final totalShippingNet = (totalShippingGross / taxToCalc(taxPercent)).toMyRoundedDouble();
    profit = profit - totalDiscountNet + totalShippingNet;
    final profitExclShipping = profit - totalShippingNet;
    final profitExclWrapping = profit - 0;
    final profitExclShippingAndWrapping = profit - totalShippingNet - 0;

    final carrierMapping = mainSettings.listOfCarriers.where((e) => e.marketplaceMapping == orderShopify.shippingLines.first.title).firstOrNull;
    final carrier = switch (carrierMapping) {
      null => mainSettings.listOfCarriers.where((e) => e.isDefault).first,
      _ => carrierMapping,
    };
    CarrierProduct getCarrierProduct() {
      final isAutomationGiven = carrier.carrierAutomations
          .any((e) => e.country.isoCode.toUpperCase() == orderShopify.shippingAddress.countryCode.toUpperCase() && !e.isReturn);
      return switch (isAutomationGiven) {
        true => carrier.carrierAutomations
            .where((e) => e.country.isoCode.toUpperCase() == orderShopify.shippingAddress.countryCode.toUpperCase() && !e.isReturn)
            .first,
        false => carrier.carrierAutomations.where((e) => e.country.name == '').firstOrNull ?? carrier.carrierAutomations.first,
      };
    }

    final carrierProduct = switch (carrier.carrierAutomations) {
      [] => switch (carrier.carrierTyp) {
          CarrierTyp.austrianPost => CarrierProduct.carrierProductListAustrianPost.first,
          CarrierTyp.dpd => CarrierProduct.carrierProductListDpd.first,
          CarrierTyp.empty => CarrierProduct.empty(),
        },
      _ => getCarrierProduct(),
    };
    final receiptCarrier = ReceiptCarrier(receiptCarrierName: carrier.name, carrierTyp: carrier.carrierTyp, carrierProduct: carrierProduct);

    final receiptMarketplace = ReceiptMarketplace(address: marketplace.address, bankDetails: marketplace.bankDetails, url: marketplace.url);

    // TODO: Look if needed or just solve in bloc
    //final searchField = '${customer.name} / ${customer.company} / ${customer.name} / ';

    return Receipt(
      id: '',
      receiptId: '',
      offerId: 0,
      offerNumberAsString: '',
      appointmentId: mainSettings.nextAppointmentNumber,
      appointmentNumberAsString: mainSettings.appointmentPraefix + mainSettings.nextAppointmentNumber.toString(),
      deliveryNoteId: 0,
      deliveryNoteNumberAsString: '',
      listOfDeliveryNoteIds: const [],
      invoiceId: 0,
      invoiceNumberAsString: '',
      creditId: 0,
      creditNumberAsString: '',
      marketplaceId: marketplace.id,
      receiptMarketplaceId: orderShopify.id,
      receiptMarketplaceReference: orderShopify.name,
      paymentMethod: getPaymentMethod(),
      commentInternal: '',
      commentGlobal: orderShopify.note ?? '',
      currency: getCurrency(orderShopify.currency),
      receiptDocumentText: mainSettings.appointmentDocumentText,
      uidNumber: '',
      searchField: '', // TODO: searchfield
      customerId: customer.id,
      receiptCustomer: ReceiptCustomer.fromCustomer(customer),
      addressInvoice: addressInvoice,
      addressDelivery: addressDelivery,
      receiptTyp: ReceiptType.appointment,
      offerStatus: OfferStatus.noOffer,
      appointmentStatus: AppointmentStatus.open,
      paymentStatus: getPaymentStatus(),
      tax: tax,
      isSmallBusiness: mainSettings.isSmallBusiness,
      isPicked: false,
      isDeliveryBlocked: false,
      termOfPayment: mainSettings.termOfPayment,
      weight: listOfReceiptproduct.map((e) => e.weight).toList().fold(0.0, (a, b) => a + b),
      totalGross: totalGross,
      totalNet: totalNet,
      totalTax: totalGross - totalNet,
      subTotalNet: subTotalNet,
      subTotalTax: subTotalTax,
      subTotalGross: subTotalGross,
      totalPaidGross: getPaymentStatus() == PaymentStatus.open ? 0 : totalGross,
      totalPaidNet: getPaymentStatus() == PaymentStatus.open ? 0 : totalNet,
      totalPaidTax: getPaymentStatus() == PaymentStatus.open ? 0 : totalGross - totalNet,
      totalShippingGross: totalShippingGross,
      totalShippingNet: totalShippingNet,
      totalShippingTax: totalShippingGross - totalShippingNet,
      totalWrappingGross: 0,
      totalWrappingNet: 0,
      totalWrappingTax: 0,
      discountGross: totalDiscountGross,
      discountNet: totalDiscountNet,
      discountTax: totalDiscountGross - totalDiscountNet,
      // Von Prestashop kommen sowohl normale Rabatte als auch Prozenrabatte als normales Rabatt
      discountPercent: 0, //calcDiscountPercentage((orderPresta.totalProducts).toMyDouble(), (orderPresta.totalDiscountsTaxExcl).toMyDouble()),
      discountPercentAmountGross: 0,
      discountPercentAmountNet: 0,
      discountPercentAmountTax: 0,
      posDiscountPercentAmountGross: 0,
      posDiscountPercentAmountNet: 0,
      posDiscountPercentAmountTax: 0,
      additionalAmountNet: 0.0,
      additionalAmountTax: 0.0,
      additionalAmountGross: 0.0,
      profit: profit,
      profitExclShipping: profitExclShipping,
      profitExclWrapping: profitExclWrapping,
      profitExclShippingAndWrapping: profitExclShippingAndWrapping,
      bankDetails: mainSettings.bankDetails,
      listOfPayments: getPaymentStatus() != PaymentStatus.open ? [Payment(totalGross, '', DateTime.parse(orderShopify.createdAt))] : [],
      listOfReceiptProduct: listOfReceiptproduct,
      listOfParcelTracking: const [],
      receiptCarrier: receiptCarrier,
      receiptMarketplace: receiptMarketplace,
      creationDateMarektplace: DateTime.parse(orderShopify.createdAt),
      creationDate: DateTime.now(),
      creationDateInt: DateTime.parse(orderShopify.createdAt).microsecondsSinceEpoch,
      lastEditingDate: DateTime.parse(orderShopify.updatedAt),
    );
  }

  factory Receipt.empty({ReceiptType? receiptType}) {
    return Receipt(
      id: '',
      receiptId: '',
      offerId: 0,
      offerNumberAsString: '',
      appointmentId: 0,
      appointmentNumberAsString: '',
      deliveryNoteId: 0,
      deliveryNoteNumberAsString: '',
      listOfDeliveryNoteIds: const [],
      invoiceId: 0,
      invoiceNumberAsString: '',
      creditId: 0,
      creditNumberAsString: '',
      marketplaceId: '',
      receiptMarketplaceId: 0,
      receiptMarketplaceReference: '',
      paymentMethod: PaymentMethod.empty(),
      commentInternal: '',
      commentGlobal: '',
      currency: '',
      receiptDocumentText: '',
      uidNumber: '',
      searchField: '',
      customerId: '',
      receiptCustomer: ReceiptCustomer.empty(),
      addressInvoice: Address.empty(),
      addressDelivery: Address.empty(),
      receiptTyp: receiptType ?? ReceiptType.appointment,
      offerStatus: OfferStatus.open,
      appointmentStatus: AppointmentStatus.open,
      paymentStatus: PaymentStatus.open,
      tax: Tax.empty(),
      isSmallBusiness: false,
      isPicked: false,
      isDeliveryBlocked: false,
      termOfPayment: 14,
      weight: 0.0,
      totalGross: 0,
      totalNet: 0,
      totalTax: 0,
      subTotalNet: 0,
      subTotalTax: 0,
      subTotalGross: 0,
      totalPaidGross: 0,
      totalPaidNet: 0,
      totalPaidTax: 0,
      totalShippingGross: 0,
      totalShippingNet: 0,
      totalShippingTax: 0,
      totalWrappingGross: 0,
      totalWrappingNet: 0,
      totalWrappingTax: 0,
      discountGross: 0,
      discountNet: 0,
      discountTax: 0,
      discountPercent: 0,
      discountPercentAmountGross: 0,
      discountPercentAmountNet: 0,
      discountPercentAmountTax: 0,
      posDiscountPercentAmountGross: 0,
      posDiscountPercentAmountNet: 0,
      posDiscountPercentAmountTax: 0,
      additionalAmountNet: 0,
      additionalAmountTax: 0,
      additionalAmountGross: 0,
      profit: 0,
      profitExclShipping: 0,
      profitExclWrapping: 0,
      profitExclShippingAndWrapping: 0,
      bankDetails: BankDetails.empty(),
      listOfPayments: const [],
      listOfReceiptProduct: const [],
      listOfParcelTracking: const [],
      receiptCarrier: ReceiptCarrier.empty(),
      receiptMarketplace: ReceiptMarketplace.empty(),
      creationDateMarektplace: DateTime.now(),
      packagingBox: null,
      creationDate: DateTime.now(),
      creationDateInt: 0,
      lastEditingDate: DateTime.now(),
    );
  }

  Receipt copyWith({
    String? id,
    String? receiptId,
    int? offerId,
    String? offerNumberAsString,
    int? appointmentId,
    String? appointmentNumberAsString,
    int? deliveryNoteId,
    String? deliveryNoteNumberAsString,
    List<int>? listOfDeliveryNoteIds,
    int? invoiceId,
    String? invoiceNumberAsString,
    int? creditId,
    String? creditNumberAsString,
    String? marketplaceId,
    int? receiptMarketplaceId,
    String? receiptMarketplaceReference,
    PaymentMethod? paymentMethod,
    String? commentInternal,
    String? commentGlobal,
    String? currency,
    String? receiptDocumentText,
    String? uidNumber,
    String? searchField,
    String? customerId,
    ReceiptCustomer? receiptCustomer,
    Address? addressInvoice,
    Address? addressDelivery,
    ReceiptType? receiptTyp,
    OfferStatus? offerStatus,
    AppointmentStatus? appointmentStatus,
    PaymentStatus? paymentStatus,
    Tax? tax,
    bool? isSmallBusiness,
    bool? isPicked,
    bool? isDeliveryBlocked,
    int? termOfPayment,
    double? weight,
    double? totalGross,
    double? totalNet,
    double? totalTax,
    double? subTotalNet,
    double? subTotalTax,
    double? subTotalGross,
    double? totalPaidGross,
    double? totalPaidNet,
    double? totalPaidTax,
    double? totalShippingGross,
    double? totalShippingNet,
    double? totalShippingTax,
    double? totalWrappingGross,
    double? totalWrappingNet,
    double? totalWrappingTax,
    double? discountGross,
    double? discountNet,
    double? discountTax,
    double? discountPercent,
    double? discountPercentAmountGross,
    double? discountPercentAmountNet,
    double? discountPercentAmountTax,
    double? posDiscountPercentAmountGross,
    double? posDiscountPercentAmountNet,
    double? posDiscountPercentAmountTax,
    double? additionalAmountNet,
    double? additionalAmountTax,
    double? additionalAmountGross,
    double? profit,
    double? profitExclShipping,
    double? profitExclWrapping,
    double? profitExclShippingAndWrapping,
    BankDetails? bankDetails,
    List<Payment>? listOfPayments,
    List<ReceiptProduct>? listOfReceiptProduct,
    List<ParcelTracking>? listOfParcelTracking,
    ReceiptCarrier? receiptCarrier,
    ReceiptMarketplace? receiptMarketplace,
    DateTime? creationDateMarektplace,
    PackagingBox? packagingBox,
    DateTime? creationDate,
    int? creationDateInt,
    DateTime? lastEditingDate,
  }) {
    return Receipt(
      id: id ?? this.id,
      receiptId: receiptId ?? this.receiptId,
      offerId: offerId ?? this.offerId,
      offerNumberAsString: offerNumberAsString ?? this.offerNumberAsString,
      appointmentId: appointmentId ?? this.appointmentId,
      appointmentNumberAsString: appointmentNumberAsString ?? this.appointmentNumberAsString,
      deliveryNoteId: deliveryNoteId ?? this.deliveryNoteId,
      deliveryNoteNumberAsString: deliveryNoteNumberAsString ?? this.deliveryNoteNumberAsString,
      listOfDeliveryNoteIds: listOfDeliveryNoteIds ?? this.listOfDeliveryNoteIds,
      invoiceId: invoiceId ?? this.invoiceId,
      invoiceNumberAsString: invoiceNumberAsString ?? this.invoiceNumberAsString,
      creditId: creditId ?? this.creditId,
      creditNumberAsString: creditNumberAsString ?? this.creditNumberAsString,
      marketplaceId: marketplaceId ?? this.marketplaceId,
      receiptMarketplaceId: receiptMarketplaceId ?? this.receiptMarketplaceId,
      receiptMarketplaceReference: receiptMarketplaceReference ?? this.receiptMarketplaceReference,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      commentInternal: commentInternal ?? this.commentInternal,
      commentGlobal: commentGlobal ?? this.commentGlobal,
      currency: currency ?? this.currency,
      receiptDocumentText: receiptDocumentText ?? this.receiptDocumentText,
      uidNumber: uidNumber ?? this.uidNumber,
      searchField: searchField ?? this.searchField,
      customerId: customerId ?? this.customerId,
      receiptCustomer: receiptCustomer ?? this.receiptCustomer,
      addressInvoice: addressInvoice ?? this.addressInvoice,
      addressDelivery: addressDelivery ?? this.addressDelivery,
      receiptTyp: receiptTyp ?? this.receiptTyp,
      offerStatus: offerStatus ?? this.offerStatus,
      appointmentStatus: appointmentStatus ?? this.appointmentStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      tax: tax ?? this.tax,
      isSmallBusiness: isSmallBusiness ?? this.isSmallBusiness,
      isPicked: isPicked ?? this.isPicked,
      isDeliveryBlocked: isDeliveryBlocked ?? this.isDeliveryBlocked,
      termOfPayment: termOfPayment ?? this.termOfPayment,
      weight: weight ?? this.weight,
      totalGross: totalGross ?? this.totalGross,
      totalNet: totalNet ?? this.totalNet,
      totalTax: totalTax ?? this.totalTax,
      subTotalNet: subTotalNet ?? this.subTotalNet,
      subTotalTax: subTotalTax ?? this.subTotalTax,
      subTotalGross: subTotalGross ?? this.subTotalGross,
      totalPaidGross: totalPaidGross ?? this.totalPaidGross,
      totalPaidNet: totalPaidNet ?? this.totalPaidNet,
      totalPaidTax: totalPaidTax ?? this.totalPaidTax,
      totalShippingGross: totalShippingGross ?? this.totalShippingGross,
      totalShippingNet: totalShippingNet ?? this.totalShippingNet,
      totalShippingTax: totalShippingTax ?? this.totalShippingTax,
      totalWrappingGross: totalWrappingGross ?? this.totalWrappingGross,
      totalWrappingNet: totalWrappingNet ?? this.totalWrappingNet,
      totalWrappingTax: totalWrappingTax ?? this.totalWrappingTax,
      discountGross: discountGross ?? this.discountGross,
      discountNet: discountNet ?? this.discountNet,
      discountTax: discountTax ?? this.discountTax,
      discountPercent: discountPercent ?? this.discountPercent,
      discountPercentAmountGross: discountPercentAmountGross ?? this.discountPercentAmountGross,
      discountPercentAmountNet: discountPercentAmountNet ?? this.discountPercentAmountNet,
      discountPercentAmountTax: discountPercentAmountTax ?? this.discountPercentAmountTax,
      posDiscountPercentAmountGross: posDiscountPercentAmountGross ?? this.posDiscountPercentAmountGross,
      posDiscountPercentAmountNet: posDiscountPercentAmountNet ?? this.posDiscountPercentAmountNet,
      posDiscountPercentAmountTax: posDiscountPercentAmountTax ?? this.posDiscountPercentAmountTax,
      additionalAmountNet: additionalAmountNet ?? this.additionalAmountNet,
      additionalAmountTax: additionalAmountTax ?? this.additionalAmountTax,
      additionalAmountGross: additionalAmountGross ?? this.additionalAmountGross,
      profit: profit ?? this.profit,
      profitExclShipping: profitExclShipping ?? this.profitExclShipping,
      profitExclWrapping: profitExclWrapping ?? this.profitExclWrapping,
      profitExclShippingAndWrapping: profitExclShippingAndWrapping ?? this.profitExclShippingAndWrapping,
      bankDetails: bankDetails ?? this.bankDetails,
      listOfPayments: listOfPayments ?? this.listOfPayments,
      listOfReceiptProduct: listOfReceiptProduct ?? this.listOfReceiptProduct,
      listOfParcelTracking: listOfParcelTracking ?? this.listOfParcelTracking,
      receiptCarrier: receiptCarrier ?? this.receiptCarrier,
      receiptMarketplace: receiptMarketplace ?? this.receiptMarketplace,
      creationDateMarektplace: creationDateMarektplace ?? this.creationDateMarektplace,
      packagingBox: packagingBox ?? this.packagingBox,
      creationDate: creationDate ?? this.creationDate,
      creationDateInt: creationDateInt ?? this.creationDateInt,
      lastEditingDate: lastEditingDate ?? this.lastEditingDate,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  bool get stringify => true;
}

extension ConvertReceiptTypeStringToEnum on String {
  ReceiptType toEnumRT() {
    return switch (this) {
      'appointment' => ReceiptType.appointment,
      'offer' => ReceiptType.offer,
      'deliveryNote' => ReceiptType.deliveryNote,
      'invoice' => ReceiptType.invoice,
      'credit' => ReceiptType.credit,
      _ => ReceiptType.appointment,
    };
  }
}

extension ConvertReceiptTypeStringToJsonString on ReceiptType {
  String toJsonString() {
    return switch (this) {
      ReceiptType.appointment => 'appointment',
      ReceiptType.offer => 'offer',
      ReceiptType.deliveryNote => 'deliveryNote',
      ReceiptType.invoice => 'invoice',
      ReceiptType.credit => 'credit',
    };
  }
}
