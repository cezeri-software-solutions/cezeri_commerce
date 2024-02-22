import 'package:json_annotation/json_annotation.dart';

import '../../entities_presta/product_presta.dart';
import '../marketplace/marketplace_presta.dart';
import 'marketplace_product.dart';
import 'marketplace_product_presta.dart';

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

  factory ProductMarketplace.fromProductPresta(ProductPresta pp, MarketplacePresta marketplace) {
    return ProductMarketplace(
      idMarketplace: marketplace.id,
      nameMarketplace: marketplace.name,
      shortNameMarketplace: marketplace.shortName,
      marketplaceProduct: MarketplaceProductPresta.fromProductPresta(pp),
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
