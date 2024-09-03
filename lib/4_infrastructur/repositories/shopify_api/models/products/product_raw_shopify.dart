// ignore_for_file: public_member_api_docs, sort_constructors_first
//* Diese Klasse representiert exakt das Format, wie ein Artikel aus Shopify geladen wird.
//* Viele Attribute wie Bestand, Preis... usw. sind in anderen Klassen

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'product_image_shopify.dart';
import 'product_variant_shopify.dart';

part 'product_raw_shopify.g.dart';

enum ProductShopifyStatus { active, archived, draft }

extension ProductStatusExtension on ProductShopifyStatus {
  String toPrettyString() {
    switch (this) {
      case ProductShopifyStatus.active:
        return 'active';
      case ProductShopifyStatus.archived:
        return 'archived';
      case ProductShopifyStatus.draft:
        return 'draft';
      default:
        return 'Unknown';
    }
  }
}

@JsonSerializable(explicitToJson: true)
class ProductRawShopify extends Equatable {
  @JsonKey(name: 'body_html')
  final String? bodyHtml;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  final String? handle;
  final int id;
  final List<ProductImageShopify> images;
  final List<ProductOptionShopify> options;
  @JsonKey(name: 'product_type')
  final String productType;
  @JsonKey(name: 'published_at')
  final DateTime? publishedAt;
  @JsonKey(name: 'published_scope')
  final String publishedScope;
  @JsonKey(name: 'status', fromJson: _statusFromJson, toJson: _statusToJson)
  final ProductShopifyStatus status;
  final String tags;
  @JsonKey(name: 'template_suffix')
  final String? templateSuffix;
  final String title;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  final List<ProductVariantShopify> variants;
  final String vendor;

  const ProductRawShopify({
    required this.bodyHtml,
    required this.createdAt,
    required this.handle,
    required this.id,
    required this.images,
    required this.options,
    required this.productType,
    this.publishedAt,
    required this.publishedScope,
    required this.status,
    required this.tags,
    this.templateSuffix,
    required this.title,
    required this.updatedAt,
    required this.variants,
    required this.vendor,
  });

  factory ProductRawShopify.fromJson(Map<String, dynamic> json) => _$ProductRawShopifyFromJson(json);
  Map<String, dynamic> toJson() => _$ProductRawShopifyToJson(this);
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

  static String _statusToJson(ProductShopifyStatus status) => status.toString().split('.').last;

  ProductRawShopify copyWith({
    String? bodyHtml,
    DateTime? createdAt,
    String? handle,
    int? id,
    List<ProductImageShopify>? images,
    List<ProductOptionShopify>? options,
    String? productType,
    DateTime? publishedAt,
    String? publishedScope,
    ProductShopifyStatus? status,
    String? tags,
    String? templateSuffix,
    String? title,
    DateTime? updatedAt,
    List<ProductVariantShopify>? variants,
    String? vendor,
  }) {
    return ProductRawShopify(
      bodyHtml: bodyHtml ?? this.bodyHtml,
      createdAt: createdAt ?? this.createdAt,
      handle: handle ?? this.handle,
      id: id ?? this.id,
      images: images ?? this.images,
      options: options ?? this.options,
      productType: productType ?? this.productType,
      publishedAt: publishedAt ?? this.publishedAt,
      publishedScope: publishedScope ?? this.publishedScope,
      status: status ?? this.status,
      tags: tags ?? this.tags,
      templateSuffix: templateSuffix ?? this.templateSuffix,
      title: title ?? this.title,
      updatedAt: updatedAt ?? this.updatedAt,
      variants: variants ?? this.variants,
      vendor: vendor ?? this.vendor,
    );
  }

  @override
  List<Object?> get props => [
        bodyHtml,
        createdAt,
        handle,
        id,
        images,
        options,
        productType,
        publishedAt,
        publishedScope,
        status,
        tags,
        templateSuffix,
        title,
        updatedAt,
        variants,
        vendor,
      ];

  @override
  bool get stringify => true;
}

@JsonSerializable(explicitToJson: true)
class ProductOptionShopify extends Equatable {
  final int id;
  @JsonKey(name: 'product_id')
  final int productId;
  final String name;
  final int position;
  final List<String>? values;

  const ProductOptionShopify({
    required this.id,
    required this.productId,
    required this.name,
    required this.position,
    this.values,
  });

  factory ProductOptionShopify.fromJson(Map<String, dynamic> json) => _$ProductOptionShopifyFromJson(json);
  Map<String, dynamic> toJson() => _$ProductOptionShopifyToJson(this);

  @override
  List<Object?> get props => [id, productId, name, position, values];

  @override
  bool get stringify => true;
}
