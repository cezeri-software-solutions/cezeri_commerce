// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Receipt _$ReceiptFromJson(Map<String, dynamic> json) => Receipt(
      receiptId: json['receiptId'] as String,
      offerId: json['offerId'] as int,
      offerNumberAsString: json['offerNumberAsString'] as String,
      appointmentId: json['appointmentId'] as int,
      appointmentNumberAsString: json['appointmentNumberAsString'] as String,
      invoiceId: json['invoiceId'] as int,
      invoiceNumberAsString: json['invoiceNumberAsString'] as String,
      creditId: json['creditId'] as int,
      creditNumberAsString: json['creditNumberAsString'] as String,
      receiptMarketplaceId: json['receiptMarketplaceId'] as int,
      receiptMarketplaceReference:
          json['receiptMarketplaceReference'] as String,
      paymentMethod: json['paymentMethod'] as String,
      commentInternal: json['commentInternal'] as String,
      commentGlobal: json['commentGlobal'] as String,
      currency: json['currency'] as String,
      receiptDocumentText: json['receiptDocumentText'] as String,
      uidNumber: json['uidNumber'] as String,
      searchField: json['searchField'] as String,
      customer: Customer.fromJson(json['customer'] as Map<String, dynamic>),
      receiptTyp: $enumDecode(_$ReceiptTypEnumMap, json['receiptTyp']),
      offerStatus: $enumDecode(_$OfferStatusEnumMap, json['offerStatus']),
      receiptStatus: $enumDecode(_$ReceiptStatusEnumMap, json['receiptStatus']),
      paymentStatus: $enumDecode(_$PaymentStatusEnumMap, json['paymentStatus']),
      tax: json['tax'] as int,
      termOfPayment: json['termOfPayment'] as int,
      totalGross: (json['totalGross'] as num).toDouble(),
      totalNet: (json['totalNet'] as num).toDouble(),
      totalTax: (json['totalTax'] as num).toDouble(),
      subTotalNet: (json['subTotalNet'] as num).toDouble(),
      subTotalTax: (json['subTotalTax'] as num).toDouble(),
      subTotalGross: (json['subTotalGross'] as num).toDouble(),
      totalPaidGross: (json['totalPaidGross'] as num).toDouble(),
      totalPaidNet: (json['totalPaidNet'] as num).toDouble(),
      totalPaidTax: (json['totalPaidTax'] as num).toDouble(),
      totalShippingGross: (json['totalShippingGross'] as num).toDouble(),
      totalShippingNet: (json['totalShippingNet'] as num).toDouble(),
      totalShippingTax: (json['totalShippingTax'] as num).toDouble(),
      totalWrappingGross: (json['totalWrappingGross'] as num).toDouble(),
      totalWrappingNet: (json['totalWrappingNet'] as num).toDouble(),
      totalWrappingTax: (json['totalWrappingTax'] as num).toDouble(),
      discountGross: (json['discountGross'] as num).toDouble(),
      discountNet: (json['discountNet'] as num).toDouble(),
      discountPercent: (json['discountPercent'] as num).toDouble(),
      profit: (json['profit'] as num).toDouble(),
      profitExclShipping: (json['profitExclShipping'] as num).toDouble(),
      profitExclWrapping: (json['profitExclWrapping'] as num).toDouble(),
      profitExclShippingAndWrapping:
          (json['profitExclShippingAndWrapping'] as num).toDouble(),
      bankDetails:
          BankDetails.fromJson(json['bankDetails'] as Map<String, dynamic>),
      listOfPayments: (json['listOfPayments'] as List<dynamic>)
          .map((e) => Payment.fromJson(e as Map<String, dynamic>))
          .toList(),
      listOfReceiptProduct: (json['listOfReceiptProduct'] as List<dynamic>)
          .map((e) => ReceiptProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      creationDateMarektplace:
          DateTime.parse(json['creationDateMarektplace'] as String),
      creationDate: DateTime.parse(json['creationDate'] as String),
      creationDateInt: json['creationDateInt'] as int,
      lastEditingDate: DateTime.parse(json['lastEditingDate'] as String),
    );

