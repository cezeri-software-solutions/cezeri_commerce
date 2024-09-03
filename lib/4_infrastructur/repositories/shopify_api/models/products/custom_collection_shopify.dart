import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'custom_collection_shopify.g.dart';

@JsonSerializable(explicitToJson: true)
class CustomCollectionShopify extends Equatable {
  @JsonKey(name: 'body_html')
  final String bodyHtml;
  final String handle;
  final CustomCollectionImage? image; // Annahme, dass eine CustomCollectionImage-Klasse existiert oder erstellt werden muss.
  final int id;
  final bool? published;
  @JsonKey(name: 'published_at')
  final DateTime? publishedAt;
  @JsonKey(name: 'published_scope')
  final String publishedScope;
  @JsonKey(name: 'sort_order')
  final String sortOrder;
  @JsonKey(name: 'template_suffix')
  final String? templateSuffix;
  final String title;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const CustomCollectionShopify({
    required this.bodyHtml,
    required this.handle,
    required this.image,
    required this.id,
    required this.published,
    this.publishedAt,
    required this.publishedScope,
    required this.sortOrder,
    this.templateSuffix,
    required this.title,
    required this.updatedAt,
  });

  factory CustomCollectionShopify.fromJson(Map<String, dynamic> json) => _$CustomCollectionShopifyFromJson(json);
  Map<String, dynamic> toJson() => _$CustomCollectionShopifyToJson(this);

  @override
  List<Object?> get props => [
        bodyHtml,
        handle,
        image,
        id,
        published,
        publishedAt,
        publishedScope,
        sortOrder,
        templateSuffix,
        title,
        updatedAt,
      ];

  @override
  bool get stringify => true;
}

@JsonSerializable()
class CustomCollectionImage extends Equatable {
  final String? attachment;
  final String src;
  final String? alt;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  final int width;
  final int height;

  const CustomCollectionImage({
    this.attachment,
    required this.src,
    this.alt,
    required this.createdAt,
    required this.width,
    required this.height,
  });

  factory CustomCollectionImage.fromJson(Map<String, dynamic> json) => _$CustomCollectionImageFromJson(json);
  Map<String, dynamic> toJson() => _$CustomCollectionImageToJson(this);

  @override
  List<Object?> get props => [attachment, src, alt, createdAt, width, height];

  @override
  bool get stringify => true;
}
