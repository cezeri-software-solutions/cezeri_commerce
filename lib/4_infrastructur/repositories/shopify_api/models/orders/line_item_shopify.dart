import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'orders.dart';

part 'line_item_shopify.g.dart';

@JsonSerializable(explicitToJson: true)
class LineItemShopify extends Equatable {
  @JsonKey(name: 'attributed_staffs')
  final List<Map<String, dynamic>> attributedStaffs;
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'quantity')
  final int quantity;
  @JsonKey(name: 'fulfillable_quantity')
  final int fulfillableQuantity;
  @JsonKey(name: 'fulfillment_service')
  final String fulfillmentService;
  @JsonKey(name: 'fulfillment_status')
  final String? fulfillmentStatus;
  @JsonKey(name: 'grams')
  final int grams;
  @JsonKey(name: 'price')
  final String price;
  @JsonKey(name: 'price_set')
  final OrderShopifyPriceSet priceSet;
  @JsonKey(name: 'product_id')
  final int? productId;
  @JsonKey(name: 'current_quantity')
  final int currentQuantity;
  @JsonKey(name: 'requires_shipping')
  final bool requiresShipping;
  @JsonKey(name: 'sku')
  final String sku;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'variant_id')
  final int? variantId;
  @JsonKey(name: 'variant_title')
  final String? variantTitle;
  @JsonKey(name: 'vendor')
  final String vendor;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'gift_card')
  final bool giftCard;
  @JsonKey(name: 'properties')
  final List<Map<String, dynamic>> properties;
  @JsonKey(name: 'taxable')
  final bool taxable;
  @JsonKey(name: 'tax_lines')
  final List<OrderShopifyTaxLine> taxLines;
  @JsonKey(name: 'tip_payment_gateway')
  final String? tipPaymentGateway;
  @JsonKey(name: 'tip_payment_method')
  final String? tipPaymentMethod;
  @JsonKey(name: 'total_discount')
  final String totalDiscount;
  @JsonKey(name: 'total_discount_set')
  final OrderShopifyPriceSet totalDiscountSet;
  @JsonKey(name: 'discount_allocations')
  final List<Map<String, dynamic>> discountAllocations;
  @JsonKey(name: 'origin_location')
  final Map<String, dynamic>? originLocation;
  @JsonKey(name: 'duties')
  final List<Map<String, dynamic>> duties;

  const LineItemShopify({
    required this.attributedStaffs,
    required this.id,
    required this.quantity,
    required this.fulfillableQuantity,
    required this.fulfillmentService,
    this.fulfillmentStatus,
    required this.grams,
    required this.price,
    required this.priceSet,
    this.productId,
    required this.currentQuantity,
    required this.requiresShipping,
    required this.sku,
    required this.title,
    this.variantId,
    this.variantTitle,
    required this.vendor,
    required this.name,
    required this.giftCard,
    required this.properties,
    required this.taxable,
    required this.taxLines,
    this.tipPaymentGateway,
    this.tipPaymentMethod,
    required this.totalDiscount,
    required this.totalDiscountSet,
    required this.discountAllocations,
    this.originLocation,
    required this.duties,
  });

  factory LineItemShopify.fromJson(Map<String, dynamic> json) => _$LineItemShopifyFromJson(json);
  Map<String, dynamic> toJson() => _$LineItemShopifyToJson(this);

  @override
  List<Object?> get props => [
    attributedStaffs,
    id,
    quantity,
    fulfillableQuantity,
    fulfillmentService,
    fulfillmentStatus,
    grams,
    price,
    priceSet,
    productId,
    currentQuantity,
    requiresShipping,
    sku,
    title,
    variantId,
    variantTitle,
    vendor,
    name,
    giftCard,
    properties,
    taxable,
    taxLines,
    tipPaymentGateway,
    tipPaymentMethod,
    totalDiscount,
    totalDiscountSet,
    discountAllocations,
    originLocation,
    duties,
  ];

  @override
  bool get stringify => true;
}

