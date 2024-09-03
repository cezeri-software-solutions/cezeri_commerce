// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_marketplace.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductMarketplace _$ProductMarketplaceFromJson(Map<String, dynamic> json) =>
    ProductMarketplace(
      idMarketplace: json['idMarketplace'] as String,
      nameMarketplace: json['nameMarketplace'] as String,
      shortNameMarketplace: json['shortNameMarketplace'] as String,
      marketplaceProduct: json['marketplaceProduct'] == null
          ? null
          : MarketplaceProduct.fromJson(
              json['marketplaceProduct'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductMarketplaceToJson(ProductMarketplace instance) =>
    <String, dynamic>{
      'idMarketplace': instance.idMarketplace,
      'nameMarketplace': instance.nameMarketplace,
      'shortNameMarketplace': instance.shortNameMarketplace,
      'marketplaceProduct': instance.marketplaceProduct?.toJson(),
    };
