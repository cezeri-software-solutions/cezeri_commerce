import 'package:cezeri_commerce/3_domain/entities/marketplace/marketplace_shopify.dart';
import 'package:json_annotation/json_annotation.dart';

import '../address.dart';
import '../marketplace/abstract_marketplace.dart';
import '../marketplace/marketplace_presta.dart';
import '../settings/bank_details.dart';

part 'receipt_marketplace.g.dart';

@JsonSerializable(explicitToJson: true)
class ReceiptMarketplace {
  final Address address;
  final BankDetails bankDetails;
  final String url;

  const ReceiptMarketplace({
    required this.address,
    required this.bankDetails,
    required this.url,
  });

  factory ReceiptMarketplace.fromJson(Map<String, dynamic> json) => _$ReceiptMarketplaceFromJson(json);

  Map<String, dynamic> toJson() => _$ReceiptMarketplaceToJson(this);

  factory ReceiptMarketplace.empty() {
    return ReceiptMarketplace(
      address: Address.empty(),
      bankDetails: BankDetails.empty(),
      url: '',
    );
  }

  factory ReceiptMarketplace.fromMarketplace(AbstractMarketplace marketplace) {
    return switch (marketplace.marketplaceType) {
      MarketplaceType.prestashop => ReceiptMarketplace(
          address: (marketplace as MarketplacePresta).address,
          bankDetails: marketplace.bankDetails,
          url: marketplace.url,
        ),
      MarketplaceType.shopify => ReceiptMarketplace(
          address: (marketplace as MarketplaceShopify).address,
          bankDetails: marketplace.bankDetails,
          url: marketplace.url,
        ),
      MarketplaceType.shop => ReceiptMarketplace(
          address: marketplace.address,
          bankDetails: marketplace.bankDetails,
          url: '',
        ),
    };
  }

  ReceiptMarketplace copyWith({
    Address? address,
    BankDetails? bankDetails,
    String? url,
  }) {
    return ReceiptMarketplace(
      address: address ?? this.address,
      bankDetails: bankDetails ?? this.bankDetails,
      url: url ?? this.url,
    );
  }

  @override
  String toString() => 'ReceiptMarketplace(address: $address, bankDetails: $bankDetails, url: $url)';
}
