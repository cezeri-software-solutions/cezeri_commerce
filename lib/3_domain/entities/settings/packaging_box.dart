import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'dimensions.dart';

part 'packaging_box.g.dart';

@JsonSerializable(explicitToJson: true)
class PackagingBox extends Equatable {
  // @JsonKey(toJson: null)
  final String id;
  final int pos;
  final String name;
  // @JsonKey(name: '')
  final String shortName;
  // @JsonKey(name: 'imageUrl')
  final String? imageUrl;
  // @JsonKey(name: 'delivery_note_id')
  final int? deliveryNoteId;
  // @JsonKey(name: 'dimensions_inside')
  final Dimensions dimensionsInside;
  // @JsonKey(name: 'dimensions_outside')
  final Dimensions dimensionsOutside;
  final double weight;
  // @JsonKey(name: 'wholesale_price')
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
  List<Object?> get props => [id];

  @override
  bool get stringify => true;
}
