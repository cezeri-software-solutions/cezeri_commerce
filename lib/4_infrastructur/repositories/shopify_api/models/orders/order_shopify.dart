import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'orders.dart';

part 'order_shopify.g.dart';

enum OrderShopifyFinancialStatus { pending, authorized, partiallyPaid, paid, partiallyRefunded, refunded, voided }

enum OrderShopifyFulfillmentStatus { fulfilled, unfulfilled, partial, restocked }

extension OrderFulfillmentStatusExtension on OrderShopifyFulfillmentStatus {
  dynamic toPrettyString() {
    switch (this) {
      case OrderShopifyFulfillmentStatus.fulfilled:
        return 'fulfilled';
      case OrderShopifyFulfillmentStatus.unfulfilled:
        return null;
      case OrderShopifyFulfillmentStatus.partial:
        return 'partial';
      case OrderShopifyFulfillmentStatus.restocked:
        return 'restocked';
    }
  }
}

@JsonSerializable(explicitToJson: true)
class OrderShopify extends Equatable {
  @JsonKey(name: 'app_id')
  final int? appId;
  @JsonKey(name: 'billing_address')
  final CustomerAddressShopify billingAddress;
  @JsonKey(name: 'browser_ip')
  final String? browserIp;
  @JsonKey(name: 'buyer_accepts_marketing')
  final bool buyerAcceptsMarketing;
  @JsonKey(name: 'cancel_reason')
  final String? cancelReason;
  @JsonKey(name: 'cancelled_at')
  final String? cancelledAt;
  @JsonKey(name: 'cart_token')
  final String? cartToken;
  @JsonKey(name: 'checkout_token')
  final String? checkoutToken;
  @JsonKey(name: 'client_details')
  final Map<String, dynamic>? clientDetails;
  @JsonKey(name: 'closed_at')
  final String? closedAt;
  @JsonKey(name: 'company')
  final Map<String, dynamic>? company;
  @JsonKey(name: 'confirmation_number')
  final String confirmationNumber;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'currency')
  final String currency;
  @JsonKey(name: 'current_total_additional_fees_set')
  final String? currentTotalAdditionalFeesSet;
  @JsonKey(name: 'current_total_discounts')
  final String currentTotalDiscounts;
  @JsonKey(name: 'current_total_discounts_set')
  final Map<String, dynamic> currentTotalDiscountsSet;
  @JsonKey(name: 'current_total_duties_set')
  final Map<String, dynamic>? currentTotalDutiesSet;
  @JsonKey(name: 'current_total_price')
  final String currentTotalPrice;
  @JsonKey(name: 'current_total_price_set')
  final Map<String, dynamic> currentTotalPriceSet;
  @JsonKey(name: 'current_subtotal_price')
  final String currentSubtotalPrice;
  @JsonKey(name: 'current_subtotal_price_set')
  final Map<String, dynamic> currentSubtotalPriceSet;
  @JsonKey(name: 'current_total_tax')
  final String currentTotalTax;
  @JsonKey(name: 'current_total_tax_set')
  final Map<String, dynamic> currentTotalTaxSet;
  @JsonKey(name: 'customer')
  final OrderCustomerShopify customer;
  @JsonKey(name: 'customer_locale')
  final String? customerLocale;
  @JsonKey(name: 'discount_applications')
  final List<Map<String, dynamic>> discountApplications;
  @JsonKey(name: 'discount_codes')
  final List<Map<String, dynamic>> discountCodes;
  @JsonKey(name: 'email')
  final String? email;
  @JsonKey(name: 'estimated_taxes')
  final bool estimatedTaxes;
  @JsonKey(name: 'financial_status', fromJson: _financialStatusFromJson, toJson: _financialStatusToJson)
  final OrderShopifyFinancialStatus financialStatus;
  @JsonKey(name: 'fulfillments')
  final List<Map<String, dynamic>> fulfillments;
  @JsonKey(name: 'fulfillment_status', fromJson: _fulfillmentStatusFromJson, toJson: _fulfillmentStatusToJson)
  final OrderShopifyFulfillmentStatus? fulfillmentStatus;
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'landing_site')
  final String? landingSite;
  @JsonKey(name: 'line_items')
  final List<LineItemShopify> lineItems;
  @JsonKey(name: 'location_id')
  final int? locationId;
  @JsonKey(name: 'merchant_of_record_app_id')
  final int? merchantOfRecordAppId;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'note')
  final String? note;
  @JsonKey(name: 'note_attributes')
  final List<Map<String, dynamic>> noteAttributes;
  @JsonKey(name: 'number')
  final int number;
  @JsonKey(name: 'order_number')
  final int orderNumber;
  @JsonKey(name: 'original_total_additional_fees_set')
  final String? originalTotalAdditionalFeesSet;
  @JsonKey(name: 'original_total_duties_set')
  final Map<String, dynamic>? originalTotalDutiesSet;
  @JsonKey(name: 'payment_terms')
  final Map<String, dynamic>? paymentTerms;
  @JsonKey(name: 'payment_gateway_names')
  final List<String> paymentGatewayNames;
  @JsonKey(name: 'phone')
  final String? phone;
  @JsonKey(name: 'po_number')
  final String? poNumber;
  @JsonKey(name: 'presentment_currency')
  final String presentmentCurrency;
  @JsonKey(name: 'processed_at')
  final String processedAt;
  @JsonKey(name: 'referring_site')
  final String? referringSite;
  @JsonKey(name: 'refunds')
  final List<Map<String, dynamic>> refunds;
  @JsonKey(name: 'shipping_address')
  final CustomerAddressShopify shippingAddress;
  @JsonKey(name: 'shipping_lines')
  final List<ShippingLineShopify> shippingLines;
  @JsonKey(name: 'source_name')
  final String sourceName;
  @JsonKey(name: 'source_identifier')
  final String? sourceIdentifier;
  @JsonKey(name: 'source_url')
  final String? sourceUrl;
  @JsonKey(name: 'subtotal_price')
  final String subtotalPrice;
  @JsonKey(name: 'subtotal_price_set')
  final Map<String, dynamic> subtotalPriceSet;
  @JsonKey(name: 'tags')
  final String tags;
  @JsonKey(name: 'tax_lines')
  final List<OrderShopifyTaxLine> taxLines;
  @JsonKey(name: 'taxes_included')
  final bool taxesIncluded;
  @JsonKey(name: 'test')
  final bool test;
  @JsonKey(name: 'token')
  final String token;
  @JsonKey(name: 'total_discounts')
  final String totalDiscounts;
  @JsonKey(name: 'total_discounts_set')
  final Map<String, dynamic> totalDiscountsSet;
  @JsonKey(name: 'total_line_items_price')
  final String totalLineItemsPrice;
  @JsonKey(name: 'total_line_items_price_set')
  final Map<String, dynamic> totalLineItemsPriceSet;
  @JsonKey(name: 'total_outstanding')
  final String totalOutstanding;
  @JsonKey(name: 'total_price')
  final String totalPrice;
  @JsonKey(name: 'total_price_set')
  final Map<String, dynamic> totalPriceSet;
  @JsonKey(name: 'total_shipping_price_set')
  final OrderShopifyPriceSet totalShippingPriceSet;
  @JsonKey(name: 'total_tax')
  final String totalTax;
  @JsonKey(name: 'total_tax_set')
  final Map<String, dynamic> totalTaxSet;
  @JsonKey(name: 'total_tip_received')
  final String totalTipReceived;
  @JsonKey(name: 'total_weight')
  final int totalWeight;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'user_id')
  final int? userId;
  @JsonKey(name: 'order_status_url')
  final String? orderStatusUrl;

  const OrderShopify({
    this.appId,
    required this.billingAddress,
    this.browserIp,
    required this.buyerAcceptsMarketing,
    this.cancelReason,
    this.cancelledAt,
    this.cartToken,
    this.checkoutToken,
    this.clientDetails,
    this.closedAt,
    this.company,
    required this.confirmationNumber,
    required this.createdAt,
    required this.currency,
    this.currentTotalAdditionalFeesSet,
    required this.currentTotalDiscounts,
    required this.currentTotalDiscountsSet,
    this.currentTotalDutiesSet,
    required this.currentTotalPrice,
    required this.currentTotalPriceSet,
    required this.currentSubtotalPrice,
    required this.currentSubtotalPriceSet,
    required this.currentTotalTax,
    required this.currentTotalTaxSet,
    required this.customer,
    this.customerLocale,
    required this.discountApplications,
    required this.discountCodes,
    this.email,
    required this.estimatedTaxes,
    required this.financialStatus,
    required this.fulfillments,
    this.fulfillmentStatus,
    required this.id,
    this.landingSite,
    required this.lineItems,
    this.locationId,
    this.merchantOfRecordAppId,
    required this.name,
    this.note,
    required this.noteAttributes,
    required this.number,
    required this.orderNumber,
    this.originalTotalAdditionalFeesSet,
    this.originalTotalDutiesSet,
    this.paymentTerms,
    required this.paymentGatewayNames,
    this.phone,
    this.poNumber,
    required this.presentmentCurrency,
    required this.processedAt,
    this.referringSite,
    required this.refunds,
    required this.shippingAddress,
    required this.shippingLines,
    required this.sourceName,
    this.sourceIdentifier,
    this.sourceUrl,
    required this.subtotalPrice,
    required this.subtotalPriceSet,
    required this.tags,
    required this.taxLines,
    required this.taxesIncluded,
    required this.test,
    required this.token,
    required this.totalDiscounts,
    required this.totalDiscountsSet,
    required this.totalLineItemsPrice,
    required this.totalLineItemsPriceSet,
    required this.totalOutstanding,
    required this.totalPrice,
    required this.totalPriceSet,
    required this.totalShippingPriceSet,
    required this.totalTax,
    required this.totalTaxSet,
    required this.totalTipReceived,
    required this.totalWeight,
    required this.updatedAt,
    this.userId,
    this.orderStatusUrl,
  });

  factory OrderShopify.fromJson(Map<String, dynamic> json) => _$OrderShopifyFromJson(json);
  Map<String, dynamic> toJson() => _$OrderShopifyToJson(this);
  
  static OrderShopifyFinancialStatus _financialStatusFromJson(String value) {
    switch (value) {
      case 'pending':
        return OrderShopifyFinancialStatus.pending;
      case 'authorized':
        return OrderShopifyFinancialStatus.authorized;
      case 'partially_paid':
        return OrderShopifyFinancialStatus.partiallyPaid;
      case 'paid':
        return OrderShopifyFinancialStatus.paid;
      case 'partially_refunded':
        return OrderShopifyFinancialStatus.partiallyRefunded;
      case 'refunded':
        return OrderShopifyFinancialStatus.refunded;
      case 'voided':
        return OrderShopifyFinancialStatus.voided;
      default:
        throw ArgumentError('Unknown financial status: $value');
    }
  }

  static String _financialStatusToJson(OrderShopifyFinancialStatus status) => status.toString().split('.').last;

  static OrderShopifyFulfillmentStatus? _fulfillmentStatusFromJson(String? value) {
    switch (value) {
      case 'fulfilled':
        return OrderShopifyFulfillmentStatus.fulfilled;
      case 'partial':
        return OrderShopifyFulfillmentStatus.partial;
      case 'restocked':
        return OrderShopifyFulfillmentStatus.restocked;
      case null:
        return OrderShopifyFulfillmentStatus.unfulfilled;
      default:
        throw ArgumentError('Unknown fulfillment status: $value');
    }
  }

  static String? _fulfillmentStatusToJson(OrderShopifyFulfillmentStatus? status) {
    if (status == null) {
      return null;
    }
    switch (status) {
      case OrderShopifyFulfillmentStatus.fulfilled:
        return 'fulfilled';
      case OrderShopifyFulfillmentStatus.unfulfilled:
        return null; // Oder "unfulfilled", wenn die API einen String erwartet
      case OrderShopifyFulfillmentStatus.partial:
        return 'partial';
      case OrderShopifyFulfillmentStatus.restocked:
        return 'restocked';
    }
  }

  @override
  List<Object?> get props => [
        appId,
        billingAddress,
        browserIp,
        buyerAcceptsMarketing,
        cancelReason,
        cancelledAt,
        cartToken,
        checkoutToken,
        clientDetails,
        closedAt,
        company,
        confirmationNumber,
        createdAt,
        currency,
        currentTotalAdditionalFeesSet,
        currentTotalDiscounts,
        currentTotalDiscountsSet,
        currentTotalDutiesSet,
        currentTotalPrice,
        currentTotalPriceSet,
        currentSubtotalPrice,
        currentSubtotalPriceSet,
        currentTotalTax,
        currentTotalTaxSet,
        customer,
        customerLocale,
        discountApplications,
        discountCodes,
        email,
        estimatedTaxes,
        financialStatus,
        fulfillments,
        fulfillmentStatus,
        id,
        landingSite,
        lineItems,
        locationId,
        merchantOfRecordAppId,
        name,
        note,
        noteAttributes,
        number,
        orderNumber,
        originalTotalAdditionalFeesSet,
        originalTotalDutiesSet,
        paymentTerms,
        paymentGatewayNames,
        phone,
        poNumber,
        presentmentCurrency,
        processedAt,
        referringSite,
        refunds,
        shippingAddress,
        shippingLines,
        sourceName,
        sourceIdentifier,
        sourceUrl,
        subtotalPrice,
        subtotalPriceSet,
        tags,
        taxLines,
        taxesIncluded,
        test,
        token,
        totalDiscounts,
        totalDiscountsSet,
        totalLineItemsPrice,
        totalLineItemsPriceSet,
        totalOutstanding,
        totalPrice,
        totalPriceSet,
        totalShippingPriceSet,
        totalTax,
        totalTaxSet,
        totalTipReceived,
        totalWeight,
        updatedAt,
        userId,
        orderStatusUrl,
      ];

  @override
  bool get stringify => true;
}
