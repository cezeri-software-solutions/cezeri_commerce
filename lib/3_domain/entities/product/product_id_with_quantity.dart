// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_id_with_quantity.g.dart';

@JsonSerializable()
class ProductIdWithQuantity extends Equatable {
  final String productId;
  final int quantity;

  const ProductIdWithQuantity({required this.productId, required this.quantity});

  factory ProductIdWithQuantity.empty() {
    return const ProductIdWithQuantity(productId: '', quantity: 0);
  }

  factory ProductIdWithQuantity.fromJson(Map<String, dynamic> json) => _$ProductIdWithQuantityFromJson(json);
  Map<String, dynamic> toJson() => _$ProductIdWithQuantityToJson(this);

  ProductIdWithQuantity copyWith({
    String? productId,
    int? quantity,
  }) {
    return ProductIdWithQuantity(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [productId, quantity];

  @override
  bool get stringify => true;
}
