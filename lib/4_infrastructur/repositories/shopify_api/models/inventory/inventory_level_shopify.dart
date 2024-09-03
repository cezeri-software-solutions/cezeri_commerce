import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inventory_level_shopify.g.dart';

@JsonSerializable()
class InventoryLevelShopify extends Equatable {
  final int? available;
  @JsonKey(name: 'inventory_item_id')
  final int inventoryItemId;
  @JsonKey(name: 'location_id')
  final int locationId;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const InventoryLevelShopify({
    this.available,
    required this.inventoryItemId,
    required this.locationId,
    required this.updatedAt,
  });

  factory InventoryLevelShopify.fromJson(Map<String, dynamic> json) => _$InventoryLevelShopifyFromJson(json);
  Map<String, dynamic> toJson() => _$InventoryLevelShopifyToJson(this);

  @override
  List<Object?> get props => [available, inventoryItemId, locationId, updatedAt];

  @override
  bool get stringify => true;
}
