import 'package:json_annotation/json_annotation.dart';

import '../enums/enums.dart';

part 'client.g.dart';

enum ClientType { employee, user, admin }

enum ClientRights { level3, level2, level1 }

@JsonSerializable(explicitToJson: true)
class Client {
  final String id;
  final String ownerId;
  final String email;
  final Gender gender;
  final String companyName;
  final String firstName;
  final String lastName;
  final String name;
  final String tel1;
  final String tel2;
  final String street;
  final String postCode;
  final String city;
  final String country;
  final ClientType clientType;
  final ClientRights clientRights;
  final DateTime creationDate;
  final DateTime lastEditingDate;

  Client({
    required this.id,
    required this.ownerId,
    required this.email,
    required this.gender,
    required this.companyName,
    required this.firstName,
    required this.lastName,
    required this.name,
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
  });

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
      name: '',
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
    String? name,
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
      name: name ?? this.name,
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
  String toString() {
    return 'Client(id: $id, ownerId: $ownerId, email: $email, gender: $gender, companyName: $companyName, firstName: $firstName, lastName: $lastName, name: $name, tel1: $tel1, tel2: $tel2, street: $street, postCode: $postCode, city: $city, country: $country, clientType: $clientType, clientRights: $clientRights, creationDate: $creationDate, lastEditingDate: $lastEditingDate)';
  }
}
