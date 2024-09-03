import 'package:cezeri_commerce/4_infrastructur/repositories/shopify_api/shopify.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../marketplace/abstract_marketplace.dart';
import 'product_presta.dart';

abstract class MarketplaceProduct extends Equatable {
  final MarketplaceType marketplaceType;

  const MarketplaceProduct(this.marketplaceType);

  factory MarketplaceProduct.fromJson(Map<String, dynamic> json) {
    try {
      return ProductPresta.fromJson(json);
    } catch (_) {}

    try {
      return ProductShopify.fromJson(json);
    } catch (_) {}

    throw Exception('Unknown MarketplaceProduct');
  }

  @mustCallSuper
  Map<String, dynamic> toJson();
}
