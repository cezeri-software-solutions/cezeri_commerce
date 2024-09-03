import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_image_shopify.g.dart';

@JsonSerializable()
class ProductImageShopify extends Equatable {
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  final int id;
  final int position;
  @JsonKey(name: 'product_id')
  final int productId;
  @JsonKey(name: 'variant_ids')
  final List<int> variantIds;
  final String src;
  final int width;
  final int height;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const ProductImageShopify({
    required this.createdAt,
    required this.id,
    required this.position,
    required this.productId,
    required this.variantIds,
    required this.src,
    required this.width,
    required this.height,
    required this.updatedAt,
  });

  factory ProductImageShopify.fromJson(Map<String, dynamic> json) => _$ProductImageShopifyFromJson(json);
  Map<String, dynamic> toJson() => _$ProductImageShopifyToJson(this);

  ProductImageShopify copyWith({
    DateTime? createdAt,
    int? id,
    int? position,
    int? productId,
    List<int>? variantIds,
    String? src,
    int? width,
    int? height,
    DateTime? updatedAt,
  }) {
    return ProductImageShopify(
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      position: position ?? this.position,
      productId: productId ?? this.productId,
      variantIds: variantIds ?? this.variantIds,
      src: src ?? this.src,
      width: width ?? this.width,
      height: height ?? this.height,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        createdAt,
        id,
        position,
        productId,
        variantIds,
        src,
        width,
        height,
        updatedAt,
      ];

  @override
  bool get stringify => true;
}
