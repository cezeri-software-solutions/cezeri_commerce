import 'package:cezeri_commerce/3_domain/entities/settings/payment_method.dart';
import 'package:json_annotation/json_annotation.dart';

import '../address.dart';
import '../settings/bank_details.dart';
import 'abstract_marketplace.dart';
import 'marketplace_settings.dart';

part 'marketplace_shopify.g.dart';

@JsonSerializable(explicitToJson: true)
class MarketplaceShopify extends AbstractMarketplace {
  final String endpointUrl; // http:// oder https://
  final String storeName; // your_shop.com
  final String shopSuffix; // Ändung z.B. admin/
  final String url;
  final String fullUrl; // endpointUrl + {storeName}..myshopify.com/ + shopSuffix
  final String adminAccessToken; // API-Schlüssel
  final String storefrontAccessToken; // Admin-API-Zugriffstoken
  final List<PaymentMethod> paymentMethods;

  const MarketplaceShopify({
    required super.id,
    required super.name,
    required super.shortName,
    required super.logoUrl,
    required this.endpointUrl,
    required this.storeName,
    required this.shopSuffix,
    required this.url,
    required this.adminAccessToken,
    required this.storefrontAccessToken,
    required super.isActive,
    required super.marketplaceSettings,
    required this.paymentMethods,
    required super.address,
    required super.bankDetails,
    required super.lastEditingDate,
    required super.createnDate,
  })  : fullUrl = '$endpointUrl$storeName.myshopify.com/$shopSuffix',
        super(marketplaceType: MarketplaceType.shopify);

  factory MarketplaceShopify.fromJson(Map<String, dynamic> json) => _$MarketplaceShopifyFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MarketplaceShopifyToJson(this);

  factory MarketplaceShopify.empty() {
    return MarketplaceShopify(
      id: '',
      name: '',
      shortName: '',
      logoUrl: '',
      endpointUrl: '',
      storeName: '',
      shopSuffix: '',
      url: '',
      adminAccessToken: '',
      storefrontAccessToken: '',
      isActive: false,
      marketplaceSettings: MarketplaceSettings.empty(),
      paymentMethods: const [],
      address: Address.empty(),
      bankDetails: BankDetails.empty(),
      lastEditingDate: DateTime.now(),
      createnDate: DateTime.now(),
    );
  }

  MarketplaceShopify copyWith({
    String? id,
    String? name,
    String? shortName,
    String? logoUrl,
    String? endpointUrl,
    String? storeName,
    String? shopSuffix,
    String? url,
    String? adminAccessToken,
    String? storefrontAccessToken,
    bool? isActive,
    MarketplaceSettings? marketplaceSettings,
    List<PaymentMethod>? paymentMethods,
    Address? address,
    BankDetails? bankDetails,
    DateTime? lastEditingDate,
    DateTime? createnDate,
  }) {
    return MarketplaceShopify(
      id: id ?? this.id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      logoUrl: logoUrl ?? this.logoUrl,
      endpointUrl: endpointUrl ?? this.endpointUrl,
      storeName: storeName ?? this.storeName,
      shopSuffix: shopSuffix ?? this.shopSuffix,
      url: url ?? this.url,
      adminAccessToken: adminAccessToken ?? this.adminAccessToken,
      storefrontAccessToken: storefrontAccessToken ?? this.storefrontAccessToken,
      isActive: isActive ?? this.isActive,
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
        endpointUrl,
        storeName,
        shopSuffix,
        url,
        adminAccessToken,
        storefrontAccessToken,
        isActive,
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
