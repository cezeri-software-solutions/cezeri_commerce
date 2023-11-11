import 'package:json_annotation/json_annotation.dart';

import 'dimensions.dart';

part 'packaging_box.g.dart';

@JsonSerializable(explicitToJson: true)
class PackagingBox {
  final String id;
  final int pos;
  final String name;
  final String shortName;
  final String? imageUrl;
  final int? deliveryNoteId;
  final Dimensions dimensionsInside;
  final Dimensions dimensionsOutside;
  final double weight;
  final double wholesalePrice;
  final int quantity;

  const PackagingBox({
    required this.id,
    required this.pos,
    required this.name,
    required this.shortName,
    required this.imageUrl,
    required this.deliveryNoteId,
    required this.dimensionsInside,
    required this.dimensionsOutside,
    required this.weight,
    required this.wholesalePrice,
    required this.quantity,
  });

  factory PackagingBox.empty() {
    return PackagingBox(
      id: '',
      pos: 0,
      name: '',
      shortName: '',
      imageUrl: null,
      deliveryNoteId: null,
      dimensionsInside: Dimensions.empty(),
      dimensionsOutside: Dimensions.empty(),
      weight: 0.0,
      wholesalePrice: 0.0,
      quantity: 0,
    );
  }

  factory PackagingBox.fromJson(Map<String, dynamic> json) => _$PackagingBoxFromJson(json);

  Map<String, dynamic> toJson() => _$PackagingBoxToJson(this);

  PackagingBox copyWith({
    String? id,
    int? pos,
    String? name,
    String? shortName,
    String? imageUrl,
    int? deliveryNoteId,
    Dimensions? dimensionsInside,
    Dimensions? dimensionsOutside,
    double? weight,
    double? wholesalePrice,
    int? quantity,
  }) {
    return PackagingBox(
      id: id ?? this.id,
      pos: pos ?? this.pos,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      imageUrl: imageUrl ?? this.imageUrl,
      deliveryNoteId: deliveryNoteId ?? this.deliveryNoteId,
      dimensionsInside: dimensionsInside ?? this.dimensionsInside,
      dimensionsOutside: dimensionsOutside ?? this.dimensionsOutside,
      weight: weight ?? this.weight,
      wholesalePrice: wholesalePrice ?? this.wholesalePrice,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  String toString() {
    return 'PackagingBox(id: $id, pos: $pos, name: $name, shortName: $shortName, imageUrl: $imageUrl, deliveryNoteId: $deliveryNoteId, dimensionsInside: $dimensionsInside, dimensionsOutside: $dimensionsOutside, weight: $weight, wholesalePrice: $wholesalePrice, quantity: $quantity)';
  }
}



// class Item {
//   final double length;
//   final double width;
//   final double height;

//   Item(this.length, this.width, this.height);

//   double get volume => length * width * height;
// }

// class Box {
//   final double length;
//   final double width;
//   final double height;

//   Box(this.length, this.width, this.height);

//   bool canHold(Item item) {
//     return length >= item.length && width >= item.width && height >= item.height;
//   }

//   double get volume => length * width * height;
// }

// Box? findBestBox(List<Item> items, List<Box> boxes) {
//   // Berechnen des Gesamtvolumens und der maximalen Abmessungen der Artikel
//   double totalVolume = items.fold(0, (sum, item) => sum + item.volume);
//   double maxLength = items.fold(0, (max, item) => item.length > max ? item.length : max);
//   double maxWidth = items.fold(0, (max, item) => item.width > max ? item.width : max);
//   double maxHeight = items.fold(0, (max, item) => item.height > max ? item.height : max);

//   // Finden der passenden Box
//   Box? bestBox;
//   for (var box in boxes) {
//     if (box.canHold(Item(maxLength, maxWidth, maxHeight)) && box.volume >= totalVolume) {
//       if (bestBox == null || box.volume < bestBox.volume) {
//         bestBox = box;
//       }
//     }
//   }

//   return bestBox;
// }
