import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../receipt/receipt_product.dart';

part 'picklist_product.g.dart';

@JsonSerializable()
class PicklistProduct extends Equatable {
  final String productId; // Id des Artikels in Firebase
  final int quantity;
  final int pickedQuantity;
  final String? imageUrl;
  final String name;
  final String articleNumber;
  final String ean;
  final int customization;
  final double weight;

  const PicklistProduct({
    required this.productId,
    required this.quantity,
    required this.pickedQuantity,
    required this.imageUrl,
    required this.name,
    required this.articleNumber,
    required this.ean,
    required this.customization,
    required this.weight,
  });

  factory PicklistProduct.fromJson(Map<String, dynamic> json) => _$PicklistProductFromJson(json);

  Map<String, dynamic> toJson() => _$PicklistProductToJson(this);

  factory PicklistProduct.empty() {
    return const PicklistProduct(
      productId: '',
      quantity: 0,
      pickedQuantity: 0,
      imageUrl: null,
      name: '',
      articleNumber: '',
      ean: '',
      customization: 0,
      weight: 0.0,
    );
  }

  factory PicklistProduct.fromReceiptProduct(ReceiptProduct receiptProduct) {
    return PicklistProduct(
      productId: receiptProduct.productId,
      quantity: receiptProduct.quantity - receiptProduct.shippedQuantity,
      pickedQuantity: 0,
      imageUrl: null,
      name: receiptProduct.name,
      articleNumber: receiptProduct.articleNumber,
      ean: receiptProduct.ean,
      customization: receiptProduct.customization,
      weight: receiptProduct.weight,
    );
  }

  PicklistProduct copyWith({
    String? productId,
    int? quantity,
    int? pickedQuantity,
    String? imageUrl,
    String? name,
    String? articleNumber,
    String? ean,
    int? customization,
    double? weight,
  }) {
    return PicklistProduct(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      pickedQuantity: pickedQuantity ?? this.pickedQuantity,
      imageUrl: imageUrl ?? this.imageUrl,
      name: name ?? this.name,
      articleNumber: articleNumber ?? this.articleNumber,
      ean: ean ?? this.ean,
      customization: customization ?? this.customization,
      weight: weight ?? this.weight,
    );
  }

  @override
  String toString() {
    return 'PicklistProduct(productId: $productId, quantity: $quantity, name: $name, articleNumber: $articleNumber, ean: $ean, customization: $customization, weight: $weight)';
  }

  @override
  List<Object?> get props => [productId, name, articleNumber, ean];

  @override
  bool get stringify => true;
}
