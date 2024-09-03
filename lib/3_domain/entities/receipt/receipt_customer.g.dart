// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReceiptCustomer _$ReceiptCustomerFromJson(Map<String, dynamic> json) =>
    ReceiptCustomer(
      id: json['id'] as String,
      customerNumber: (json['customerNumber'] as num).toInt(),
      company: json['company'] as String?,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      gender: $enumDecode(_$GenderEnumMap, json['gender']),
      birthday: json['birthday'] as String,
      phone: json['phone'] as String,
      phoneMobile: json['phoneMobile'] as String,
      listOfAddress: (json['listOfAddress'] as List<dynamic>)
          .map((e) => Address.fromJson(e as Map<String, dynamic>))
          .toList(),
      uidNumber: json['uidNumber'] as String,
      taxNumber: json['taxNumber'] as String,
    );

Map<String, dynamic> _$ReceiptCustomerToJson(ReceiptCustomer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerNumber': instance.customerNumber,
      'company': instance.company,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'name': instance.name,
      'email': instance.email,
      'gender': _$GenderEnumMap[instance.gender]!,
      'birthday': instance.birthday,
      'phone': instance.phone,
      'phoneMobile': instance.phoneMobile,
      'listOfAddress': instance.listOfAddress.map((e) => e.toJson()).toList(),
      'uidNumber': instance.uidNumber,
      'taxNumber': instance.taxNumber,
    };

const _$GenderEnumMap = {
  Gender.empty: 'empty',
  Gender.male: 'male',
  Gender.female: 'female',
};
