// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Receipt _$ReceiptFromJson(Map<String, dynamic> json) => Receipt(
      id: json['id'] as String,
      receiptId: json['receiptId'] as String,
      offerId: (json['offerId'] as num).toInt(),
      offerNumberAsString: json['offerNumberAsString'] as String,
      appointmentId: (json['appointmentId'] as num).toInt(),
      appointmentNumberAsString: json['appointmentNumberAsString'] as String,
      deliveryNoteId: (json['deliveryNoteId'] as num).toInt(),
      deliveryNoteNumberAsString: json['deliveryNoteNumberAsString'] as String,
      listOfDeliveryNoteIds: (json['listOfDeliveryNoteIds'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      invoiceId: (json['invoiceId'] as num).toInt(),
      invoiceNumberAsString: json['invoiceNumberAsString'] as String,
      creditId: (json['creditId'] as num).toInt(),
      creditNumberAsString: json['creditNumberAsString'] as String,
      marketplaceId: json['marketplaceId'] as String,
      receiptMarketplaceId: (json['receiptMarketplaceId'] as num).toInt(),
      receiptMarketplaceReference:
          json['receiptMarketplaceReference'] as String,
      paymentMethod:
          PaymentMethod.fromJson(json['paymentMethod'] as Map<String, dynamic>),
      commentInternal: json['commentInternal'] as String,
      commentGlobal: json['commentGlobal'] as String,
      currency: json['currency'] as String,
      receiptDocumentText: json['receiptDocumentText'] as String,
      uidNumber: json['uidNumber'] as String,
      searchField: json['searchField'] as String,
      customerId: json['customerId'] as String,
      receiptCustomer: ReceiptCustomer.fromJson(
          json['receiptCustomer'] as Map<String, dynamic>),
      addressInvoice:
          Address.fromJson(json['addressInvoice'] as Map<String, dynamic>),
      addressDelivery:
          Address.fromJson(json['addressDelivery'] as Map<String, dynamic>),
      receiptTyp: $enumDecode(_$ReceiptTypeEnumMap, json['receiptTyp']),
      offerStatus: $enumDecode(_$OfferStatusEnumMap, json['offerStatus']),
      appointmentStatus:
          $enumDecode(_$AppointmentStatusEnumMap, json['appointmentStatus']),
      paymentStatus: $enumDecode(_$PaymentStatusEnumMap, json['paymentStatus']),
      tax: Tax.fromJson(json['tax'] as Map<String, dynamic>),
      isSmallBusiness: json['isSmallBusiness'] as bool,
      isPicked: json['isPicked'] as bool,
      isDeliveryBlocked: json['isDeliveryBlocked'] as bool,
      termOfPayment: (json['termOfPayment'] as num).toInt(),
      weight: (json['weight'] as num).toDouble(),
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
      discountTax: (json['discountTax'] as num).toDouble(),
      discountPercent: (json['discountPercent'] as num).toDouble(),
      discountPercentAmountGross:
          (json['discountPercentAmountGross'] as num).toDouble(),
      discountPercentAmountNet:
          (json['discountPercentAmountNet'] as num).toDouble(),
      discountPercentAmountTax:
          (json['discountPercentAmountTax'] as num).toDouble(),
      posDiscountPercentAmountGross:
          (json['posDiscountPercentAmountGross'] as num).toDouble(),
      posDiscountPercentAmountNet:
          (json['posDiscountPercentAmountNet'] as num).toDouble(),
      posDiscountPercentAmountTax:
          (json['posDiscountPercentAmountTax'] as num).toDouble(),
      additionalAmountNet: (json['additionalAmountNet'] as num).toDouble(),
      additionalAmountTax: (json['additionalAmountTax'] as num).toDouble(),
      additionalAmountGross: (json['additionalAmountGross'] as num).toDouble(),
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
      listOfParcelTracking: (json['listOfParcelTracking'] as List<dynamic>)
          .map((e) => ParcelTracking.fromJson(e as Map<String, dynamic>))
          .toList(),
      receiptCarrier: ReceiptCarrier.fromJson(
          json['receiptCarrier'] as Map<String, dynamic>),
      receiptMarketplace: ReceiptMarketplace.fromJson(
          json['receiptMarketplace'] as Map<String, dynamic>),
      creationDateMarektplace:
          DateTime.parse(json['creationDateMarektplace'] as String),
      packagingBox: json['packagingBox'] == null
          ? null
          : PackagingBox.fromJson(json['packagingBox'] as Map<String, dynamic>),
      creationDate: DateTime.parse(json['creationDate'] as String),
      creationDateInt: (json['creationDateInt'] as num?)?.toInt(),
      lastEditingDate: DateTime.parse(json['lastEditingDate'] as String),
    );

Map<String, dynamic> _$ReceiptToJson(Receipt instance) => <String, dynamic>{
      'id': instance.id,
      'receiptId': instance.receiptId,
      'offerId': instance.offerId,
      'offerNumberAsString': instance.offerNumberAsString,
      'appointmentId': instance.appointmentId,
      'appointmentNumberAsString': instance.appointmentNumberAsString,
      'deliveryNoteId': instance.deliveryNoteId,
      'deliveryNoteNumberAsString': instance.deliveryNoteNumberAsString,
      'listOfDeliveryNoteIds': instance.listOfDeliveryNoteIds,
      'invoiceId': instance.invoiceId,
      'invoiceNumberAsString': instance.invoiceNumberAsString,
      'creditId': instance.creditId,
      'creditNumberAsString': instance.creditNumberAsString,
      'marketplaceId': instance.marketplaceId,
      'receiptMarketplaceId': instance.receiptMarketplaceId,
      'receiptMarketplaceReference': instance.receiptMarketplaceReference,
      'paymentMethod': instance.paymentMethod.toJson(),
      'commentInternal': instance.commentInternal,
      'commentGlobal': instance.commentGlobal,
      'currency': instance.currency,
      'receiptDocumentText': instance.receiptDocumentText,
      'uidNumber': instance.uidNumber,
      'searchField': instance.searchField,
      'customerId': instance.customerId,
      'receiptCustomer': instance.receiptCustomer.toJson(),
      'addressInvoice': instance.addressInvoice.toJson(),
      'addressDelivery': instance.addressDelivery.toJson(),
      'receiptTyp': _$ReceiptTypeEnumMap[instance.receiptTyp]!,
      'offerStatus': _$OfferStatusEnumMap[instance.offerStatus]!,
      'appointmentStatus':
          _$AppointmentStatusEnumMap[instance.appointmentStatus]!,
      'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus]!,
      'tax': instance.tax.toJson(),
      'isSmallBusiness': instance.isSmallBusiness,
      'isPicked': instance.isPicked,
      'isDeliveryBlocked': instance.isDeliveryBlocked,
      'termOfPayment': instance.termOfPayment,
      'weight': instance.weight,
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
      'discountTax': instance.discountTax,
      'discountPercent': instance.discountPercent,
      'discountPercentAmountGross': instance.discountPercentAmountGross,
      'discountPercentAmountNet': instance.discountPercentAmountNet,
      'discountPercentAmountTax': instance.discountPercentAmountTax,
      'posDiscountPercentAmountGross': instance.posDiscountPercentAmountGross,
      'posDiscountPercentAmountNet': instance.posDiscountPercentAmountNet,
      'posDiscountPercentAmountTax': instance.posDiscountPercentAmountTax,
      'additionalAmountNet': instance.additionalAmountNet,
      'additionalAmountTax': instance.additionalAmountTax,
      'additionalAmountGross': instance.additionalAmountGross,
      'profit': instance.profit,
      'profitExclShipping': instance.profitExclShipping,
      'profitExclWrapping': instance.profitExclWrapping,
      'profitExclShippingAndWrapping': instance.profitExclShippingAndWrapping,
      'bankDetails': instance.bankDetails.toJson(),
      'listOfPayments': instance.listOfPayments.map((e) => e.toJson()).toList(),
      'listOfReceiptProduct':
          instance.listOfReceiptProduct.map((e) => e.toJson()).toList(),
      'listOfParcelTracking':
          instance.listOfParcelTracking.map((e) => e.toJson()).toList(),
      'receiptCarrier': instance.receiptCarrier.toJson(),
      'receiptMarketplace': instance.receiptMarketplace.toJson(),
      'creationDateMarektplace':
          instance.creationDateMarektplace.toIso8601String(),
      'packagingBox': instance.packagingBox?.toJson(),
      'creationDate': instance.creationDate.toIso8601String(),
      'creationDateInt': instance.creationDateInt,
      'lastEditingDate': instance.lastEditingDate.toIso8601String(),
    };

const _$ReceiptTypeEnumMap = {
  ReceiptType.appointment: 'appointment',
  ReceiptType.offer: 'offer',
  ReceiptType.deliveryNote: 'deliveryNote',
  ReceiptType.invoice: 'invoice',
  ReceiptType.credit: 'credit',
};

const _$OfferStatusEnumMap = {
  OfferStatus.noOffer: 'noOffer',
  OfferStatus.open: 'open',
  OfferStatus.closed: 'closed',
};

const _$AppointmentStatusEnumMap = {
  AppointmentStatus.open: 'open',
  AppointmentStatus.partiallyCompleted: 'partiallyCompleted',
  AppointmentStatus.completed: 'completed',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.open: 'open',
  PaymentStatus.partiallyPaid: 'partiallyPaid',
  PaymentStatus.paid: 'paid',
};
