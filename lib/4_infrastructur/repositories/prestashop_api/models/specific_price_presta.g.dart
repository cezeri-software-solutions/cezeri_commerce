// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specific_price_presta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpecificPricesPresta _$SpecificPricesPrestaFromJson(
        Map<String, dynamic> json) =>
    SpecificPricesPresta(
      items: (json['specific_prices'] as List<dynamic>)
          .map((e) => SpecificPricePresta.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SpecificPricesPrestaToJson(
        SpecificPricesPresta instance) =>
    <String, dynamic>{
      'specific_prices': instance.items,
    };

SpecificPricePresta _$SpecificPricePrestaFromJson(Map<String, dynamic> json) =>
    SpecificPricePresta(
      id: (json['id'] as num).toInt(),
      idShopGroup: json['id_shop_group'] as String,
      idShop: json['id_shop'] as String,
      idCart: json['id_cart'] as String,
      idProduct: json['id_product'] as String,
      idProductAttribute: json['id_product_attribute'] as String,
      idCurrency: json['id_currency'] as String,
      idCountry: json['id_country'] as String,
      idGroup: json['id_group'] as String,
      idCustomer: json['id_customer'] as String,
      idSpecificPriceRule: json['id_specific_price_rule'] as String,
      price: json['price'] as String,
      fromQuantity: json['from_quantity'] as String,
      reduction: json['reduction'] as String,
      reductionTax: json['reduction_tax'] as String,
      reductionType: json['reduction_type'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
    );

Map<String, dynamic> _$SpecificPricePrestaToJson(
        SpecificPricePresta instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_shop_group': instance.idShopGroup,
      'id_shop': instance.idShop,
      'id_cart': instance.idCart,
      'id_product': instance.idProduct,
      'id_product_attribute': instance.idProductAttribute,
      'id_currency': instance.idCurrency,
      'id_country': instance.idCountry,
      'id_group': instance.idGroup,
      'id_customer': instance.idCustomer,
      'id_specific_price_rule': instance.idSpecificPriceRule,
      'price': instance.price,
      'from_quantity': instance.fromQuantity,
      'reduction': instance.reduction,
      'reduction_tax': instance.reductionTax,
      'reduction_type': instance.reductionType,
      'from': instance.from,
      'to': instance.to,
    };
