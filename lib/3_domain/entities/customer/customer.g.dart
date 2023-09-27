// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      id: json['id'] as String,
      customerMarketplace: json['customerMarketplace'] == null
          ? null
          : CustomerMarketplace.fromJson(
              json['customerMarketplace'] as Map<String, dynamic>),
      company: json['company'] as String?,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      gender: $enumDecode(_$GenderEnumMap, json['gender']),
      birthday: json['birthday'] as String,
      isNewsletterAccepted: json['isNewsletterAccepted'] as bool,
      isGuest: json['isGuest'] as bool,
      listOfAddress: (json['listOfAddress'] as List<dynamic>)
          .map((e) => Address.fromJson(e as Map<String, dynamic>))
          .toList(),
      creationDate: DateTime.parse(json['creationDate'] as String),
      lastEditingDate: DateTime.parse(json['lastEditingDate'] as String),
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'id': instance.id,
      'customerMarketplace': instance.customerMarketplace?.toJson(),
      'company': instance.company,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'name': instance.name,
      'email': instance.email,
      'gender': _$GenderEnumMap[instance.gender]!,
      'birthday': instance.birthday,
      'isNewsletterAccepted': instance.isNewsletterAccepted,
      'isGuest': instance.isGuest,
      'listOfAddress': instance.listOfAddress.map((e) => e.toJson()).toList(),
      'creationDate': instance.creationDate.toIso8601String(),
      'lastEditingDate': instance.lastEditingDate.toIso8601String(),
    };

const _$GenderEnumMap = {
  Gender.empty: 'empty',
  Gender.male: 'male',
  Gender.female: 'female',
};
