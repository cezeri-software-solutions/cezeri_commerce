import 'package:json_annotation/json_annotation.dart';

import '../id.dart';
import '../product/product.dart';
import '../reorder/reorder.dart';
import '../reorder/reorder_product.dart';

part 'booking_product.g.dart';

@JsonSerializable()
class BookingProduct {
  final String id;
  final String productId;
  final String reorderId;
  final String name;
  final String articleNumber;
  final String ean;
  final int quantity;
  final int bookedQuantity;
  final int openQuantity;
  final int warehouseStock;
  final int availableStock;
  final bool isFromDatabase;

  BookingProduct({
    required this.id,
    required this.productId,
    required this.reorderId,
    required this.name,
    required this.articleNumber,
    required this.ean,
    required this.quantity,
    required this.bookedQuantity,
    required this.warehouseStock,
    required this.availableStock,
    required this.isFromDatabase,
  }) : openQuantity = quantity - bookedQuantity;

  factory BookingProduct.fromJson(Map<String, dynamic> json) => _$BookingProductFromJson(json);
  Map<String, dynamic> toJson() => _$BookingProductToJson(this);

  factory BookingProduct.fromProduct(Product product) {
    return BookingProduct(
      id: UniqueID().value,
      productId: product.id,
      reorderId: '',
      name: product.name,
      articleNumber: product.articleNumber,
      ean: product.ean,
      quantity: 0,
      bookedQuantity: 0,
      warehouseStock: product.warehouseStock,
      availableStock: product.availableStock,
      isFromDatabase: false,
    );
  }

  factory BookingProduct.fromReorderProduct(Reorder reorder, ReorderProduct reorderProduct) {
    return BookingProduct(
      id: UniqueID().value,
      productId: reorderProduct.productId,
      reorderId: reorder.id,
      name: reorderProduct.name,
      articleNumber: reorderProduct.articleNumber,
      ean: reorderProduct.ean,
      quantity: reorderProduct.quantity,
      bookedQuantity: reorderProduct.bookedQuantity,
      warehouseStock: 0,
      availableStock: 0,
      isFromDatabase: reorderProduct.isFromDatabase,
    );
  }

  factory BookingProduct.empty() {
    return BookingProduct(
      id: UniqueID().value,
      productId: '',
      reorderId: '',
      name: '',
      articleNumber: '',
      ean: '',
      quantity: 0,
      bookedQuantity: 0,
      warehouseStock: 0,
      availableStock: 0,
      isFromDatabase: false,
    );
  }

  BookingProduct copyWith({
    String? id,
    String? productId,
    String? reorderId,
    String? name,
    String? articleNumber,
    String? ean,
    int? quantity,
    int? bookedQuantity,
    int? warehouseStock,
    int? availableStock,
    bool? isFromDatabase,
  }) {
    return BookingProduct(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      reorderId: reorderId ?? this.reorderId,
      name: name ?? this.name,
      articleNumber: articleNumber ?? this.articleNumber,
      ean: ean ?? this.ean,
      quantity: quantity ?? this.quantity,
      bookedQuantity: bookedQuantity ?? this.bookedQuantity,
      warehouseStock: warehouseStock ?? this.warehouseStock,
      availableStock: availableStock ?? this.availableStock,
      isFromDatabase: isFromDatabase ?? this.isFromDatabase,
    );
  }

  @override
  String toString() {
    return 'BookingProduct(id: $id, productId: $productId, reorderId: $reorderId, name: $name, articleNumber: $articleNumber, ean: $ean, quantity: $quantity, bookedQuantity: $bookedQuantity, openQuantity: $openQuantity, warehouseStock: $warehouseStock, availableStock: $availableStock, isFromDatabase: $isFromDatabase)';
  }
}
