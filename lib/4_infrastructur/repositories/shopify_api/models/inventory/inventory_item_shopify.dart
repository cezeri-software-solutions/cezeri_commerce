import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'inventory_item_shopify.g.dart';

@JsonSerializable()
class InventoryItemShopify extends Equatable {
  final double? cost;
  @JsonKey(name: 'country_code_of_origin')
  final String? countryCodeOfOrigin;
  @JsonKey(name: 'country_harmonized_system_codes')
  final List<String>? countryHarmonizedSystemCodes;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'harmonized_system_code')
  final String? harmonizedSystemCode;
  final int id;
  @JsonKey(name: 'province_code_of_origin')
  final String? provinceCodeOfOrigin;
  final String sku;
  final bool tracked;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'requires_shipping')
  final bool requiresShipping;

  const InventoryItemShopify({
    this.cost,
    this.countryCodeOfOrigin,
    this.countryHarmonizedSystemCodes,
    required this.createdAt,
    this.harmonizedSystemCode,
    required this.id,
    this.provinceCodeOfOrigin,
    required this.sku,
    required this.tracked,
    required this.updatedAt,
    required this.requiresShipping,
  });

  factory InventoryItemShopify.fromJson(Map<String, dynamic> json) => _$InventoryItemShopifyFromJson(json);
  Map<String, dynamic> toJson() => _$InventoryItemShopifyToJson(this);

  @override
  List<Object?> get props => [
        cost,
        countryCodeOfOrigin,
        countryHarmonizedSystemCodes,
        createdAt,
        harmonizedSystemCode,
        id,
        provinceCodeOfOrigin,
        sku,
        tracked,
        updatedAt,
        requiresShipping,
      ];

  @override
  bool get stringify => true;
}
