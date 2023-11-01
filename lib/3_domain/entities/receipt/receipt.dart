import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:cezeri_commerce/3_domain/entities/carrier/carrier_product.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../1_presentation/core/functions/mixed_functions.dart';
import '../../entities_presta/address_presta.dart';
import '../../entities_presta/carrier_presta.dart';
import '../../entities_presta/country_presta.dart';
import '../../entities_presta/currency_presta.dart';
import '../../entities_presta/customer_presta.dart';
import '../../entities_presta/order_presta.dart';
import '../address.dart';
import '../carrier/carrier.dart';
import '../carrier/parcel_tracking.dart';
import '../customer/customer.dart';
import '../marketplace/marketplace.dart';
import '../settings/bank_details.dart';
import '../settings/main_settings.dart';
import '../settings/payment_method.dart';
import '../settings/tax.dart';
import 'payment.dart';
import 'receipt_carrier.dart';
import 'receipt_customer.dart';
import 'receipt_marketplace.dart';
import 'receipt_product.dart';

part 'receipt.g.dart';

// Ob es eine Rechnung oder eine Gutschrift ist
enum ReceiptTyp {
  appointment,
  offer,
  invoice,
  credit,
}

// Status für Angebote
// Gibt an, ob ein Angebot zu einem Auftrag geführt hat, oder ob es noch offen ist.
enum OfferStatus { noOffer, open, closed }

// Status des Auftrages (Ob daraus eine Rechnung entstanden ist)
enum ReceiptStatus { open, completed }

// Zahlungsstatus
enum PaymentStatus { open, partiallyPaid, paid }

@JsonSerializable(explicitToJson: true)
class Receipt {
  final String receiptId;
  final int offerId;
  final String offerNumberAsString;
  final int appointmentId;
  final String appointmentNumberAsString;
  final int deliveryNoteId;
  final String deliveryNoteNumberAsString;
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
  final ReceiptTyp receiptTyp;
  final OfferStatus offerStatus;
  final ReceiptStatus receiptStatus;
  final PaymentStatus paymentStatus;
  final Tax tax;
  final bool isSmallBusiness;
  final int termOfPayment;
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
  final DateTime creationDate; // Wenn importiert: DateTime import // Wenn dirkt angelegt: Datum Erstellung
  final int creationDateInt;
  final DateTime lastEditingDate;

