// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReceiptProduct _$ReceiptProductFromJson(Map<String, dynamic> json) =>
    ReceiptProduct(
      productId: json['productId'] as String,
      productAttributeId: (json['productAttributeId'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      shippedQuantity: (json['shippedQuantity'] as num).toInt(),
      name: json['name'] as String,
      articleNumber: json['articleNumber'] as String,
      ean: json['ean'] as String,
      price: (json['price'] as num).toDouble(),
      unitPriceGross: (json['unitPriceGross'] as num).toDouble(),
      unitPriceNet: (json['unitPriceNet'] as num).toDouble(),
      customization: (json['customization'] as num).toInt(),
      tax: Tax.fromJson(json['tax'] as Map<String, dynamic>),
      wholesalePrice: (json['wholesalePrice'] as num).toDouble(),
      discountGross: (json['discountGross'] as num).toDouble(),
      discountGrossUnit: (json['discountGrossUnit'] as num).toDouble(),
      discountNetUnit: (json['discountNetUnit'] as num).toDouble(),
      discountNet: (json['discountNet'] as num).toDouble(),
      discountPercent: (json['discountPercent'] as num).toDouble(),
      discountPercentAmountGrossUnit:
          (json['discountPercentAmountGrossUnit'] as num).toDouble(),
      discountPercentAmountNetUnit:
          (json['discountPercentAmountNetUnit'] as num).toDouble(),
      profitUnit: (json['profitUnit'] as num).toDouble(),
      profit: (json['profit'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      isFromDatabase: json['isFromDatabase'] as bool,
    );

Map<String, dynamic> _$ReceiptProductToJson(ReceiptProduct instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productAttributeId': instance.productAttributeId,
      'quantity': instance.quantity,
      'shippedQuantity': instance.shippedQuantity,
      'name': instance.name,
      'articleNumber': instance.articleNumber,
      'ean': instance.ean,
      'price': instance.price,
      'unitPriceGross': instance.unitPriceGross,
      'unitPriceNet': instance.unitPriceNet,
      'customization': instance.customization,
      'tax': instance.tax.toJson(),
      'wholesalePrice': instance.wholesalePrice,
      'discountGrossUnit': instance.discountGrossUnit,
      'discountNetUnit': instance.discountNetUnit,
      'discountGross': instance.discountGross,
      'discountNet': instance.discountNet,
      'discountPercent': instance.discountPercent,
      'discountPercentAmountGrossUnit': instance.discountPercentAmountGrossUnit,
      'discountPercentAmountNetUnit': instance.discountPercentAmountNetUnit,
      'profitUnit': instance.profitUnit,
      'profit': instance.profit,
      'weight': instance.weight,
      'isFromDatabase': instance.isFromDatabase,
    };