Map<String, dynamic> _$ReceiptToJson(Receipt instance) => <String, dynamic>{
      'receiptId': instance.receiptId,
      'offerId': instance.offerId,
      'offerNumberAsString': instance.offerNumberAsString,
      'appointmentId': instance.appointmentId,
      'appointmentNumberAsString': instance.appointmentNumberAsString,
      'invoiceId': instance.invoiceId,
      'invoiceNumberAsString': instance.invoiceNumberAsString,
      'creditId': instance.creditId,
      'creditNumberAsString': instance.creditNumberAsString,
      'receiptMarketplaceId': instance.receiptMarketplaceId,
      'receiptMarketplaceReference': instance.receiptMarketplaceReference,
      'paymentMethod': instance.paymentMethod,
      'commentInternal': instance.commentInternal,
      'commentGlobal': instance.commentGlobal,
      'currency': instance.currency,
      'receiptDocumentText': instance.receiptDocumentText,
      'uidNumber': instance.uidNumber,
      'searchField': instance.searchField,
      'customer': instance.customer.toJson(),
      'receiptTyp': _$ReceiptTypEnumMap[instance.receiptTyp]!,
      'offerStatus': _$OfferStatusEnumMap[instance.offerStatus]!,
      'receiptStatus': _$ReceiptStatusEnumMap[instance.receiptStatus]!,
      'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus]!,
      'tax': instance.tax,
      'termOfPayment': instance.termOfPayment,
      'totalGross': instance.totalGross,
      'totalNet': instance.totalNet,
      'totalTax': instance.totalTax,
      'subTotalNet': instance.subTotalNet,
      'subTotalTax': instance.subTotalTax,
      'subTotalGross': instance.subTotalGross,
      'totalPaidGross': instance.totalPaidGross,
      'totalPaidNet': instance.totalPaidNet,
      'totalPaidTax': instance.totalPaidTax,
      'totalShippingGross': instance.totalShippingGross,
      'totalShippingNet': instance.totalShippingNet,
      'totalShippingTax': instance.totalShippingTax,
      'totalWrappingGross': instance.totalWrappingGross,
      'totalWrappingNet': instance.totalWrappingNet,
      'totalWrappingTax': instance.totalWrappingTax,
      'discountGross': instance.discountGross,
      'discountNet': instance.discountNet,
      'discountPercent': instance.discountPercent,
      'profit': instance.profit,
      'profitExclShipping': instance.profitExclShipping,
      'profitExclWrapping': instance.profitExclWrapping,
      'profitExclShippingAndWrapping': instance.profitExclShippingAndWrapping,
      'bankDetails': instance.bankDetails.toJson(),
      'listOfPayments': instance.listOfPayments.map((e) => e.toJson()).toList(),
      'listOfReceiptProduct':
          instance.listOfReceiptProduct.map((e) => e.toJson()).toList(),
      'creationDateMarektplace':
          instance.creationDateMarektplace.toIso8601String(),
      'creationDate': instance.creationDate.toIso8601String(),
      'creationDateInt': instance.creationDateInt,
      'lastEditingDate': instance.lastEditingDate.toIso8601String(),
    };

const _$ReceiptTypEnumMap = {
  ReceiptTyp.appointment: 'appointment',
  ReceiptTyp.offer: 'offer',
  ReceiptTyp.invoice: 'invoice',
  ReceiptTyp.credit: 'credit',
};

const _$OfferStatusEnumMap = {
  OfferStatus.noOffer: 'noOffer',
  OfferStatus.open: 'open',
  OfferStatus.closed: 'closed',
};

const _$ReceiptStatusEnumMap = {
  ReceiptStatus.open: 'open',
  ReceiptStatus.completed: 'completed',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.open: 'open',
  PaymentStatus.partiallyPaid: 'partiallyPaid',
  PaymentStatus.paid: 'paid',
};
