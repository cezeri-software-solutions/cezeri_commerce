import 'package:json_annotation/json_annotation.dart';

import 'marketplace_settings.dart';

part 'marketplace.g.dart';

@JsonSerializable(explicitToJson: true)
class Marketplace {
  final String id;
  final String name;
  final String shortName;
  final String logoUrl;
  final String marketplaceType; // z.B. Prestashop, Shopware usw.
  final String endpointUrl; // http:// oder https://
  final String url; // your_shop.com
  final String shopSuffix; // Ändung z.B. api/
  final String fullUrl; // endpointUrl + url + shopSuffix
  final String key;
  final bool isActive;
  final List<int> orderStatusIdList; // Welche Bestellstatusse importiert werden sollen
  final int? orderStatusOnSuccessImport;
  final int? orderStatusOnSuccessShipping;
  final String warehouseForProductImport; //* Wird nicht genutzt (Lager für Import)
  final bool createMissingProductOnOrderImport; //* Wird nicht genutzt (Sollen beim Bestellimport fehlende Artikel angelegt werden)
  final MarketplaceSettings marketplaceSettings;
  final DateTime lastEditingDate;
  final DateTime createnDate;

  const Marketplace({
    required this.id,
    required this.name,
    required this.shortName,
    required this.logoUrl,
    required this.marketplaceType,
    required this.endpointUrl,
    required this.url,
    required this.shopSuffix,
    required this.fullUrl,
    required this.key,
    required this.isActive,
    required this.orderStatusIdList,
    required this.orderStatusOnSuccessImport,
    required this.orderStatusOnSuccessShipping,
    required this.warehouseForProductImport,
    required this.createMissingProductOnOrderImport,
    required this.marketplaceSettings,
    required this.lastEditingDate,
    required this.createnDate,
  });

  factory Marketplace.fromJson(Map<String, dynamic> json) => _$MarketplaceFromJson(json);

  Map<String, dynamic> toJson() => _$MarketplaceToJson(this);

  factory Marketplace.empty() {
    return Marketplace(
      id: '',
      name: '',
      shortName: '',
      logoUrl: '',
      marketplaceType: '',
      endpointUrl: '',
      url: '',
      shopSuffix: '',
      fullUrl: '',
      key: '',
      isActive: false,
      orderStatusIdList: [],
      orderStatusOnSuccessImport: null,
      orderStatusOnSuccessShipping: null,
      warehouseForProductImport: '',
      createMissingProductOnOrderImport: true,
      marketplaceSettings: MarketplaceSettings.empty(),
      lastEditingDate: DateTime.now(),
      createnDate: DateTime.now(),
    );
  }

  Marketplace copyWith({
    String? id,
    String? name,
    String? shortName,
    String? logoUrl,
    String? marketplaceName,
    String? endpointUrl,
    String? url,
    String? shopSuffix,
    String? fullUrl,
    String? key,
    bool? isActive,
    List<int>? orderStatusIdList,
    int? orderStatusOnSuccessImport,
    int? orderStatusOnSuccessShipping,
    String? warehouseForProductImport,
    bool? createMissingProductOnOrderImport,
    MarketplaceSettings? marketplaceSettings,
    DateTime? lastEditingDate,
    DateTime? createnDate,
  }) {
    return Marketplace(
      id: id ?? this.id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      logoUrl: logoUrl ?? this.logoUrl,
      marketplaceType: marketplaceName ?? marketplaceType,
      endpointUrl: endpointUrl ?? this.endpointUrl,
      url: url ?? this.url,
      shopSuffix: shopSuffix ?? this.shopSuffix,
      fullUrl: fullUrl ?? this.fullUrl,
      key: key ?? this.key,
      isActive: isActive ?? this.isActive,
      orderStatusIdList: orderStatusIdList ?? this.orderStatusIdList,
      orderStatusOnSuccessImport: orderStatusOnSuccessImport ?? this.orderStatusOnSuccessImport,
      orderStatusOnSuccessShipping: orderStatusOnSuccessShipping ?? this.orderStatusOnSuccessShipping,
      warehouseForProductImport: warehouseForProductImport ?? this.warehouseForProductImport,
      createMissingProductOnOrderImport: createMissingProductOnOrderImport ?? this.createMissingProductOnOrderImport,
      marketplaceSettings: marketplaceSettings ?? this.marketplaceSettings,
      lastEditingDate: lastEditingDate ?? this.lastEditingDate,
      createnDate: createnDate ?? this.createnDate,
    );
  }
}
