import 'package:flutter/material.dart';

import '../marketplace/marketplace.dart';
import 'marketplace_product_presta.dart';

abstract class MarketplaceProduct {
  final MarketplaceType marketplaceType;

  const MarketplaceProduct(this.marketplaceType);

  factory MarketplaceProduct.fromJson(Map<String, dynamic> json) {
    try {
      return MarketplaceProductPresta.fromJson(json);
    } catch (_) {}

    throw Exception('Unknown MarketplaceProduct');
  }

  @mustCallSuper
  Map<String, dynamic> toJson();
  //   MarketplaceProductPresta instance = this as MarketplaceProductPresta;
  //   try {
  //     return instance.toJson();
  //   } catch (_) {
  //     throw Exception('Failed to convert ProductPresta to json');
  //   }
  // }
}
