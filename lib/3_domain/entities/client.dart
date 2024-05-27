import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../enums/enums.dart';

part 'client.g.dart';

enum ClientType { employee, user, admin }

enum ClientRights { level3, level2, level1 }

@JsonSerializable(explicitToJson: true)
class Client extends Equatable {
  final String id;
  @JsonKey(name: 'owner_id')
  final String ownerId;
  final String email;
  final Gender gender;
  @JsonKey(name: 'company_name')
  final String companyName;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  final String name;
  final String tel1;
  final String tel2;
  final String street;
  @JsonKey(name: 'post_code')
  final String postCode;
  final String city;
  final String country;
  @JsonKey(name: 'client_type')
  final ClientType clientType;
  @JsonKey(name: 'client_rights')
  final ClientRights clientRights;
  @JsonKey(name: 'creation_date', includeToJson: false)
  final DateTime creationDate;
  @JsonKey(name: 'last_editing_date', includeToJson: false)
  final DateTime lastEditingDate;

  const Client({
    required this.id,
    required this.ownerId,
    required this.email,
    required this.gender,
    required this.companyName,
    required this.firstName,
    required this.lastName,
    required this.tel1,
    required this.tel2,
    required this.street,
    required this.postCode,
    required this.city,
    required this.country,
    required this.clientType,
    required this.clientRights,
    required this.creationDate,
    required this.lastEditingDate,
  }) : name = '$firstName $lastName';

  // static dynamic _creationDateFromJson(json) => DateTime.parse(json['creation_date'] as String);
  // static dynamic _lastEditingDateFromJson(json) => DateTime.parse(json['last_editing_date'] as String);


  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);

  Map<String, dynamic> toJson() => _$ClientToJson(this);

  factory Client.empty() {
    return Client(
      id: '',
      ownerId: '',
      email: '',
      gender: Gender.empty,
      companyName: '',
      firstName: '',
      lastName: '',
      tel1: '',
      tel2: '',
      street: '',
      postCode: '',
      city: '',
      country: '',
      clientType: ClientType.employee,
      clientRights: ClientRights.level3,
      creationDate: DateTime.now(),
      lastEditingDate: DateTime.now(),
    );
  }

  Client copyWith({
    String? id,
    String? ownerId,
    String? email,
    Gender? gender,
    String? companyName,
    String? firstName,
    String? lastName,
    String? tel1,
    String? tel2,
    String? street,
    String? postCode,
    String? city,
    String? country,
    ClientType? clientType,
    ClientRights? clientRights,
    DateTime? creationDate,
    DateTime? lastEditingDate,
  }) {
    return Client(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      companyName: companyName ?? this.companyName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      tel1: tel1 ?? this.tel1,
      tel2: tel2 ?? this.tel2,
      street: street ?? this.street,
      postCode: postCode ?? this.postCode,
      city: city ?? this.city,
      country: country ?? this.country,
      clientType: clientType ?? this.clientType,
      clientRights: clientRights ?? this.clientRights,
      creationDate: creationDate ?? this.creationDate,
      lastEditingDate: lastEditingDate ?? this.lastEditingDate,
    );
  }

  @override
  List<Object?> get props => [id];

  // @override
  // bool get stringify => true;
}
