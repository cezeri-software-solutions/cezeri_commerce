import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../address.dart';
import '../settings/bank_details.dart';
import 'marketplace_presta.dart';
import 'marketplace_settings.dart';
import 'marketplace_shop.dart';
import 'marketplace_shopify.dart';

enum MarketplaceType { shop, prestashop, shopify }

abstract class AbstractMarketplace extends Equatable {
  final String id;
  final String name;
  final String shortName;
  final String logoUrl;
  final bool isActive;
  final MarketplaceType marketplaceType;
  final Address address;
  final MarketplaceSettings marketplaceSettings;
  final BankDetails bankDetails;
  final DateTime lastEditingDate;
  final DateTime createnDate;

  const AbstractMarketplace({
    required this.id,
    required this.name,
    required this.shortName,
    required this.logoUrl,
    required this.isActive,
    required this.address,
    required this.marketplaceSettings,
    required this.bankDetails,
    required this.lastEditingDate,
    required this.createnDate,
    required this.marketplaceType,
  });

  factory AbstractMarketplace.fromJson(Map<String, dynamic> json) {
    try {
      return MarketplacePresta.fromJson(json);
    } catch (_) {}

    try {
      return MarketplaceShopify.fromJson(json);
    } catch (_) {}

    try {
      return MarketplaceShop.fromJson(json);
    } catch (_) {}

    return throw Exception('Unbekannter Marktplatztyp');
  }

  @mustCallSuper
  Map<String, dynamic> toJson();

  factory AbstractMarketplace.empty() {
    return MarketplacePresta.empty();
  }
}
