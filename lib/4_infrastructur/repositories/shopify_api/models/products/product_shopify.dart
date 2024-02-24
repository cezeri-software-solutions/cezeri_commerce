import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../metafield_shopify.dart';
import 'collect_shopify.dart';
import 'custom_collection_shopify.dart';
import 'product_image_shopify.dart';
import 'product_raw_shopify.dart';
import 'product_variant_shopify.dart';

part 'product_shopify.g.dart';

@JsonSerializable()
class ProductShopify extends Equatable {
  final int id;
  final String title;
  final String bodyHtml;
  final String handle; // friendly url
  final List<ProductImageShopify> images;
  final List<ProductOptionShopify> options;
  final List<ProductVariantShopify> variants;
  final List<MetafieldShopify> metafields;
  final List<CollectShopify> collects;
  final List<CustomCollectionShopify> customCollections;
  final String vendor;
  final String productType;
  final DateTime? publishedAt;
  final String publishedScope;
  final String status;
  final String tags;
  final String? templateSuffix;
  final DateTime updatedAt;
  final DateTime createdAt;

  const ProductShopify({
    required this.id,
    required this.title,
    required this.bodyHtml,
    required this.handle,
    required this.images,
    required this.options,
    required this.variants,
    required this.metafields,
    required this.collects,
    required this.customCollections,
    required this.vendor,
    required this.productType,
    this.publishedAt,
    required this.publishedScope,
    required this.status,
    required this.tags,
    this.templateSuffix,
    required this.updatedAt,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        bodyHtml,
        handle,
        images,
        options,
        variants,
        metafields,
        collects,
        customCollections,
        vendor,
        productType,
        publishedAt,
        publishedScope,
        status,
        tags,
        templateSuffix,
        updatedAt,
        createdAt,
      ];

  @override
  bool get stringify => true;
}
