// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_collection_shopify.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomCollectionShopify _$CustomCollectionShopifyFromJson(
        Map<String, dynamic> json) =>
    CustomCollectionShopify(
      bodyHtml: json['body_html'] as String,
      handle: json['handle'] as String,
      image: json['image'] == null
          ? null
          : CustomCollectionImage.fromJson(
              json['image'] as Map<String, dynamic>),
      id: (json['id'] as num).toInt(),
      published: json['published'] as bool?,
      publishedAt: json['published_at'] == null
          ? null
          : DateTime.parse(json['published_at'] as String),
      publishedScope: json['published_scope'] as String,
      sortOrder: json['sort_order'] as String,
      templateSuffix: json['template_suffix'] as String?,
      title: json['title'] as String,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$CustomCollectionShopifyToJson(
        CustomCollectionShopify instance) =>
    <String, dynamic>{
      'body_html': instance.bodyHtml,
      'handle': instance.handle,
      'image': instance.image?.toJson(),
      'id': instance.id,
      'published': instance.published,
      'published_at': instance.publishedAt?.toIso8601String(),
      'published_scope': instance.publishedScope,
      'sort_order': instance.sortOrder,
      'template_suffix': instance.templateSuffix,
      'title': instance.title,
      'updated_at': instance.updatedAt.toIso8601String(),
    };

CustomCollectionImage _$CustomCollectionImageFromJson(
        Map<String, dynamic> json) =>
    CustomCollectionImage(
      attachment: json['attachment'] as String?,
      src: json['src'] as String,
      alt: json['alt'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
    );

Map<String, dynamic> _$CustomCollectionImageToJson(
        CustomCollectionImage instance) =>
    <String, dynamic>{
      'attachment': instance.attachment,
      'src': instance.src,
      'alt': instance.alt,
      'created_at': instance.createdAt.toIso8601String(),
      'width': instance.width,
      'height': instance.height,
    };
