// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_shopify.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderShopify _$OrderShopifyFromJson(Map<String, dynamic> json) => OrderShopify(
      appId: (json['app_id'] as num?)?.toInt(),
      billingAddress: CustomerAddressShopify.fromJson(
          json['billing_address'] as Map<String, dynamic>),
      browserIp: json['browser_ip'] as String?,
      buyerAcceptsMarketing: json['buyer_accepts_marketing'] as bool,
      cancelReason: json['cancel_reason'] as String?,
      cancelledAt: json['cancelled_at'] as String?,
      cartToken: json['cart_token'] as String?,
      checkoutToken: json['checkout_token'] as String?,
      clientDetails: json['client_details'] as Map<String, dynamic>?,
      closedAt: json['closed_at'] as String?,
      company: json['company'] as Map<String, dynamic>?,
      confirmationNumber: json['confirmation_number'] as String,
      createdAt: json['created_at'] as String,
      currency: json['currency'] as String,
      currentTotalAdditionalFeesSet:
          json['current_total_additional_fees_set'] as String?,
      currentTotalDiscounts: json['current_total_discounts'] as String,
      currentTotalDiscountsSet:
          json['current_total_discounts_set'] as Map<String, dynamic>,
      currentTotalDutiesSet:
          json['current_total_duties_set'] as Map<String, dynamic>?,
      currentTotalPrice: json['current_total_price'] as String,
      currentTotalPriceSet:
          json['current_total_price_set'] as Map<String, dynamic>,
      currentSubtotalPrice: json['current_subtotal_price'] as String,
      currentSubtotalPriceSet:
          json['current_subtotal_price_set'] as Map<String, dynamic>,
      currentTotalTax: json['current_total_tax'] as String,
      currentTotalTaxSet: json['current_total_tax_set'] as Map<String, dynamic>,
      customer: OrderCustomerShopify.fromJson(
          json['customer'] as Map<String, dynamic>),
      customerLocale: json['customer_locale'] as String?,
      discountApplications: (json['discount_applications'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      discountCodes: (json['discount_codes'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      email: json['email'] as String?,
      estimatedTaxes: json['estimated_taxes'] as bool,
      financialStatus: OrderShopify._financialStatusFromJson(
          json['financial_status'] as String),
      fulfillments: (json['fulfillments'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      fulfillmentStatus: OrderShopify._fulfillmentStatusFromJson(
          json['fulfillment_status'] as String?),
      id: (json['id'] as num).toInt(),
      landingSite: json['landing_site'] as String?,
      lineItems: (json['line_items'] as List<dynamic>)
          .map((e) => LineItemShopify.fromJson(e as Map<String, dynamic>))
          .toList(),
      locationId: (json['location_id'] as num?)?.toInt(),
      merchantOfRecordAppId:
          (json['merchant_of_record_app_id'] as num?)?.toInt(),
      name: json['name'] as String,
      note: json['note'] as String?,
      noteAttributes: (json['note_attributes'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      number: (json['number'] as num).toInt(),
      orderNumber: (json['order_number'] as num).toInt(),
      originalTotalAdditionalFeesSet:
          json['original_total_additional_fees_set'] as String?,
      originalTotalDutiesSet:
          json['original_total_duties_set'] as Map<String, dynamic>?,
      paymentTerms: json['payment_terms'] as Map<String, dynamic>?,
      paymentGatewayNames: (json['payment_gateway_names'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      phone: json['phone'] as String?,
      poNumber: json['po_number'] as String?,
      presentmentCurrency: json['presentment_currency'] as String,
      processedAt: json['processed_at'] as String,
      referringSite: json['referring_site'] as String?,
      refunds: (json['refunds'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      shippingAddress: CustomerAddressShopify.fromJson(
          json['shipping_address'] as Map<String, dynamic>),
      shippingLines: (json['shipping_lines'] as List<dynamic>)
          .map((e) => ShippingLineShopify.fromJson(e as Map<String, dynamic>))
          .toList(),
      sourceName: json['source_name'] as String,
      sourceIdentifier: json['source_identifier'] as String?,
      sourceUrl: json['source_url'] as String?,
      subtotalPrice: json['subtotal_price'] as String,
      subtotalPriceSet: json['subtotal_price_set'] as Map<String, dynamic>,
      tags: json['tags'] as String,
      taxLines: (json['tax_lines'] as List<dynamic>)
          .map((e) => OrderShopifyTaxLine.fromJson(e as Map<String, dynamic>))
          .toList(),
      taxesIncluded: json['taxes_included'] as bool,
      test: json['test'] as bool,
      token: json['token'] as String,
      totalDiscounts: json['total_discounts'] as String,
      totalDiscountsSet: json['total_discounts_set'] as Map<String, dynamic>,
      totalLineItemsPrice: json['total_line_items_price'] as String,
      totalLineItemsPriceSet:
          json['total_line_items_price_set'] as Map<String, dynamic>,
      totalOutstanding: json['total_outstanding'] as String,
      totalPrice: json['total_price'] as String,
      totalPriceSet: json['total_price_set'] as Map<String, dynamic>,
      totalShippingPriceSet: OrderShopifyPriceSet.fromJson(
          json['total_shipping_price_set'] as Map<String, dynamic>),
      totalTax: json['total_tax'] as String,
      totalTaxSet: json['total_tax_set'] as Map<String, dynamic>,
      totalTipReceived: json['total_tip_received'] as String,
      totalWeight: (json['total_weight'] as num).toInt(),
      updatedAt: json['updated_at'] as String,
      userId: (json['user_id'] as num?)?.toInt(),
      orderStatusUrl: json['order_status_url'] as String?,
    );

Map<String, dynamic> _$OrderShopifyToJson(OrderShopify instance) =>
    <String, dynamic>{
      'app_id': instance.appId,
      'billing_address': instance.billingAddress.toJson(),
      'browser_ip': instance.browserIp,
      'buyer_accepts_marketing': instance.buyerAcceptsMarketing,
      'cancel_reason': instance.cancelReason,
      'cancelled_at': instance.cancelledAt,
      'cart_token': instance.cartToken,
      'checkout_token': instance.checkoutToken,
      'client_details': instance.clientDetails,
      'closed_at': instance.closedAt,
      'company': instance.company,
      'confirmation_number': instance.confirmationNumber,
      'created_at': instance.createdAt,
      'currency': instance.currency,
      'current_total_additional_fees_set':
          instance.currentTotalAdditionalFeesSet,
      'current_total_discounts': instance.currentTotalDiscounts,
      'current_total_discounts_set': instance.currentTotalDiscountsSet,
      'current_total_duties_set': instance.currentTotalDutiesSet,
      'current_total_price': instance.currentTotalPrice,
      'current_total_price_set': instance.currentTotalPriceSet,
      'current_subtotal_price': instance.currentSubtotalPrice,
      'current_subtotal_price_set': instance.currentSubtotalPriceSet,
      'current_total_tax': instance.currentTotalTax,
      'current_total_tax_set': instance.currentTotalTaxSet,
      'customer': instance.customer.toJson(),
      'customer_locale': instance.customerLocale,
      'discount_applications': instance.discountApplications,
      'discount_codes': instance.discountCodes,
      'email': instance.email,
      'estimated_taxes': instance.estimatedTaxes,
      'financial_status':
          OrderShopify._financialStatusToJson(instance.financialStatus),
      'fulfillments': instance.fulfillments,
      'fulfillment_status':
          OrderShopify._fulfillmentStatusToJson(instance.fulfillmentStatus),
      'id': instance.id,
      'landing_site': instance.landingSite,
      'line_items': instance.lineItems.map((e) => e.toJson()).toList(),
      'location_id': instance.locationId,
      'merchant_of_record_app_id': instance.merchantOfRecordAppId,
      'name': instance.name,
      'note': instance.note,
      'note_attributes': instance.noteAttributes,
      'number': instance.number,
      'order_number': instance.orderNumber,
      'original_total_additional_fees_set':
          instance.originalTotalAdditionalFeesSet,
      'original_total_duties_set': instance.originalTotalDutiesSet,
      'payment_terms': instance.paymentTerms,
      'payment_gateway_names': instance.paymentGatewayNames,
      'phone': instance.phone,
      'po_number': instance.poNumber,
      'presentment_currency': instance.presentmentCurrency,
      'processed_at': instance.processedAt,
      'referring_site': instance.referringSite,
      'refunds': instance.refunds,
      'shipping_address': instance.shippingAddress.toJson(),
      'shipping_lines': instance.shippingLines.map((e) => e.toJson()).toList(),
      'source_name': instance.sourceName,
      'source_identifier': instance.sourceIdentifier,
      'source_url': instance.sourceUrl,
      'subtotal_price': instance.subtotalPrice,
      'subtotal_price_set': instance.subtotalPriceSet,
      'tags': instance.tags,
      'tax_lines': instance.taxLines.map((e) => e.toJson()).toList(),
      'taxes_included': instance.taxesIncluded,
      'test': instance.test,
      'token': instance.token,
      'total_discounts': instance.totalDiscounts,
      'total_discounts_set': instance.totalDiscountsSet,
      'total_line_items_price': instance.totalLineItemsPrice,
      'total_line_items_price_set': instance.totalLineItemsPriceSet,
      'total_outstanding': instance.totalOutstanding,
      'total_price': instance.totalPrice,
      'total_price_set': instance.totalPriceSet,
      'total_shipping_price_set': instance.totalShippingPriceSet.toJson(),
      'total_tax': instance.totalTax,
      'total_tax_set': instance.totalTaxSet,
      'total_tip_received': instance.totalTipReceived,
      'total_weight': instance.totalWeight,
      'updated_at': instance.updatedAt,
      'user_id': instance.userId,
      'order_status_url': instance.orderStatusUrl,
    };
