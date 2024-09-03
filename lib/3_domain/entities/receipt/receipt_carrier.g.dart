// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_carrier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReceiptCarrier _$ReceiptCarrierFromJson(Map<String, dynamic> json) =>
    ReceiptCarrier(
      receiptCarrierName: json['receiptCarrierName'] as String,
      carrierTyp: $enumDecode(_$CarrierTypEnumMap, json['carrierTyp']),
      carrierProduct: CarrierProduct.fromJson(
          json['carrierProduct'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReceiptCarrierToJson(ReceiptCarrier instance) =>
    <String, dynamic>{
      'receiptCarrierName': instance.receiptCarrierName,
      'carrierTyp': _$CarrierTypEnumMap[instance.carrierTyp]!,
      'carrierProduct': instance.carrierProduct.toJson(),
    };

const _$CarrierTypEnumMap = {
  CarrierTyp.empty: 'empty',
  CarrierTyp.austrianPost: 'austrianPost',
  CarrierTyp.dpd: 'dpd',
};
