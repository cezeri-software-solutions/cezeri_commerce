import 'package:cezeri_commerce/3_domain/entities/settings/payment_method.dart';
import 'package:json_annotation/json_annotation.dart';

import '../address.dart';
import '../settings/bank_details.dart';
import 'abstract_marketplace.dart';
import 'marketplace_settings.dart';

part 'marketplace_presta.g.dart';

@JsonSerializable(explicitToJson: true)
class MarketplacePresta extends AbstractMarketplace {
  final bool isPresta8;
  final String endpointUrl; // http:// oder https://
  final String url; // your_shop.com
  final String shopSuffix; // Ändung z.B. api/
  final String fullUrl; // endpointUrl + url + shopSuffix
  final String key;
  final List<int> orderStatusIdList; // Welche Bestellstatusse importiert werden sollen
  final int? orderStatusOnSuccessImport;
  final int? orderStatusOnSuccessShipping;
  final String warehouseForProductImport; //* Wird nicht genutzt (Lager für Import)
  final bool createMissingProductOnOrderImport; //* Wird nicht genutzt (Sollen beim Bestellimport fehlende Artikel angelegt werden)
  final List<PaymentMethod> paymentMethods;

  const MarketplacePresta({
    required super.id,
    required super.name,
    required super.shortName,
    required super.logoUrl,
    required this.isPresta8,
    required this.endpointUrl,
    required this.url,
    required this.shopSuffix,
    required this.key,
    required super.isActive,
    required this.orderStatusIdList,
    required this.orderStatusOnSuccessImport,
    required this.orderStatusOnSuccessShipping,
    required this.warehouseForProductImport,
    required this.createMissingProductOnOrderImport,
    required super.marketplaceSettings,
    required this.paymentMethods,
    required super.address,
    required super.bankDetails,
    required super.lastEditingDate,
    required super.createnDate,
  })  : fullUrl = endpointUrl + url + shopSuffix,
        super(marketplaceType: MarketplaceType.prestashop);

  factory MarketplacePresta.fromJson(Map<String, dynamic> json) => _$MarketplacePrestaFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MarketplacePrestaToJson(this);

  factory MarketplacePresta.empty() {
    return MarketplacePresta(
      id: '',
      name: '',
      shortName: '',
      logoUrl: '',
      isPresta8: false,
      endpointUrl: '',
      url: '',
      shopSuffix: '',
      key: '',
      isActive: false,
      orderStatusIdList: const [],
      orderStatusOnSuccessImport: null,
      orderStatusOnSuccessShipping: null,
      warehouseForProductImport: '',
      createMissingProductOnOrderImport: true,
      marketplaceSettings: MarketplaceSettings.empty(),
      paymentMethods: const [],
      address: Address.empty(),
      bankDetails: BankDetails.empty(),
      lastEditingDate: DateTime.now(),
      createnDate: DateTime.now(),
    );
  }

  MarketplacePresta copyWith({
    String? id,
    String? name,
    String? shortName,
    String? logoUrl,
    bool? isPresta8,
    String? endpointUrl,
    String? url,
    String? shopSuffix,
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
    return MarketplacePresta(
      id: id ?? this.id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      logoUrl: logoUrl ?? this.logoUrl,
      isPresta8: isPresta8 ?? this.isPresta8,
      endpointUrl: endpointUrl ?? this.endpointUrl,
      url: url ?? this.url,
      shopSuffix: shopSuffix ?? this.shopSuffix,
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
  List<Object?> get props => [
        id,
        name,
        shortName,
        logoUrl,
        isPresta8,
        endpointUrl,
        url,
        shopSuffix,
        key,
        isActive,
        orderStatusIdList,
        orderStatusOnSuccessImport,
        orderStatusOnSuccessShipping,
        warehouseForProductImport,
        createMissingProductOnOrderImport,
        marketplaceSettings,
        paymentMethods,
        address,
        bankDetails,
        lastEditingDate,
        createnDate,
      ];

  @override
  bool get stringify => true;
}
