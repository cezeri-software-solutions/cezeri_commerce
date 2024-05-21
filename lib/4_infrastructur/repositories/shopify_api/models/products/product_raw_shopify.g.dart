// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_raw_shopify.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductRawShopify _$ProductRawShopifyFromJson(Map<String, dynamic> json) =>
    ProductRawShopify(
      bodyHtml: json['body_html'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      handle: json['handle'] as String?,
      id: (json['id'] as num).toInt(),
      images: (json['images'] as List<dynamic>)
          .map((e) => ProductImageShopify.fromJson(e as Map<String, dynamic>))
          .toList(),
      options: (json['options'] as List<dynamic>)
          .map((e) => ProductOptionShopify.fromJson(e as Map<String, dynamic>))
          .toList(),
      productType: json['product_type'] as String,
      publishedAt: json['published_at'] == null
          ? null
          : DateTime.parse(json['published_at'] as String),
      publishedScope: json['published_scope'] as String,
      status: ProductRawShopify._statusFromJson(json['status'] as String),
      tags: json['tags'] as String,
      templateSuffix: json['template_suffix'] as String?,
      title: json['title'] as String,
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      variants: (json['variants'] as List<dynamic>)
          .map((e) => ProductVariantShopify.fromJson(e as Map<String, dynamic>))
          .toList(),
      vendor: json['vendor'] as String,
    );

Map<String, dynamic> _$ProductRawShopifyToJson(ProductRawShopify instance) =>
    <String, dynamic>{
      'body_html': instance.bodyHtml,
      'created_at': instance.createdAt?.toIso8601String(),
      'handle': instance.handle,
      'id': instance.id,
      'images': instance.images.map((e) => e.toJson()).toList(),
      'options': instance.options.map((e) => e.toJson()).toList(),
      'product_type': instance.productType,
      'published_at': instance.publishedAt?.toIso8601String(),
      'published_scope': instance.publishedScope,
      'status': ProductRawShopify._statusToJson(instance.status),
      'tags': instance.tags,
      'template_suffix': instance.templateSuffix,
      'title': instance.title,
      'updated_at': instance.updatedAt?.toIso8601String(),
      'variants': instance.variants.map((e) => e.toJson()).toList(),
      'vendor': instance.vendor,
    };

ProductOptionShopify _$ProductOptionShopifyFromJson(
        Map<String, dynamic> json) =>
    ProductOptionShopify(
      id: (json['id'] as num).toInt(),
      productId: (json['product_id'] as num).toInt(),
      name: json['name'] as String,
      position: (json['position'] as num).toInt(),
      values:
          (json['values'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ProductOptionShopifyToJson(
        ProductOptionShopify instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'name': instance.name,
      'position': instance.position,
      'values': instance.values,
    };
