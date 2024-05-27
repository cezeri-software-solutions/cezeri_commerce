// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Client _$ClientFromJson(Map<String, dynamic> json) => Client(
      id: json['id'] as String,
      ownerId: json['owner_id'] as String,
      email: json['email'] as String,
      gender: $enumDecode(_$GenderEnumMap, json['gender']),
      companyName: json['company_name'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      tel1: json['tel1'] as String,
      tel2: json['tel2'] as String,
      street: json['street'] as String,
      postCode: json['post_code'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
      clientType: $enumDecode(_$ClientTypeEnumMap, json['client_type']),
      clientRights: $enumDecode(_$ClientRightsEnumMap, json['client_rights']),
      creationDate: DateTime.parse(json['creation_date'] as String),
      lastEditingDate: DateTime.parse(json['last_editing_date'] as String),
    );

Map<String, dynamic> _$ClientToJson(Client instance) => <String, dynamic>{
      'id': instance.id,
      'owner_id': instance.ownerId,
      'email': instance.email,
      'gender': _$GenderEnumMap[instance.gender]!,
      'company_name': instance.companyName,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'tel1': instance.tel1,
      'tel2': instance.tel2,
      'street': instance.street,
      'post_code': instance.postCode,
      'city': instance.city,
      'country': instance.country,
      'client_type': _$ClientTypeEnumMap[instance.clientType]!,
      'client_rights': _$ClientRightsEnumMap[instance.clientRights]!,
    };

const _$GenderEnumMap = {
  Gender.empty: 'empty',
  Gender.male: 'male',
  Gender.female: 'female',
};

const _$ClientTypeEnumMap = {
  ClientType.employee: 'employee',
  ClientType.user: 'user',
  ClientType.admin: 'admin',
};

const _$ClientRightsEnumMap = {
  ClientRights.level3: 'level3',
  ClientRights.level2: 'level2',
  ClientRights.level1: 'level1',
};
