import 'package:json_annotation/json_annotation.dart';

part 'set_product.g.dart';

@JsonSerializable()
class SetProduct {
  final String id; // ID des Produktes in Firestore
  final String articleNumber;
  final String name;
  final String imageUrl;
  final int quantity;

  SetProduct({required this.id, required this.articleNumber, required this.name, required this.imageUrl, required this.quantity});

  factory SetProduct.empty() {
    return SetProduct(id: '', articleNumber: '', name: '', imageUrl: '', quantity: 0);
  }

  factory SetProduct.fromJson(Map<String, dynamic> json) => _$SetProductFromJson(json);
  Map<String, dynamic> toJson() => _$SetProductToJson(this);

  SetProduct copyWith({
    String? id,
    String? articleNumber,
    String? name,
    String? imageUrl,
    int? quantity,
  }) {
    return SetProduct(
      id: id ?? this.id,
      articleNumber: articleNumber ?? this.articleNumber,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  String toString() {
    return 'SetProduct(id: $id, articleNumber: $articleNumber, name: $name, imageUrl: $imageUrl, quantity: $quantity)';
  }
}
