// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cezeri_commerce/3_domain/entities/id.dart';
import 'package:cezeri_helpers/cezeri_helpers.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../1_presentation/core/functions/mixed_functions.dart';
import '../../entities_presta/address_presta.dart';
import '../../entities_presta/country_presta.dart';
import '../../entities_presta/currency_presta.dart';
import '../../entities_presta/customer_presta.dart';
import '../../entities_presta/order_presta.dart';
import '../address.dart';
import '../customer/customer.dart';
import '../customer/customer_marketplace.dart';
import '../marketplace/marketplace.dart';
import '../settings/bank_details.dart';
import '../settings/main_settings.dart';
import '../settings/payment_method.dart';
import 'payment.dart';
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
  final int invoiceId;
  final String invoiceNumberAsString;
  final int creditId;
  final String creditNumberAsString;
  final String marketplaceId; // Id des Marketplace aus der dieses Dokument importiert bzw. erstellt wurde.
  final int receiptMarketplaceId;
  final String receiptMarketplaceReference;
  final PaymentMethod paymentMethod;
  final String commentInternal;
  final String commentGlobal;
  final String currency;
  final String receiptDocumentText;
  final String uidNumber;
  final String searchField;
  final Customer customer;
  final ReceiptTyp receiptTyp;
  final OfferStatus offerStatus;
  final ReceiptStatus receiptStatus;
  final PaymentStatus paymentStatus;
  final int tax;
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
  final double discountGross;
  final double discountNet;
  final double discountPercent;
  final double profit;
  final double profitExclShipping;
  final double profitExclWrapping;
  final double profitExclShippingAndWrapping;
  final BankDetails bankDetails;
  final List<Payment> listOfPayments;
  final List<ReceiptProduct> listOfReceiptProduct;
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
    required this.customer,
    required this.receiptTyp,
    required this.offerStatus,
    required this.receiptStatus,
    required this.paymentStatus,
    required this.tax,
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
    required this.discountPercent,
    required this.profit,
    required this.profitExclShipping,
    required this.profitExclWrapping,
    required this.profitExclShippingAndWrapping,
    required this.bankDetails,
    required this.listOfPayments,
    required this.listOfReceiptProduct,
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
  }) {
    double getTotalNet() =>
        double.parse(orderPresta.totalProducts) +
        double.parse(orderPresta.totalShippingTaxExcl) +
        double.parse(orderPresta.totalWrappingTaxExcl) -
        double.parse(orderPresta.totalDiscountsTaxExcl);

    double getTotalGross() =>
        double.parse(orderPresta.totalProductsWt) +
        double.parse(orderPresta.totalShippingTaxIncl) +
        double.parse(orderPresta.totalWrappingTaxIncl) -
        double.parse(orderPresta.totalDiscountsTaxIncl);

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
      if (double.parse(orderPresta.totalPaidReal).roundToDouble() >= totalGross.round()) return PaymentStatus.paid;
      if (double.parse(orderPresta.totalPaidReal) > 0 && double.parse(orderPresta.totalPaidReal) < totalGross) return PaymentStatus.partiallyPaid;
      return PaymentStatus.open;
    }

    final addressInvoice = Address.empty().copyWith(
      id: UniqueID().value,
      companyName: addressInvoicePresta.company,
      firstName: addressInvoicePresta.firstname,
      lastName: addressInvoicePresta.lastname,
      name: '${addressInvoicePresta.firstname} ${addressInvoicePresta.lastname}',
      street: addressInvoicePresta.address1,
      street2: addressInvoicePresta.address2,
      postcode: addressInvoicePresta.postcode,
      city: addressInvoicePresta.city,
      country: Country.countryList.where((e) => e.isoCode.toUpperCase() == countryInvoicePresta.isoCode.toUpperCase()).first,
      phone: addressInvoicePresta.phone,
      phoneMobile: addressInvoicePresta.phoneMobile,
      addressType: AddressType.invoice,
      isDefault: true,
      creationDate: DateTime.now(),
      lastEditingDate: DateTime.now(),
    );
    final addressDelivery = Address.empty().copyWith(
      id: UniqueID().value,
      companyName: addressDeliveryPresta.company,
      firstName: addressDeliveryPresta.firstname,
      lastName: addressDeliveryPresta.lastname,
      name: '${addressDeliveryPresta.firstname} ${addressDeliveryPresta.lastname}',
      street: addressDeliveryPresta.address1,
      street2: addressDeliveryPresta.address2,
      postcode: addressDeliveryPresta.postcode,
      city: addressDeliveryPresta.city,
      country: Country.empty().copyWith(
        id: UniqueID().value,
        isoCode: countryDeliveryPresta.isoCode,
        name: countryDeliveryPresta.name,
      ),
      phone: addressDeliveryPresta.phone,
      phoneMobile: addressDeliveryPresta.phoneMobile,
      addressType: AddressType.delivery,
      isDefault: true,
      creationDate: DateTime.now(),
      lastEditingDate: DateTime.now(),
    );

    // TODO: check if customer already exists
    final customer = Customer.empty().copyWith(
      customerMarketplace: CustomerMarketplace.empty().copyWith(
        customerIdMarketplace: customerPresta.id,
        marketplaceId: marketplace.id,
        marketplaceName: marketplace.name,
      ),
      company: customerPresta.company,
      firstName: customerPresta.firstname,
      lastName: customerPresta.lastname,
      name: '${customerPresta.firstname} ${customerPresta.lastname}',
      email: customerPresta.email,
      gender: switch (customerPresta.idGender) {
        '1' => Gender.male,
        '2' => Gender.female,
        (_) => Gender.empty,
      },
      birthday: customerPresta.birthday,
      isNewsletterAccepted: stringToBool(customerPresta.newsletter),
      isGuest: stringToBool(customerPresta.isGuest),
      listOfAddress: [addressInvoice, addressDelivery],
      creationDate: DateTime.now(),
      lastEditingDate: DateTime.now(),
    );

    String getUidNumber(String uidFromAddressInvoice, String uidFromAddressDelivery) {
      if (uidFromAddressInvoice != '') return uidFromAddressInvoice;
      if (uidFromAddressDelivery != '') return uidFromAddressDelivery;
      return '';
    }

    double profit = 0;
    for (final receiptProduct in listOfReceiptproduct) {
      profit += receiptProduct.profit;
    }
    profit = profit - double.parse(orderPresta.totalDiscountsTaxExcl);
    final profitExclShipping = profit - double.parse(orderPresta.totalShippingTaxExcl);
    final profitExclWrapping = profit - double.parse(orderPresta.totalWrappingTaxExcl);
    final profitExclShippingAndWrapping = profit - double.parse(orderPresta.totalShippingTaxExcl) - double.parse(orderPresta.totalWrappingTaxExcl);

    // TODO: Look if needed or just solve in bloc
    //final searchField = '${customer.name} / ${customer.company} / ${customer.name} / ';

    return Receipt(
      receiptId: '',
      offerId: 0,
      offerNumberAsString: '',
      appointmentId: mainSettings.nextAppointmentNumber,
      appointmentNumberAsString: mainSettings.appointmentPraefix + mainSettings.nextAppointmentNumber.toString(),
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
      customer: customer,
      receiptTyp: ReceiptTyp.appointment,
      offerStatus: OfferStatus.noOffer,
      receiptStatus: ReceiptStatus.open,
      paymentStatus: getPaymentStatus(),
      tax: calcTaxPercent(getTotalGross(), getTotalNet()),
      termOfPayment: mainSettings.termOfPayment,
      totalGross: getTotalGross(),
      totalNet: getTotalNet(),
      totalTax: getTotalGross() - getTotalNet(),
      subTotalNet: double.parse(orderPresta.totalProducts),
      subTotalTax: double.parse(orderPresta.totalProductsWt) - double.parse(orderPresta.totalProducts),
      subTotalGross: double.parse(orderPresta.totalProductsWt),
      totalPaidGross: double.parse(orderPresta.totalPaidTaxIncl),
      totalPaidNet: double.parse(orderPresta.totalPaidTaxExcl),
      totalPaidTax: (double.parse(orderPresta.totalPaidTaxIncl)) - (double.parse(orderPresta.totalPaidTaxExcl)),
      totalShippingGross: double.parse(orderPresta.totalShippingTaxIncl),
      totalShippingNet: double.parse(orderPresta.totalShippingTaxExcl),
      totalShippingTax: double.parse(orderPresta.totalShippingTaxIncl) - double.parse(orderPresta.totalShippingTaxExcl),
      totalWrappingGross: double.parse(orderPresta.totalWrappingTaxIncl),
      totalWrappingNet: double.parse(orderPresta.totalWrappingTaxExcl),
      totalWrappingTax: double.parse(orderPresta.totalWrappingTaxIncl) - double.parse(orderPresta.totalWrappingTaxExcl),
      discountGross: double.parse(orderPresta.totalDiscountsTaxIncl),
      discountNet: double.parse(orderPresta.totalDiscountsTaxExcl),
      // Von Prestashop kommen sowohl normale Rabatte als auch Prozenrabatte als normales Rabatt
      discountPercent: 0,//calcDiscountPercentage(double.parse(orderPresta.totalProducts), double.parse(orderPresta.totalDiscountsTaxExcl)),
      profit: profit,
      profitExclShipping: profitExclShipping,
      profitExclWrapping: profitExclWrapping,
      profitExclShippingAndWrapping: profitExclShippingAndWrapping,
      bankDetails: mainSettings.bankDetails,
      listOfPayments: getPaymentStatus() != PaymentStatus.open
          ? [Payment(double.parse(orderPresta.totalPaidReal), orderPresta.payment, DateTime.parse(orderPresta.dateAdd))]
          : [],
      listOfReceiptProduct: listOfReceiptproduct,
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
      customer: Customer.empty(),
      receiptTyp: ReceiptTyp.appointment,
      offerStatus: OfferStatus.open,
      receiptStatus: ReceiptStatus.open,
      paymentStatus: PaymentStatus.open,
      tax: 0,
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
      discountPercent: 0,
      profit: 0,
      profitExclShipping: 0,
      profitExclWrapping: 0,
      profitExclShippingAndWrapping: 0,
      bankDetails: BankDetails.empty(),
      listOfPayments: [],
      listOfReceiptProduct: [],
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
    Customer? customer,
    ReceiptTyp? receiptTyp,
    OfferStatus? offerStatus,
    ReceiptStatus? receiptStatus,
    PaymentStatus? paymentStatus,
    int? tax,
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
    double? discountPercent,
    double? profit,
    double? profitExclShipping,
    double? profitExclWrapping,
    double? profitExclShippingAndWrapping,
    BankDetails? bankDetails,
    List<Payment>? listOfPayments,
    List<ReceiptProduct>? listOfReceiptProduct,
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
      customer: customer ?? this.customer,
      receiptTyp: receiptTyp ?? this.receiptTyp,
      offerStatus: offerStatus ?? this.offerStatus,
      receiptStatus: receiptStatus ?? this.receiptStatus,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      tax: tax ?? this.tax,
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
      discountPercent: discountPercent ?? this.discountPercent,
      profit: profit ?? this.profit,
      profitExclShipping: profitExclShipping ?? this.profitExclShipping,
      profitExclWrapping: profitExclWrapping ?? this.profitExclWrapping,
      profitExclShippingAndWrapping: profitExclShippingAndWrapping ?? this.profitExclShippingAndWrapping,
      bankDetails: bankDetails ?? this.bankDetails,
      listOfPayments: listOfPayments ?? this.listOfPayments,
      listOfReceiptProduct: listOfReceiptProduct ?? this.listOfReceiptProduct,
      creationDateMarektplace: creationDateMarektplace ?? this.creationDateMarektplace,
      creationDate: creationDate ?? this.creationDate,
      creationDateInt: creationDateInt ?? this.creationDateInt,
      lastEditingDate: lastEditingDate ?? this.lastEditingDate,
    );
  }

  @override
  String toString() {
    return 'Receipt(receiptId: $receiptId, offerId: $offerId, offerNumberAsString: $offerNumberAsString, appointmentId: $appointmentId, appointmentNumberAsString: $appointmentNumberAsString, invoiceId: $invoiceId, invoiceNumberAsString: $invoiceNumberAsString, creditId: $creditId, creditNumberAsString: $creditNumberAsString, marketplaceId: $marketplaceId, receiptMarketplaceId: $receiptMarketplaceId, receiptMarketplaceReference: $receiptMarketplaceReference, paymentMethod: $paymentMethod, commentInternal: $commentInternal, commentGlobal: $commentGlobal, currency: $currency, receiptDocumentText: $receiptDocumentText, uidNumber: $uidNumber, searchField: $searchField, customer: $customer, receiptTyp: $receiptTyp, offerStatus: $offerStatus, receiptStatus: $receiptStatus, paymentStatus: $paymentStatus, tax: $tax, termOfPayment: $termOfPayment, totalGross: $totalGross, totalNet: $totalNet, totalTax: $totalTax, subTotalNet: $subTotalNet, subTotalTax: $subTotalTax, subTotalGross: $subTotalGross, totalPaidGross: $totalPaidGross, totalPaidNet: $totalPaidNet, totalPaidTax: $totalPaidTax, totalShippingGross: $totalShippingGross, totalShippingNet: $totalShippingNet, totalShippingTax: $totalShippingTax, totalWrappingGross: $totalWrappingGross, totalWrappingNet: $totalWrappingNet, totalWrappingTax: $totalWrappingTax, discountGross: $discountGross, discountNet: $discountNet, discountPercent: $discountPercent, profit: $profit, profitExclShipping: $profitExclShipping, profitExclWrapping: $profitExclWrapping, profitExclShippingAndWrapping: $profitExclShippingAndWrapping, bankDetails: $bankDetails, listOfPayments: $listOfPayments, listOfReceiptProduct: $listOfReceiptProduct, creationDateMarektplace: $creationDateMarektplace, creationDate: $creationDate, creationDateInt: $creationDateInt, lastEditingDate: $lastEditingDate)';
  }
}
