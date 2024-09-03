// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      id: json['id'] as String,
      companyName: json['companyName'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      street: json['street'] as String,
      street2: json['street2'] as String,
      postcode: json['postcode'] as String,
      city: json['city'] as String,
      country: Country.fromJson(json['country'] as Map<String, dynamic>),
      phone: json['phone'] as String,
      phoneMobile: json['phoneMobile'] as String,
      addressType: $enumDecode(_$AddressTypeEnumMap, json['addressType']),
      isDefault: json['isDefault'] as bool,
      creationDate: DateTime.parse(json['creationDate'] as String),
      lastEditingDate: DateTime.parse(json['lastEditingDate'] as String),
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'id': instance.id,
      'companyName': instance.companyName,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'street': instance.street,
      'street2': instance.street2,
      'postcode': instance.postcode,
      'city': instance.city,
      'country': instance.country.toJson(),
      'phone': instance.phone,
      'phoneMobile': instance.phoneMobile,
      'addressType': _$AddressTypeEnumMap[instance.addressType]!,
      'isDefault': instance.isDefault,
      'creationDate': instance.creationDate.toIso8601String(),
      'lastEditingDate': instance.lastEditingDate.toIso8601String(),
    };

const _$AddressTypeEnumMap = {
  AddressType.invoice: 'invoice',
  AddressType.delivery: 'delivery',
};
