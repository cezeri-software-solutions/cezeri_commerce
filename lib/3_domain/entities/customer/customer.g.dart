// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      id: json['id'] as String,
      customerNumber: (json['customerNumber'] as num).toInt(),
      customerMarketplace: json['customerMarketplace'] == null
          ? null
          : CustomerMarketplace.fromJson(
              json['customerMarketplace'] as Map<String, dynamic>),
      company: json['company'] as String?,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      gender: $enumDecode(_$GenderEnumMap, json['gender']),
      birthday: json['birthday'] as String,
      phone: json['phone'] as String,
      phoneMobile: json['phoneMobile'] as String,
      listOfAddress: (json['listOfAddress'] as List<dynamic>)
          .map((e) => Address.fromJson(e as Map<String, dynamic>))
          .toList(),
      customerInvoiceType: $enumDecode(
          _$CustomerInvoiceTypeEnumMap, json['customerInvoiceType']),
      uidNumber: json['uidNumber'] as String,
      taxNumber: json['taxNumber'] as String,
      tax: Tax.fromJson(json['tax'] as Map<String, dynamic>),
      creationDate: DateTime.parse(json['creationDate'] as String),
      lastEditingDate: DateTime.parse(json['lastEditingDate'] as String),
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'customerNumber': instance.customerNumber,
      'customerMarketplace': instance.customerMarketplace?.toJson(),
      'company': instance.company,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'gender': _$GenderEnumMap[instance.gender]!,
      'birthday': instance.birthday,
      'phone': instance.phone,
      'phoneMobile': instance.phoneMobile,
      'listOfAddress': instance.listOfAddress.map((e) => e.toJson()).toList(),
      'customerInvoiceType':
          _$CustomerInvoiceTypeEnumMap[instance.customerInvoiceType]!,
      'uidNumber': instance.uidNumber,
      'taxNumber': instance.taxNumber,
      'tax': instance.tax.toJson(),
      'creationDate': instance.creationDate.toIso8601String(),
      'lastEditingDate': instance.lastEditingDate.toIso8601String(),
    };

const _$GenderEnumMap = {
  Gender.empty: 'empty',
  Gender.male: 'male',
  Gender.female: 'female',
};

const _$CustomerInvoiceTypeEnumMap = {
  CustomerInvoiceType.standardInvoice: 'standardInvoice',
  CustomerInvoiceType.collectiveInvoice: 'collectiveInvoice',
};
