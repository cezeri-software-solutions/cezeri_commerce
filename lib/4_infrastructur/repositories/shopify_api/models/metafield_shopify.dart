import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'metafield_shopify.g.dart';

@JsonSerializable()
class MetafieldShopify extends Equatable {
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  final String description;
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

  const MetafieldShopify({
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
  });

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
