// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stat_product_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatProductDetail _$StatProductDetailFromJson(Map<String, dynamic> json) =>
    StatProductDetail(
      id: json['id'] as String,
      productId: json['productId'] as String,
      receiptTyp: $enumDecode(_$ReceiptTypeEnumMap, json['receiptTyp']),
      receiptId: json['receiptId'] as String,
      uniqueReceiptId: json['uniqueReceiptId'] as String,
      receiptNumber: (json['receiptNumber'] as num).toInt(),
      profit: (json['profit'] as num).toDouble(),
      profitUnit: (json['profitUnit'] as num).toDouble(),
      unitPriceNet: (json['unitPriceNet'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      creationDate: DateTime.parse(json['creationDate'] as String),
    );

Map<String, dynamic> _$StatProductDetailToJson(StatProductDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'receiptTyp': _$ReceiptTypeEnumMap[instance.receiptTyp]!,
      'receiptId': instance.receiptId,
      'uniqueReceiptId': instance.uniqueReceiptId,
      'receiptNumber': instance.receiptNumber,
      'profit': instance.profit,
      'profitUnit': instance.profitUnit,
      'unitPriceNet': instance.unitPriceNet,
      'quantity': instance.quantity,
      'creationDate': instance.creationDate.toIso8601String(),
    };

const _$ReceiptTypeEnumMap = {
  ReceiptType.appointment: 'appointment',
  ReceiptType.offer: 'offer',
  ReceiptType.deliveryNote: 'deliveryNote',
  ReceiptType.invoice: 'invoice',
  ReceiptType.credit: 'credit',
};
