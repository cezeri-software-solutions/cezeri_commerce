// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reorder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reorder _$ReorderFromJson(Map<String, dynamic> json) => Reorder(
      id: json['id'] as String,
      reorderNumber: (json['reorderNumber'] as num).toInt(),
      reorderNumberInternal: json['reorderNumberInternal'] as String,
      closedManually: json['closedManually'] as bool,
      reorderStatus: $enumDecode(_$ReorderStatusEnumMap, json['reorderStatus']),
      reorderSupplier: ReorderSupplier.fromJson(
          json['reorderSupplier'] as Map<String, dynamic>),
      listOfReorderProducts: (json['listOfReorderProducts'] as List<dynamic>)
          .map((e) => ReorderProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      tax: Tax.fromJson(json['tax'] as Map<String, dynamic>),
      currency: json['currency'] as String,
      shippingPriceNet: (json['shippingPriceNet'] as num).toDouble(),
      additionalAmountNet: (json['additionalAmountNet'] as num).toDouble(),
      discountAmountNet: (json['discountAmountNet'] as num).toDouble(),
      discountPercent: (json['discountPercent'] as num).toDouble(),
      creationDate: DateTime.parse(json['creationDate'] as String),
      deliveryDate: json['deliveryDate'] == null
          ? null
          : DateTime.parse(json['deliveryDate'] as String),
      lastEditingDate: DateTime.parse(json['lastEditingDate'] as String),
    );

Map<String, dynamic> _$ReorderToJson(Reorder instance) => <String, dynamic>{
      'reorderNumber': instance.reorderNumber,
      'reorderNumberInternal': instance.reorderNumberInternal,
      'closedManually': instance.closedManually,
      'reorderStatus': _$ReorderStatusEnumMap[instance.reorderStatus]!,
      'reorderSupplier': instance.reorderSupplier.toJson(),
      'listOfReorderProducts':
          instance.listOfReorderProducts.map((e) => e.toJson()).toList(),
      'tax': instance.tax.toJson(),
      'currency': instance.currency,
      'shippingPriceNet': instance.shippingPriceNet,
      'additionalAmountNet': instance.additionalAmountNet,
      'discountAmountNet': instance.discountAmountNet,
      'discountPercent': instance.discountPercent,
      'creationDate': instance.creationDate.toIso8601String(),
      'deliveryDate': instance.deliveryDate?.toIso8601String(),
      'lastEditingDate': instance.lastEditingDate.toIso8601String(),
    };

const _$ReorderStatusEnumMap = {
  ReorderStatus.open: 'open',
  ReorderStatus.partiallyCompleted: 'partiallyCompleted',
  ReorderStatus.completed: 'completed',
};
