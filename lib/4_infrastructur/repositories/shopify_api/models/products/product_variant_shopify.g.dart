// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_variant_shopify.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductVariantShopify _$ProductVariantShopifyFromJson(
        Map<String, dynamic> json) =>
    ProductVariantShopify(
      barcode: json['barcode'] as String?,
      compareAtPrice: json['compare_at_price'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      fulfillmentService: json['fulfillment_service'] as String,
      grams: (json['grams'] as num).toInt(),
      id: (json['id'] as num).toInt(),
      imageId: (json['image_id'] as num?)?.toInt(),
      inventoryItemId: (json['inventory_item_id'] as num).toInt(),
      inventoryManagement: json['inventory_management'] as String,
      inventoryPolicy: json['inventory_policy'] as String,
      inventoryQuantity: (json['inventory_quantity'] as num).toInt(),
      price: json['price'] as String,
      productId: (json['product_id'] as num).toInt(),
      sku: json['sku'] as String,
      taxable: json['taxable'] as bool,
      taxCode: json['tax_code'] as String?,
      title: json['title'] as String,
      updatedAt: DateTime.parse(json['updated_at'] as String),
      weight: (json['weight'] as num).toDouble(),
      weightUnit: json['weight_unit'] as String,
    );

Map<String, dynamic> _$ProductVariantShopifyToJson(
        ProductVariantShopify instance) =>
    <String, dynamic>{
      'barcode': instance.barcode,
      'compare_at_price': instance.compareAtPrice,
      'created_at': instance.createdAt.toIso8601String(),
      'fulfillment_service': instance.fulfillmentService,
      'grams': instance.grams,
      'id': instance.id,
      'image_id': instance.imageId,
      'inventory_item_id': instance.inventoryItemId,
      'inventory_management': instance.inventoryManagement,
      'inventory_policy': instance.inventoryPolicy,
      'inventory_quantity': instance.inventoryQuantity,
      'price': instance.price,
      'product_id': instance.productId,
      'sku': instance.sku,
      'taxable': instance.taxable,
      'tax_code': instance.taxCode,
      'title': instance.title,
      'updated_at': instance.updatedAt.toIso8601String(),
      'weight': instance.weight,
      'weight_unit': instance.weightUnit,
    };
