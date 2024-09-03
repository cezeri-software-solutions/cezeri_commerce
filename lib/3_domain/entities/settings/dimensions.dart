import 'package:json_annotation/json_annotation.dart';

part 'dimensions.g.dart';

@JsonSerializable()
class Dimensions {
  final double length;
  final double width;
  final double height;
  final double volume;

  const Dimensions({
    required this.length,
    required this.width,
    required this.height,
  }) : volume = length * width * height;

  factory Dimensions.empty() {
    return const Dimensions(
      length: 0.0,
      width: 0.0,
      height: 0.0,
    );
  }

  factory Dimensions.fromJson(Map<String, dynamic> json) => _$DimensionsFromJson(json);

  Map<String, dynamic> toJson() => _$DimensionsToJson(this);

  Dimensions copyWith({
    double? length,
    double? width,
    double? height,
  }) {
    return Dimensions(
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  @override
  String toString() {
    return 'Dimensions(length: $length, width: $width, height: $height, volume: $volume)';
  }
}
