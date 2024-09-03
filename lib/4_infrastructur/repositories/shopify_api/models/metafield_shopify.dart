import 'package:cezeri_commerce/4_infrastructur/repositories/shopify_api/enums/metafield_type.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../enums/enums.dart';

part 'metafield_shopify.g.dart';

@JsonSerializable()
class MetafieldShopify extends Equatable {
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  final String? description;
  final int id;
  final String key;
  final String namespace;
  @JsonKey(name: 'owner_id')
  final int ownerId;
  @JsonKey(name: 'owner_resource')
  final String ownerResource;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final String value;
  final dynamic type;
  final MetafieldType metafieldType;

  MetafieldShopify({
    required this.createdAt,
    required this.description,
    required this.id,
    required this.key,
    required this.namespace,
    required this.ownerId,
    required this.ownerResource,
    required this.updatedAt,
    required this.value,
    required this.type,
  }) : metafieldType = _getMetafieldType(key, ownerResource);

  static MetafieldType _getMetafieldType(String key, String ownerResource) {
    if (key == 'product') {
      return switch (ownerResource) {
        'title_tag' => MetafieldType.productMetaTitle,
        'description_tag' => MetafieldType.productMetaDescription,
        _ => MetafieldType.unknown,
      };
    }
    return MetafieldType.unknown;
  }

  factory MetafieldShopify.fromJson(Map<String, dynamic> json) => _$MetafieldShopifyFromJson(json);
  Map<String, dynamic> toJson() => _$MetafieldShopifyToJson(this);

  @override
  List<Object?> get props => [
        createdAt,
        description,
        id,
        key,
        namespace,
        ownerId,
        ownerResource,
        updatedAt,
        value,
        type,
      ];

  @override
  bool get stringify => true;
}
