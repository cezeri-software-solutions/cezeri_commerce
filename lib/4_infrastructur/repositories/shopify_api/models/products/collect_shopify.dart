import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'collect_shopify.g.dart';

@JsonSerializable()
class CollectShopify extends Equatable {
  @JsonKey(name: 'collection_id')
  final int collectionId;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  final int id;
  final int position;
  @JsonKey(name: 'product_id')
  final int productId;
  @JsonKey(name: 'sort_value')
  final String sortValue;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const CollectShopify({
    required this.collectionId,
    required this.createdAt,
    required this.id,
    required this.position,
    required this.productId,
    required this.sortValue,
    required this.updatedAt,
  });

  factory CollectShopify.fromJson(Map<String, dynamic> json) => _$CollectShopifyFromJson(json);
  Map<String, dynamic> toJson() => _$CollectShopifyToJson(this);

  CollectShopify copyWith({
    int? collectionId,
    DateTime? createdAt,
    int? id,
    int? position,
    int? productId,
    String? sortValue,
    DateTime? updatedAt,
  }) {
    return CollectShopify(
      collectionId: collectionId ?? this.collectionId,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      position: position ?? this.position,
      productId: productId ?? this.productId,
      sortValue: sortValue ?? this.sortValue,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        collectionId,
        createdAt,
        id,
        position,
        productId,
        sortValue,
        updatedAt,
      ];

  @override
  bool get stringify => true;
}