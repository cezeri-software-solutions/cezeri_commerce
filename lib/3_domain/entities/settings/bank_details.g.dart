// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankDetails _$BankDetailsFromJson(Map<String, dynamic> json) => BankDetails(
      json['bankName'] as String,
      json['bankIban'] as String,
      json['bankBic'] as String,
      json['paypalEmail'] as String,
    );

Map<String, dynamic> _$BankDetailsToJson(BankDetails instance) =>
    <String, dynamic>{
      'bankName': instance.bankName,
      'bankIban': instance.bankIban,
      'bankBic': instance.bankBic,
      'paypalEmail': instance.paypalEmail,
    };
