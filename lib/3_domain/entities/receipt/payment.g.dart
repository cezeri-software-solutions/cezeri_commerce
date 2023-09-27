// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
      (json['paidAmount'] as num).toDouble(),
      json['comment'] as String,
      DateTime.parse(json['dateOfPay'] as String),
    );

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'paidAmount': instance.paidAmount,
      'comment': instance.comment,
      'dateOfPay': instance.dateOfPay.toIso8601String(),
    };
