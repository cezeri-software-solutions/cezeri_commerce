// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'line_item_shopify.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LineItemShopify _$LineItemShopifyFromJson(Map<String, dynamic> json) =>
    LineItemShopify(
      attributedStaffs: (json['attributed_staffs'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      id: (json['id'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      fulfillableQuantity: (json['fulfillable_quantity'] as num).toInt(),
      fulfillmentService: json['fulfillment_service'] as String,
      fulfillmentStatus: json['fulfillment_status'] as String?,
      grams: (json['grams'] as num).toInt(),
      price: json['price'] as String,
      priceSet: OrderShopifyPriceSet.fromJson(
          json['price_set'] as Map<String, dynamic>),
      productId: (json['product_id'] as num?)?.toInt(),
      currentQuantity: (json['current_quantity'] as num).toInt(),
      requiresShipping: json['requires_shipping'] as bool,
      sku: json['sku'] as String,
      title: json['title'] as String,
      variantId: (json['variant_id'] as num?)?.toInt(),
      variantTitle: json['variant_title'] as String?,
      vendor: json['vendor'] as String,
      name: json['name'] as String,
      giftCard: json['gift_card'] as bool,
      properties: (json['properties'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      taxable: json['taxable'] as bool,
      taxLines: (json['tax_lines'] as List<dynamic>)
          .map((e) => OrderShopifyTaxLine.fromJson(e as Map<String, dynamic>))
          .toList(),
      tipPaymentGateway: json['tip_payment_gateway'] as String?,
      tipPaymentMethod: json['tip_payment_method'] as String?,
      totalDiscount: json['total_discount'] as String,
      totalDiscountSet: OrderShopifyPriceSet.fromJson(
          json['total_discount_set'] as Map<String, dynamic>),
      discountAllocations: (json['discount_allocations'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      originLocation: json['origin_location'] as Map<String, dynamic>?,
      duties: (json['duties'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$LineItemShopifyToJson(LineItemShopify instance) =>
    <String, dynamic>{
      'attributed_staffs': instance.attributedStaffs,
      'id': instance.id,
      'quantity': instance.quantity,
      'fulfillable_quantity': instance.fulfillableQuantity,
      'fulfillment_service': instance.fulfillmentService,
      'fulfillment_status': instance.fulfillmentStatus,
      'grams': instance.grams,
      'price': instance.price,
      'price_set': instance.priceSet.toJson(),
      'product_id': instance.productId,
      'current_quantity': instance.currentQuantity,
      'requires_shipping': instance.requiresShipping,
      'sku': instance.sku,
      'title': instance.title,
      'variant_id': instance.variantId,
      'variant_title': instance.variantTitle,
      'vendor': instance.vendor,
      'name': instance.name,
      'gift_card': instance.giftCard,
      'properties': instance.properties,
      'taxable': instance.taxable,
      'tax_lines': instance.taxLines.map((e) => e.toJson()).toList(),
      'tip_payment_gateway': instance.tipPaymentGateway,
      'tip_payment_method': instance.tipPaymentMethod,
      'total_discount': instance.totalDiscount,
      'total_discount_set': instance.totalDiscountSet.toJson(),
      'discount_allocations': instance.discountAllocations,
      'origin_location': instance.originLocation,
      'duties': instance.duties,
    };
