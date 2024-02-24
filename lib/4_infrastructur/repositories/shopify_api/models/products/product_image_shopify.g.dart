// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_image_shopify.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductImageShopify _$ProductImageShopifyFromJson(Map<String, dynamic> json) =>
    ProductImageShopify(
      createdAt: DateTime.parse(json['created_at'] as String),
      id: json['id'] as int,
      position: json['position'] as int,
      productId: json['product_id'] as int,
      variantIds:
          (json['variant_ids'] as List<dynamic>).map((e) => e as int).toList(),
      src: json['src'] as String,
      width: json['width'] as int,
      height: json['height'] as int,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ProductImageShopifyToJson(
        ProductImageShopify instance) =>
    <String, dynamic>{
      'created_at': instance.createdAt.toIso8601String(),
      'id': instance.id,
      'position': instance.position,
      'product_id': instance.productId,
      'variant_ids': instance.variantIds,
      'src': instance.src,
      'width': instance.width,
      'height': instance.height,
      'updated_at': instance.updatedAt.toIso8601String(),
    };
