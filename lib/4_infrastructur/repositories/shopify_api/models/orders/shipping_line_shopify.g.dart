// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_line_shopify.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShippingLineShopify _$ShippingLineShopifyFromJson(Map<String, dynamic> json) =>
    ShippingLineShopify(
      id: (json['id'] as num).toInt(),
      carrierIdentifier: json['carrier_identifier'] as String?,
      code: json['code'] as String,
      discountedPrice: json['discounted_price'] as String,
      discountedPriceSet: OrderShopifyPriceSet.fromJson(
          json['discounted_price_set'] as Map<String, dynamic>),
      phone: json['phone'] as String?,
      price: json['price'] as String,
      priceSet: OrderShopifyPriceSet.fromJson(
          json['price_set'] as Map<String, dynamic>),
      requestedFulfillmentServiceId:
          json['requested_fulfillment_service_id'] as String?,
      source: json['source'] as String,
      title: json['title'] as String,
      taxLines: (json['tax_lines'] as List<dynamic>)
          .map((e) => OrderShopifyTaxLine.fromJson(e as Map<String, dynamic>))
          .toList(),
      discountAllocations: (json['discount_allocations'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$ShippingLineShopifyToJson(
        ShippingLineShopify instance) =>
    <String, dynamic>{
      'id': instance.id,
      'carrier_identifier': instance.carrierIdentifier,
      'code': instance.code,
      'discounted_price': instance.discountedPrice,
      'discounted_price_set': instance.discountedPriceSet,
      'phone': instance.phone,
      'price': instance.price,
      'price_set': instance.priceSet,
      'requested_fulfillment_service_id':
          instance.requestedFulfillmentServiceId,
      'source': instance.source,
      'title': instance.title,
      'tax_lines': instance.taxLines,
      'discount_allocations': instance.discountAllocations,
    };
