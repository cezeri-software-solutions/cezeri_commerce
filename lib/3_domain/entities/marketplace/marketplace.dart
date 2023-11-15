// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cezeri_commerce/3_domain/entities/settings/payment_method.dart';
import 'package:json_annotation/json_annotation.dart';

import '../address.dart';
import '../settings/bank_details.dart';
import 'marketplace_settings.dart';

part 'marketplace.g.dart';

enum MarketplaceType { shop, prestashop } // shop = Ladengeschäft

@JsonSerializable(explicitToJson: true)
class Marketplace {
  final String id;
  final String name;
  final String shortName;
  final String logoUrl;
  final MarketplaceType marketplaceType; // z.B. Prestashop, Shopware usw.
  final bool isPresta8;
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
  final List<PaymentMethod> paymentMethods;
  final Address address;
  final BankDetails bankDetails;
  final DateTime lastEditingDate;
  final DateTime createnDate;

  const Marketplace({
    required this.id,
    required this.name,
    required this.shortName,
    required this.logoUrl,
    required this.marketplaceType,
    required this.isPresta8,
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
    required this.paymentMethods,
    required this.address,
    required this.bankDetails,
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
      marketplaceType: MarketplaceType.shop,
      isPresta8: false,
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
      paymentMethods: [],
      address: Address.empty(),
      bankDetails: BankDetails.empty(),
      lastEditingDate: DateTime.now(),
      createnDate: DateTime.now(),
    );
  }

  Marketplace copyWith({
    String? id,
    String? name,
    String? shortName,
    String? logoUrl,
    MarketplaceType? marketplaceType,
    bool? isPresta8,
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
    List<PaymentMethod>? paymentMethods,
    Address? address,
    BankDetails? bankDetails,
    DateTime? lastEditingDate,
    DateTime? createnDate,
  }) {
    return Marketplace(
      id: id ?? this.id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      logoUrl: logoUrl ?? this.logoUrl,
      marketplaceType: marketplaceType ?? this.marketplaceType,
      isPresta8: isPresta8 ?? this.isPresta8,
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
      paymentMethods: paymentMethods ?? this.paymentMethods,
      address: address ?? this.address,
      bankDetails: bankDetails ?? this.bankDetails,
      lastEditingDate: lastEditingDate ?? this.lastEditingDate,
      createnDate: createnDate ?? this.createnDate,
    );
  }

  @override
  String toString() {
    return 'Marketplace(id: $id, name: $name, shortName: $shortName, logoUrl: $logoUrl, marketplaceType: $marketplaceType, isPresta8: $isPresta8, endpointUrl: $endpointUrl, url: $url, shopSuffix: $shopSuffix, fullUrl: $fullUrl, key: $key, isActive: $isActive, orderStatusIdList: $orderStatusIdList, orderStatusOnSuccessImport: $orderStatusOnSuccessImport, orderStatusOnSuccessShipping: $orderStatusOnSuccessShipping, warehouseForProductImport: $warehouseForProductImport, createMissingProductOnOrderImport: $createMissingProductOnOrderImport, marketplaceSettings: $marketplaceSettings, paymentMethods: $paymentMethods, address: $address, bankDetails: $bankDetails, lastEditingDate: $lastEditingDate, createnDate: $createnDate)';
  }
}
