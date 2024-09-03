// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'packaging_box.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackagingBox _$PackagingBoxFromJson(Map<String, dynamic> json) => PackagingBox(
      id: json['id'] as String,
      pos: (json['pos'] as num).toInt(),
      name: json['name'] as String,
      shortName: json['shortName'] as String,
      imageUrl: json['imageUrl'] as String?,
      deliveryNoteId: (json['deliveryNoteId'] as num?)?.toInt(),
      dimensionsInside:
          Dimensions.fromJson(json['dimensionsInside'] as Map<String, dynamic>),
      dimensionsOutside: Dimensions.fromJson(
          json['dimensionsOutside'] as Map<String, dynamic>),
      weight: (json['weight'] as num).toDouble(),
      wholesalePrice: (json['wholesalePrice'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$PackagingBoxToJson(PackagingBox instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pos': instance.pos,
      'name': instance.name,
      'shortName': instance.shortName,
      'imageUrl': instance.imageUrl,
      'deliveryNoteId': instance.deliveryNoteId,
      'dimensionsInside': instance.dimensionsInside.toJson(),
      'dimensionsOutside': instance.dimensionsOutside.toJson(),
      'weight': instance.weight,
      'wholesalePrice': instance.wholesalePrice,
      'quantity': instance.quantity,
    };
