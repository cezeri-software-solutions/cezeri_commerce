import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_variant_shopify.g.dart';

@JsonSerializable()
class ProductVariantShopify extends Equatable {
  final String? barcode;
  @JsonKey(name: 'compare_at_price')
  final String? compareAtPrice;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'fulfillment_service')
  final String fulfillmentService;
  final int grams;
  final int id;
  @JsonKey(name: 'image_id')
  final int? imageId;
  @JsonKey(name: 'inventory_item_id')
  final int inventoryItemId;
  @JsonKey(name: 'inventory_management')
  final String inventoryManagement;
  @JsonKey(name: 'inventory_policy')
  final String inventoryPolicy;
  @JsonKey(name: 'inventory_quantity')
  final int inventoryQuantity;
  final String price;
  @JsonKey(name: 'product_id')
  final int productId;
  final String sku;
  final bool taxable;
  @JsonKey(name: 'tax_code')
  final String? taxCode;
  final String title;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final double weight;
  @JsonKey(name: 'weight_unit')
  final String weightUnit;

  const ProductVariantShopify({
    required this.barcode,
    this.compareAtPrice,
    required this.createdAt,
    required this.fulfillmentService,
    required this.grams,
    required this.id,
    this.imageId,
    required this.inventoryItemId,
    required this.inventoryManagement,
    required this.inventoryPolicy,
    required this.inventoryQuantity,
    required this.price,
    required this.productId,
    required this.sku,
    required this.taxable,
    this.taxCode,
    required this.title,
    required this.updatedAt,
    required this.weight,
    required this.weightUnit,
  });

  factory ProductVariantShopify.fromJson(Map<String, dynamic> json) => _$ProductVariantShopifyFromJson(json);
  Map<String, dynamic> toJson() => _$ProductVariantShopifyToJson(this);

  ProductVariantShopify copyWith({
    String? barcode,
    String? compareAtPrice,
    DateTime? createdAt,
    String? fulfillmentService,
    int? grams,
    int? id,
    int? imageId,
    int? inventoryItemId,
    String? inventoryManagement,
    String? inventoryPolicy,
    int? inventoryQuantity,
    String? price,
    int? productId,
    String? sku,
    bool? taxable,
    String? taxCode,
    String? title,
    DateTime? updatedAt,
    double? weight,
    String? weightUnit,
  }) {
    return ProductVariantShopify(
      barcode: barcode ?? this.barcode,
      compareAtPrice: compareAtPrice ?? this.compareAtPrice,
      createdAt: createdAt ?? this.createdAt,
      fulfillmentService: fulfillmentService ?? this.fulfillmentService,
      grams: grams ?? this.grams,
      id: id ?? this.id,
      imageId: imageId ?? this.imageId,
      inventoryItemId: inventoryItemId ?? this.inventoryItemId,
      inventoryManagement: inventoryManagement ?? this.inventoryManagement,
      inventoryPolicy: inventoryPolicy ?? this.inventoryPolicy,
      inventoryQuantity: inventoryQuantity ?? this.inventoryQuantity,
      price: price ?? this.price,
      productId: productId ?? this.productId,
      sku: sku ?? this.sku,
      taxable: taxable ?? this.taxable,
      taxCode: taxCode ?? this.taxCode,
      title: title ?? this.title,
      updatedAt: updatedAt ?? this.updatedAt,
      weight: weight ?? this.weight,
      weightUnit: weightUnit ?? this.weightUnit,
    );
  }

  @override
  List<Object?> get props => [
        barcode,
        compareAtPrice,
        createdAt,
        fulfillmentService,
        grams,
        id,
        imageId,
        inventoryItemId,
        inventoryManagement,
        inventoryPolicy,
        inventoryQuantity,
        price,
        productId,
        sku,
        taxable,
        taxCode,
        title,
        updatedAt,
        weight,
        weightUnit,
      ];

  @override
  bool get stringify => true;
}
