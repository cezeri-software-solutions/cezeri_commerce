// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_shopify.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductShopify _$ProductShopifyFromJson(Map<String, dynamic> json) =>
    ProductShopify(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      bodyHtml: json['bodyHtml'] as String,
      handle: json['handle'] as String,
      images: (json['images'] as List<dynamic>)
          .map((e) => ProductImageShopify.fromJson(e as Map<String, dynamic>))
          .toList(),
      options: (json['options'] as List<dynamic>)
          .map((e) => ProductOptionShopify.fromJson(e as Map<String, dynamic>))
          .toList(),
      variants: (json['variants'] as List<dynamic>)
          .map((e) => ProductVariantShopify.fromJson(e as Map<String, dynamic>))
          .toList(),
      metafields: (json['metafields'] as List<dynamic>)
          .map((e) => MetafieldShopify.fromJson(e as Map<String, dynamic>))
          .toList(),
      collects: (json['collects'] as List<dynamic>)
          .map((e) => CollectShopify.fromJson(e as Map<String, dynamic>))
          .toList(),
      customCollections: (json['customCollections'] as List<dynamic>)
          .map((e) =>
              CustomCollectionShopify.fromJson(e as Map<String, dynamic>))
          .toList(),
      vendor: json['vendor'] as String,
      productType: json['productType'] as String,
      publishedAt: json['publishedAt'] == null
          ? null
          : DateTime.parse(json['publishedAt'] as String),
      publishedScope: json['publishedScope'] as String,
      status: ProductShopify._statusFromJson(json['status'] as String),
      tags: json['tags'] as String,
      templateSuffix: json['templateSuffix'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ProductShopifyToJson(ProductShopify instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'bodyHtml': instance.bodyHtml,
      'handle': instance.handle,
      'images': instance.images.map((e) => e.toJson()).toList(),
      'options': instance.options.map((e) => e.toJson()).toList(),
      'variants': instance.variants.map((e) => e.toJson()).toList(),
      'metafields': instance.metafields.map((e) => e.toJson()).toList(),
      'collects': instance.collects.map((e) => e.toJson()).toList(),
      'customCollections':
          instance.customCollections.map((e) => e.toJson()).toList(),
      'vendor': instance.vendor,
      'productType': instance.productType,
      'publishedAt': instance.publishedAt?.toIso8601String(),
      'publishedScope': instance.publishedScope,
      'status': ProductShopify.statusToJson(instance.status),
      'tags': instance.tags,
      'templateSuffix': instance.templateSuffix,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };
