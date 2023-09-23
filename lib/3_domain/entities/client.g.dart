// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Client _$ClientFromJson(Map<String, dynamic> json) => Client(
      id: json['id'] as String,
      email: json['email'] as String,
      gender: $enumDecode(_$GenderEnumMap, json['gender']),
      companyName: json['companyName'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      name: json['name'] as String,
      tel1: json['tel1'] as String,
      tel2: json['tel2'] as String,
      street: json['street'] as String,
      postCode: json['postCode'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
      creationDate: DateTime.parse(json['creationDate'] as String),
      lastEditingDate: DateTime.parse(json['lastEditingDate'] as String),
    );

Map<String, dynamic> _$ClientToJson(Client instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'gender': _$GenderEnumMap[instance.gender]!,
      'companyName': instance.companyName,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'name': instance.name,
      'tel1': instance.tel1,
      'tel2': instance.tel2,
      'street': instance.street,
      'postCode': instance.postCode,
      'city': instance.city,
      'country': instance.country,
      'creationDate': instance.creationDate.toIso8601String(),
      'lastEditingDate': instance.lastEditingDate.toIso8601String(),
    };

const _$GenderEnumMap = {
  Gender.empty: 'empty',
  Gender.male: 'male',
  Gender.female: 'female',
};
