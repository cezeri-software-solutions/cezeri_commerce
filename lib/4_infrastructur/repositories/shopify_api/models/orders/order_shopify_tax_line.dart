import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_shopify_tax_line.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderShopifyTaxLine extends Equatable {
  @JsonKey(name: 'channel_liable')
  final bool channelLiable;
  @JsonKey(name: 'price')
  final String price;
  @JsonKey(name: 'price_set')
  final OrderShopifyPriceSet priceSet;
  @JsonKey(name: 'rate')
  final double rate;
  @JsonKey(name: 'title')
  final String title;

  const OrderShopifyTaxLine({
    required this.channelLiable,
    required this.price,
    required this.priceSet,
    required this.rate,
    required this.title,
  });

  factory OrderShopifyTaxLine.fromJson(Map<String, dynamic> json) => _$OrderShopifyTaxLineFromJson(json);
  Map<String, dynamic> toJson() => _$OrderShopifyTaxLineToJson(this);

  @override
  List<Object?> get props => [channelLiable, price, priceSet, rate, title];
  @override
  bool get stringify => true;
}




@JsonSerializable(explicitToJson: true)
class OrderShopifyPriceSet extends Equatable {
  @JsonKey(name: 'shop_money')
  final OrderShopifyAmountWithCurrencyCode shopMoney;
  @JsonKey(name: 'presentment_money')
  final OrderShopifyAmountWithCurrencyCode presentmentMoney;

  const OrderShopifyPriceSet({required this.shopMoney, required this.presentmentMoney});

  factory OrderShopifyPriceSet.fromJson(Map<String, dynamic> json) => _$OrderShopifyPriceSetFromJson(json);
  Map<String, dynamic> toJson() => _$OrderShopifyPriceSetToJson(this);

  @override
  List<Object?> get props => [shopMoney, presentmentMoney];
  @override
  bool get stringify => true;
}


@JsonSerializable()
class OrderShopifyAmountWithCurrencyCode extends Equatable {
  @JsonKey(name: 'amount')
  final String amount;
  @JsonKey(name: 'currency_code')
  final String currencyCode;

  const OrderShopifyAmountWithCurrencyCode({required this.amount, required this.currencyCode});

  factory OrderShopifyAmountWithCurrencyCode.fromJson(Map<String, dynamic> json) => _$OrderShopifyAmountWithCurrencyCodeFromJson(json);
  Map<String, dynamic> toJson() => _$OrderShopifyAmountWithCurrencyCodeToJson(this);

  @override
  List<Object?> get props => [amount, currencyCode];
  @override
  bool get stringify => true;
}