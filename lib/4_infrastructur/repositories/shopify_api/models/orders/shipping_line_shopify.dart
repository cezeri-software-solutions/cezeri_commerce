import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../models.dart';

part 'shipping_line_shopify.g.dart';

@JsonSerializable()
class ShippingLineShopify extends Equatable {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'carrier_identifier')
  final String? carrierIdentifier;
  @JsonKey(name: 'code')
  final String code;
  @JsonKey(name: 'discounted_price')
  final String discountedPrice;
  @JsonKey(name: 'discounted_price_set')
  final OrderShopifyPriceSet discountedPriceSet;
  @JsonKey(name: 'phone')
  final String? phone;
  @JsonKey(name: 'price')
  final String price;
  @JsonKey(name: 'price_set')
  final OrderShopifyPriceSet priceSet;
  @JsonKey(name: 'requested_fulfillment_service_id')
  final String? requestedFulfillmentServiceId;
  @JsonKey(name: 'source')
  final String source;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'tax_lines')
  final List<OrderShopifyTaxLine> taxLines;
  @JsonKey(name: 'discount_allocations')
  final List<Map<String, dynamic>> discountAllocations;

  const ShippingLineShopify({
    required this.id,
    this.carrierIdentifier,
    required this.code,
    required this.discountedPrice,
    required this.discountedPriceSet,
    this.phone,
    required this.price,
    required this.priceSet,
    this.requestedFulfillmentServiceId,
    required this.source,
    required this.title,
    required this.taxLines,
    required this.discountAllocations,
  });

  factory ShippingLineShopify.fromJson(Map<String, dynamic> json) => _$ShippingLineShopifyFromJson(json);
  Map<String, dynamic> toJson() => _$ShippingLineShopifyToJson(this);

  @override
  List<Object?> get props => [
        id,
        carrierIdentifier,
        code,
        discountedPrice,
        discountedPriceSet,
        phone,
        price,
        priceSet,
        requestedFulfillmentServiceId,
        source,
        title,
        taxLines,
        discountAllocations,
      ];

  @override
  bool get stringify => true;
}