  const Receipt({
    required this.receiptId,
    required this.offerId,
    required this.offerNumberAsString,
    required this.appointmentId,
    required this.appointmentNumberAsString,
    required this.deliveryNoteId,
    required this.deliveryNoteNumberAsString,
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
    required this.receiptStatus,
    required this.paymentStatus,
    required this.tax,
    required this.isSmallBusiness,
    required this.termOfPayment,
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
    required this.creationDate,
    required this.creationDateInt,
    required this.lastEditingDate,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) => _$ReceiptFromJson(json);

  Map<String, dynamic> toJson() => _$ReceiptToJson(this);

  factory Receipt.fromOrderPresta({
    required Marketplace marketplace,
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
        false => carrier.carrierAutomations.first,
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
      receiptId: '',
      offerId: 0,
      offerNumberAsString: '',
      appointmentId: mainSettings.nextAppointmentNumber,
      appointmentNumberAsString: mainSettings.appointmentPraefix + mainSettings.nextAppointmentNumber.toString(),
      deliveryNoteId: 0,
      deliveryNoteNumberAsString: '',
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
      receiptTyp: ReceiptTyp.appointment,
      offerStatus: OfferStatus.noOffer,
      receiptStatus: ReceiptStatus.open,
      paymentStatus: getPaymentStatus(),
      tax: mainSettings.taxes.where((e) => e.taxRate.round() == calcTaxPercent(getTotalGross(), getTotalNet()).round()).first,
      isSmallBusiness: mainSettings.isSmallBusiness,
      termOfPayment: mainSettings.termOfPayment,
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
      listOfParcelTracking: [],
      receiptCarrier: receiptCarrier,
      receiptMarketplace: receiptMarketplace,
      creationDateMarektplace: DateTime.parse(orderPresta.dateAdd),
      creationDate: DateTime.now(),
      creationDateInt: DateTime.parse(orderPresta.dateAdd).microsecondsSinceEpoch,
      lastEditingDate: DateTime.parse(orderPresta.dateAdd),
    );
  }

  factory Receipt.empty() {
    return Receipt(
      receiptId: '',
      offerId: 0,
      offerNumberAsString: '',
      appointmentId: 0,
      appointmentNumberAsString: '',
      deliveryNoteId: 0,
      deliveryNoteNumberAsString: '',
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
      receiptTyp: ReceiptTyp.appointment,
      offerStatus: OfferStatus.open,
      receiptStatus: ReceiptStatus.open,
      paymentStatus: PaymentStatus.open,
      tax: Tax.empty(),
      isSmallBusiness: false,
      termOfPayment: 14,
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
      listOfPayments: [],
      listOfReceiptProduct: [],
      listOfParcelTracking: [],
      receiptCarrier: ReceiptCarrier.empty(),
      receiptMarketplace: ReceiptMarketplace.empty(),
      creationDateMarektplace: DateTime.now(),
      creationDate: DateTime.now(),
      creationDateInt: 0,
      lastEditingDate: DateTime.now(),
    );
  }

  Receipt copyWith({
    String? receiptId,
    int? offerId,
    String? offerNumberAsString,
    int? appointmentId,
    String? appointmentNumberAsString,
    int? deliveryNoteId,
    String? deliveryNoteNumberAsString,
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
    ReceiptTyp? receiptTyp,
    OfferStatus? offerStatus,
    ReceiptStatus? receiptStatus,
    PaymentStatus? paymentStatus,
    Tax? tax,
    bool? isSmallBusiness,
    int? termOfPayment,
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
    DateTime? creationDate,
    int? creationDateInt,
    DateTime? lastEditingDate,
  }) {
    return Receipt(
      receiptId: receiptId ?? this.receiptId,
      offerId: offerId ?? this.offerId,
      offerNumberAsString: offerNumberAsString ?? this.offerNumberAsString,
      appointmentId: appointmentId ?? this.appointmentId,
      appointmentNumberAsString: appointmentNumberAsString ?? this.appointmentNumberAsString,
      deliveryNoteId: deliveryNoteId ?? this.deliveryNoteId,
      deliveryNoteNumberAsString: deliveryNoteNumberAsString ?? this.deliveryNoteNumberAsString,
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
      receiptStatus: receiptStatus ?? this.receiptStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      tax: tax ?? this.tax,
      isSmallBusiness: isSmallBusiness ?? this.isSmallBusiness,
      termOfPayment: termOfPayment ?? this.termOfPayment,
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
      creationDate: creationDate ?? this.creationDate,
      creationDateInt: creationDateInt ?? this.creationDateInt,
      lastEditingDate: lastEditingDate ?? this.lastEditingDate,
    );
  }

  @override
  String toString() {
    return 'Receipt(receiptId: $receiptId, offerId: $offerId, offerNumberAsString: $offerNumberAsString, appointmentId: $appointmentId, appointmentNumberAsString: $appointmentNumberAsString, deliveryNoteId: $deliveryNoteId, deliveryNoteNumberAsString: $deliveryNoteNumberAsString, invoiceId: $invoiceId, invoiceNumberAsString: $invoiceNumberAsString, creditId: $creditId, creditNumberAsString: $creditNumberAsString, marketplaceId: $marketplaceId, receiptMarketplaceId: $receiptMarketplaceId, receiptMarketplaceReference: $receiptMarketplaceReference, paymentMethod: $paymentMethod, commentInternal: $commentInternal, commentGlobal: $commentGlobal, currency: $currency, receiptDocumentText: $receiptDocumentText, uidNumber: $uidNumber, searchField: $searchField, customerId: $customerId, receiptCustomer: $receiptCustomer, addressInvoice: $addressInvoice, addressDelivery: $addressDelivery, receiptTyp: $receiptTyp, offerStatus: $offerStatus, receiptStatus: $receiptStatus, paymentStatus: $paymentStatus, tax: $tax, isSmallBusiness: $isSmallBusiness, termOfPayment: $termOfPayment, totalGross: $totalGross, totalNet: $totalNet, totalTax: $totalTax, subTotalNet: $subTotalNet, subTotalTax: $subTotalTax, subTotalGross: $subTotalGross, totalPaidGross: $totalPaidGross, totalPaidNet: $totalPaidNet, totalPaidTax: $totalPaidTax, totalShippingGross: $totalShippingGross, totalShippingNet: $totalShippingNet, totalShippingTax: $totalShippingTax, totalWrappingGross: $totalWrappingGross, totalWrappingNet: $totalWrappingNet, totalWrappingTax: $totalWrappingTax, discountGross: $discountGross, discountNet: $discountNet, discountTax: $discountTax, discountPercent: $discountPercent, discountPercentAmountGross: $discountPercentAmountGross, discountPercentAmountNet: $discountPercentAmountNet, discountPercentAmountTax: $discountPercentAmountTax, posDiscountPercentAmountGross: $posDiscountPercentAmountGross, posDiscountPercentAmountNet: $posDiscountPercentAmountNet, posDiscountPercentAmountTax: $posDiscountPercentAmountTax, additionalAmountNet: $additionalAmountNet, additionalAmountTax: $additionalAmountTax, additionalAmountGross: $additionalAmountGross, profit: $profit, profitExclShipping: $profitExclShipping, profitExclWrapping: $profitExclWrapping, profitExclShippingAndWrapping: $profitExclShippingAndWrapping, bankDetails: $bankDetails, listOfPayments: $listOfPayments, listOfReceiptProduct: $listOfReceiptProduct, listOfParcelTracking: $listOfParcelTracking, receiptCarrier: $receiptCarrier, receiptMarketplace: $receiptMarketplace, creationDateMarektplace: $creationDateMarektplace, creationDate: $creationDate, creationDateInt: $creationDateInt, lastEditingDate: $lastEditingDate)';
  }
}
