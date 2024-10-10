// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incoming_invoice_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncomingInvoiceItem _$IncomingInvoiceItemFromJson(Map<String, dynamic> json) =>
    IncomingInvoiceItem(
      id: json['id'] as String,
      sortId: (json['sort_id'] as num).toInt(),
      accountNumber: json['account_number'] as String,
      accountName: json['account_name'] as String,
      title: json['title'] as String,
      quantity: (json['quantity'] as num).toInt(),
      unitPriceNet: (json['unit_price_net'] as num).toDouble(),
      taxRate: (json['tax_rate'] as num).toInt(),
      discountType: $enumDecode(_$DiscountTypeEnumMap, json['discount_type']),
      discount: (json['discount'] as num).toDouble(),
    );

Map<String, dynamic> _$IncomingInvoiceItemToJson(
        IncomingInvoiceItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sort_id': instance.sortId,
      'account_number': instance.accountNumber,
      'account_name': instance.accountName,
      'title': instance.title,
      'quantity': instance.quantity,
      'unit_price_net': instance.unitPriceNet,
      'tax_rate': instance.taxRate,
      'discount_type': _$DiscountTypeEnumMap[instance.discountType]!,
      'discount': instance.discount,
    };

const _$DiscountTypeEnumMap = {
  DiscountType.percentage: 'percentage',
  DiscountType.amount: 'amount',
};
