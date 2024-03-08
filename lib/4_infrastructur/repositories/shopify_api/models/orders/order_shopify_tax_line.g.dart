// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_shopify_tax_line.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderShopifyTaxLine _$OrderShopifyTaxLineFromJson(Map<String, dynamic> json) =>
    OrderShopifyTaxLine(
      channelLiable: json['channel_liable'] as bool,
      price: json['price'] as String,
      priceSet: OrderShopifyPriceSet.fromJson(
          json['price_set'] as Map<String, dynamic>),
      rate: (json['rate'] as num).toDouble(),
      title: json['title'] as String,
    );

Map<String, dynamic> _$OrderShopifyTaxLineToJson(
        OrderShopifyTaxLine instance) =>
    <String, dynamic>{
      'channel_liable': instance.channelLiable,
      'price': instance.price,
      'price_set': instance.priceSet.toJson(),
      'rate': instance.rate,
      'title': instance.title,
    };

OrderShopifyPriceSet _$OrderShopifyPriceSetFromJson(
        Map<String, dynamic> json) =>
    OrderShopifyPriceSet(
      shopMoney: OrderShopifyAmountWithCurrencyCode.fromJson(
          json['shop_money'] as Map<String, dynamic>),
      presentmentMoney: OrderShopifyAmountWithCurrencyCode.fromJson(
          json['presentment_money'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderShopifyPriceSetToJson(
        OrderShopifyPriceSet instance) =>
    <String, dynamic>{
      'shop_money': instance.shopMoney.toJson(),
      'presentment_money': instance.presentmentMoney.toJson(),
    };

OrderShopifyAmountWithCurrencyCode _$OrderShopifyAmountWithCurrencyCodeFromJson(
        Map<String, dynamic> json) =>
    OrderShopifyAmountWithCurrencyCode(
      amount: json['amount'] as String,
      currencyCode: json['currency_code'] as String,
    );

Map<String, dynamic> _$OrderShopifyAmountWithCurrencyCodeToJson(
        OrderShopifyAmountWithCurrencyCode instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'currency_code': instance.currencyCode,
    };
