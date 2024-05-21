// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductImage _$ProductImageFromJson(Map<String, dynamic> json) => ProductImage(
      sortId: (json['sortId'] as num).toInt(),
      fileName: json['fileName'] as String,
      fileUrl: json['fileUrl'] as String,
      seoText: json['seoText'] as String,
      isDefault: json['isDefault'] as bool,
    );

Map<String, dynamic> _$ProductImageToJson(ProductImage instance) =>
    <String, dynamic>{
      'sortId': instance.sortId,
      'fileName': instance.fileName,
      'fileUrl': instance.fileUrl,
      'seoText': instance.seoText,
      'isDefault': instance.isDefault,
    };
