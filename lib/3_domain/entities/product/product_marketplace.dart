import 'package:json_annotation/json_annotation.dart';

import '../../../4_infrastructur/repositories/shopify_api/shopify.dart';
import '../marketplace/abstract_marketplace.dart';
import '../marketplace/marketplace_presta.dart';
import '../marketplace/marketplace_shopify.dart';
import 'marketplace_product.dart';
import 'product_presta.dart';

part 'product_marketplace.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductMarketplace {
  final String idMarketplace; // id der class Marketplace
  final String nameMarketplace; // name der class Marketplace
  final String shortNameMarketplace; // short name der class Marketplace
  final MarketplaceProduct? marketplaceProduct;

  ProductMarketplace({
    required this.idMarketplace,
    required this.nameMarketplace,
    required this.shortNameMarketplace,
    required this.marketplaceProduct,
  });

  factory ProductMarketplace.empty() {
    return ProductMarketplace(
      idMarketplace: '',
      nameMarketplace: '',
      shortNameMarketplace: '',
      marketplaceProduct: null,
    );
  }

  factory ProductMarketplace.fromMarketplaceProduct(MarketplaceProduct mp, AbstractMarketplace marketplace) {
    return switch (mp.marketplaceType) {
      MarketplaceType.prestashop => ProductMarketplace._fromProductPresta(mp as ProductPresta, marketplace as MarketplacePresta),
      MarketplaceType.shopify => ProductMarketplace._fromProductShopify(mp as ProductShopify, marketplace as MarketplaceShopify),
      MarketplaceType.shop => throw Exception('Ladengeschäft wird nicht unterstützt.'),
    };
  }

  factory ProductMarketplace._fromProductPresta(ProductPresta pp, MarketplacePresta marketplace) {
    return ProductMarketplace(
      idMarketplace: marketplace.id,
      nameMarketplace: marketplace.name,
      shortNameMarketplace: marketplace.shortName,
      marketplaceProduct: pp,
    );
  }

  factory ProductMarketplace._fromProductShopify(ProductShopify ps, MarketplaceShopify marketplace) {
    return ProductMarketplace(
      idMarketplace: marketplace.id,
      nameMarketplace: marketplace.name,
      shortNameMarketplace: marketplace.shortName,
      marketplaceProduct: ps,
    );
  }

  factory ProductMarketplace.fromJson(Map<String, dynamic> json) => _$ProductMarketplaceFromJson(json);

  Map<String, dynamic> toJson() => _$ProductMarketplaceToJson(this);

  ProductMarketplace copyWith({
    String? idMarketplace,
    String? nameMarketplace,
    String? shortNameMarketplace,
    MarketplaceProduct? marketplaceProduct,
  }) {
    return ProductMarketplace(
      idMarketplace: idMarketplace ?? this.idMarketplace,
      nameMarketplace: nameMarketplace ?? this.nameMarketplace,
      shortNameMarketplace: shortNameMarketplace ?? this.shortNameMarketplace,
      marketplaceProduct: marketplaceProduct ?? this.marketplaceProduct,
    );
  }

  @override
  String toString() {
    return 'ProductMarketplace(idMarketplace: $idMarketplace, nameMarketplace: $nameMarketplace, shortNameMarketplace: $shortNameMarketplace, marketplaceProduct: $marketplaceProduct)';
  }
}
