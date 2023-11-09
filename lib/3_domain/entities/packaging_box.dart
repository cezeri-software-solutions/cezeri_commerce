import 'package:json_annotation/json_annotation.dart';

import 'dimensions.dart';

part 'packaging_box.g.dart';

@JsonSerializable(explicitToJson: true)
class PackagingBox {
  final String id;
  final String name;
  final String shortName;
  final String? imageUrl;
  final Dimensions dimensionsInside;
  final Dimensions dimensionsOutside;
  final double weight;

  const PackagingBox({
    required this.id,
    required this.name,
    required this.shortName,
    required this.imageUrl,
    required this.dimensionsInside,
    required this.dimensionsOutside,
    required this.weight,
  });

  factory PackagingBox.empty() {
    return PackagingBox(
      id: '',
      name: '',
      shortName: '',
      imageUrl: null,
      dimensionsInside: Dimensions.empty(),
      dimensionsOutside: Dimensions.empty(),
      weight: 0.0,
    );
  }

  factory PackagingBox.fromJson(Map<String, dynamic> json) => _$PackagingBoxFromJson(json);

  Map<String, dynamic> toJson() => _$PackagingBoxToJson(this);

  PackagingBox copyWith({
    String? id,
    String? name,
    String? shortName,
    String? imageUrl,
    Dimensions? dimensionsInside,
    Dimensions? dimensionsOutside,
    double? weight,
  }) {
    return PackagingBox(
      id: id ?? this.id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      imageUrl: imageUrl ?? this.imageUrl,
      dimensionsInside: dimensionsInside ?? this.dimensionsInside,
      dimensionsOutside: dimensionsOutside ?? this.dimensionsOutside,
      weight: weight ?? this.weight,
    );
  }

  @override
  String toString() {
    return 'PackagingBox(id: $id, name: $name, shortName: $shortName, imageUrl: $imageUrl, dimensionsInside: $dimensionsInside, dimensionsOutside: $dimensionsOutside, weight: $weight)';
  }
}
