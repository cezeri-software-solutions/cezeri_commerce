import 'package:json_annotation/json_annotation.dart';

import '../../../1_presentation/core/core.dart';
import '../../../4_infrastructur/repositories/prestashop_api/models/customer_presta.dart';
import '../../../4_infrastructur/repositories/shopify_api/shopify.dart';
import '../marketplace/marketplace_presta.dart';
import '../marketplace/marketplace_shopify.dart';

part 'customer_marketplace.g.dart';

@JsonSerializable()
class CustomerMarketplace {
  final String marketplaceId;
  final String marketplaceName;
  final int customerIdMarketplace;
  final bool isNewsletterAccepted;
  final bool isGuest;

  const CustomerMarketplace({
    required this.marketplaceId,
    required this.marketplaceName,
    required this.customerIdMarketplace,
    required this.isNewsletterAccepted,
    required this.isGuest,
  });

  factory CustomerMarketplace.fromJson(Map<String, dynamic> json) => _$CustomerMarketplaceFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerMarketplaceToJson(this);

  factory CustomerMarketplace.empty() {
    return const CustomerMarketplace(
      marketplaceId: '',
      marketplaceName: '',
      customerIdMarketplace: 0,
      isNewsletterAccepted: false,
      isGuest: false,
    );
  }

  factory CustomerMarketplace.fromPresta(CustomerPresta customerPresta, MarketplacePresta marketplace) {
    return CustomerMarketplace(
      marketplaceId: marketplace.id,
      marketplaceName: marketplace.name,
      customerIdMarketplace: customerPresta.id,
      isNewsletterAccepted: stringToBool(customerPresta.newsletter),
      isGuest: stringToBool(customerPresta.isGuest),
    );
  }

  factory CustomerMarketplace.fromShopify(OrderCustomerShopify customerShopify, MarketplaceShopify marketplace) {
    return CustomerMarketplace(
      marketplaceId: marketplace.id,
      marketplaceName: marketplace.name,
      customerIdMarketplace: customerShopify.id,
      isNewsletterAccepted: false,
      isGuest: true,
    );
  }

  CustomerMarketplace copyWith({
    String? marketplaceId,
    String? marketplaceName,
    int? customerIdMarketplace,
    bool? isNewsletterAccepted,
    bool? isGuest,
  }) {
    return CustomerMarketplace(
      marketplaceId: marketplaceId ?? this.marketplaceId,
      marketplaceName: marketplaceName ?? this.marketplaceName,
      customerIdMarketplace: customerIdMarketplace ?? this.customerIdMarketplace,
      isNewsletterAccepted: isNewsletterAccepted ?? this.isNewsletterAccepted,
      isGuest: isGuest ?? this.isGuest,
    );
  }

  @override
  String toString() {
    return 'CustomerMarketplace(marketplaceId: $marketplaceId, marketplaceName: $marketplaceName, customerIdMarketplace: $customerIdMarketplace, isNewsletterAccepted: $isNewsletterAccepted, isGuest: $isGuest)';
  }
}
