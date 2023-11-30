// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stat_product_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatProductDetail _$StatProductDetailFromJson(Map<String, dynamic> json) =>
    StatProductDetail(
      receiptTyp: $enumDecode(_$ReceiptTypEnumMap, json['receiptTyp']),
      receiptId: json['receiptId'] as String,
      uniqueReceiptId: json['uniqueReceiptId'] as String,
      profit: (json['profit'] as num).toDouble(),
      profitUnit: (json['profitUnit'] as num).toDouble(),
      unitPriceNet: (json['unitPriceNet'] as num).toDouble(),
      quantity: json['quantity'] as int,
    );

Map<String, dynamic> _$StatProductDetailToJson(StatProductDetail instance) =>
    <String, dynamic>{
      'receiptTyp': _$ReceiptTypEnumMap[instance.receiptTyp]!,
      'receiptId': instance.receiptId,
      'uniqueReceiptId': instance.uniqueReceiptId,
      'profit': instance.profit,
      'profitUnit': instance.profitUnit,
      'unitPriceNet': instance.unitPriceNet,
      'quantity': instance.quantity,
    };

const _$ReceiptTypEnumMap = {
  ReceiptTyp.appointment: 'appointment',
  ReceiptTyp.offer: 'offer',
  ReceiptTyp.deliveryNote: 'deliveryNote',
  ReceiptTyp.invoice: 'invoice',
  ReceiptTyp.credit: 'credit',
};
