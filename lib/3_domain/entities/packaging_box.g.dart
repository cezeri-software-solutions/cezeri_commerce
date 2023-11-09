// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packaging_box.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackagingBox _$PackagingBoxFromJson(Map<String, dynamic> json) => PackagingBox(
      id: json['id'] as String,
      name: json['name'] as String,
      shortName: json['shortName'] as String,
      imageUrl: json['imageUrl'] as String?,
      dimensionsInside:
          Dimensions.fromJson(json['dimensionsInside'] as Map<String, dynamic>),
      dimensionsOutside: Dimensions.fromJson(
          json['dimensionsOutside'] as Map<String, dynamic>),
      weight: (json['weight'] as num).toDouble(),
    );

Map<String, dynamic> _$PackagingBoxToJson(PackagingBox instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'shortName': instance.shortName,
      'imageUrl': instance.imageUrl,
      'dimensionsInside': instance.dimensionsInside.toJson(),
      'dimensionsOutside': instance.dimensionsOutside.toJson(),
      'weight': instance.weight,
    };
