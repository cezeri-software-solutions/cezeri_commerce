import 'package:json_annotation/json_annotation.dart';

import '../address.dart';
import '../settings/bank_details.dart';
import 'abstract_marketplace.dart';
import 'marketplace_settings.dart';

part 'marketplace_shop.g.dart';

@JsonSerializable(explicitToJson: true)
class MarketplaceShop extends AbstractMarketplace {
  final String? defaultCustomerId;

  const MarketplaceShop({
    required super.id,
    required super.name,
    required super.shortName,
    required super.logoUrl,
    required super.isActive,
    required this.defaultCustomerId,
    required super.address,
    required super.marketplaceSettings,
    required super.bankDetails,
    required super.lastEditingDate,
    required super.createnDate,
  }) : super(marketplaceType: MarketplaceType.shop);

  factory MarketplaceShop.fromJson(Map<String, dynamic> json) => _$MarketplaceShopFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$MarketplaceShopToJson(this);

  factory MarketplaceShop.empty() {
    return MarketplaceShop(
      id: '',
      name: '',
      shortName: '',
      logoUrl: '',
      isActive: false,
      defaultCustomerId: null,
      address: Address.empty(),
      marketplaceSettings: MarketplaceSettings.empty(),
      bankDetails: BankDetails.empty(),
      lastEditingDate: DateTime.now(),
      createnDate: DateTime.now(),
    );
  }

  MarketplaceShop copyWith({
    String? id,
    String? name,
    String? shortName,
    String? logoUrl,
    bool? isActive,
    String? defaultCustomerId,
    MarketplaceSettings? marketplaceSettings,
    Address? address,
    BankDetails? bankDetails,
    DateTime? lastEditingDate,
    DateTime? createnDate,
  }) {
    return MarketplaceShop(
      id: id ?? this.id,
      name: name ?? this.name,
      shortName: shortName ?? this.shortName,
      logoUrl: logoUrl ?? this.logoUrl,
      isActive: isActive ?? this.isActive,
      defaultCustomerId: defaultCustomerId ?? this.defaultCustomerId,
      marketplaceSettings: marketplaceSettings ?? this.marketplaceSettings,
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
        isActive,
        marketplaceSettings,
        address,
        bankDetails,
        lastEditingDate,
        createnDate,
      ];

  @override
  bool get stringify => true;
}
