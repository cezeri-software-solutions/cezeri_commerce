import 'package:cezeri_commerce/4_infrastructur/repositories/shopify_api/shopify.dart';
import 'package:json_annotation/json_annotation.dart';

import '/3_domain/entities/marketplace/abstract_marketplace.dart';
import '/3_domain/entities/product/marketplace_product.dart';

part 'product_shopify.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductShopify extends MarketplaceProduct {
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
  @JsonKey(name: 'status', fromJson: _statusFromJson, toJson: statusToJson)
  final ProductShopifyStatus status;
  final String tags;
  final String? templateSuffix;
  final DateTime? updatedAt;
  final DateTime? createdAt;

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
  }) : super(MarketplaceType.shopify);

  factory ProductShopify.fromJson(Map<String, dynamic> json) => _$ProductShopifyFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ProductShopifyToJson(this);
  static ProductShopifyStatus _statusFromJson(String value) {
    switch (value) {
      case 'active':
        return ProductShopifyStatus.active;
      case 'archived':
        return ProductShopifyStatus.archived;
      case 'draft':
        return ProductShopifyStatus.draft;
      default:
        throw ArgumentError('Unknown product status: $value');
    }
  }

  static String statusToJson(ProductShopifyStatus status) => status.toString().split('.').last;

  factory ProductShopify.empty() {
    return ProductShopify(
      id: 0,
      title: '',
      bodyHtml: '',
      handle: '',
      images: const [],
      options: const [],
      variants: const [],
      metafields: const [],
      collects: const [],
      customCollections: const [],
      vendor: '',
      productType: '',
      publishedScope: '',
      status: ProductShopifyStatus.active,
      tags: '',
      updatedAt: DateTime.now(),
      createdAt: DateTime.now(),
    );
  }

  factory ProductShopify.fromRaw({
    required ProductRawShopify productRaw,
    required List<CustomCollectionShopify> customCollections,
    required List<MetafieldShopify> metafields,
    List<CollectShopify> collects = const [],
  }) {
    return ProductShopify(
      id: productRaw.id,
      title: productRaw.title,
      bodyHtml: productRaw.bodyHtml ?? '',
      handle: productRaw.handle ?? '',
      images: productRaw.images,
      options: productRaw.options,
      variants: productRaw.variants,
      metafields: metafields,
      collects: collects,
      customCollections: customCollections,
      vendor: productRaw.vendor,
      productType: productRaw.productType,
      publishedAt: productRaw.publishedAt,
      publishedScope: productRaw.publishedScope,
      status: productRaw.status,
      tags: productRaw.tags,
      templateSuffix: productRaw.templateSuffix,
      updatedAt: productRaw.updatedAt,
      createdAt: productRaw.createdAt,
    );
  }

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

  ProductShopify copyWith({
    int? id,
    String? title,
    String? bodyHtml,
    String? handle,
    List<ProductImageShopify>? images,
    List<ProductOptionShopify>? options,
    List<ProductVariantShopify>? variants,
    List<MetafieldShopify>? metafields,
    List<CollectShopify>? collects,
    List<CustomCollectionShopify>? customCollections,
    String? vendor,
    String? productType,
    DateTime? publishedAt,
    String? publishedScope,
    ProductShopifyStatus? status,
    String? tags,
    String? templateSuffix,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) {
    return ProductShopify(
      id: id ?? this.id,
      title: title ?? this.title,
      bodyHtml: bodyHtml ?? this.bodyHtml,
      handle: handle ?? this.handle,
      images: images ?? this.images,
      options: options ?? this.options,
      variants: variants ?? this.variants,
      metafields: metafields ?? this.metafields,
      collects: collects ?? this.collects,
      customCollections: customCollections ?? this.customCollections,
      vendor: vendor ?? this.vendor,
      productType: productType ?? this.productType,
      publishedAt: publishedAt ?? this.publishedAt,
      publishedScope: publishedScope ?? this.publishedScope,
      status: status ?? this.status,
      tags: tags ?? this.tags,
      templateSuffix: templateSuffix ?? this.templateSuffix,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
