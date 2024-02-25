import 'package:cezeri_commerce/3_domain/entities/id.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../4_infrastructur/repositories/prestashop_api/models/address_presta.dart';
import '../../4_infrastructur/repositories/prestashop_api/models/country_presta.dart';
import 'country.dart';

part 'address.g.dart';

enum AddressType { invoice, delivery }

@JsonSerializable(explicitToJson: true)
class Address extends Equatable {
  final String id;
  final String companyName;
  final String firstName;
  final String lastName;
  final String name;
  final String street;
  final String street2;
  final String postcode;
  final String city;
  final Country country;
  final String phone;
  final String phoneMobile;
  final AddressType addressType;
  final bool isDefault;
  final DateTime creationDate;
  final DateTime lastEditingDate;

  const Address({
    required this.id,
    required this.companyName,
    required this.firstName,
    required this.lastName,
    required this.name,
    required this.street,
    required this.street2,
    required this.postcode,
    required this.city,
    required this.country,
    required this.phone,
    required this.phoneMobile,
    required this.addressType,
    required this.isDefault,
    required this.creationDate,
    required this.lastEditingDate,
  });

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);

  factory Address.empty() {
    return Address(
      id: '',
      companyName: '',
      firstName: '',
      lastName: '',
      name: '',
      street: '',
      street2: '',
      postcode: '',
      city: '',
      country: Country.empty(),
      phone: '',
      phoneMobile: '',
      addressType: AddressType.delivery,
      isDefault: false,
      creationDate: DateTime.now(),
      lastEditingDate: DateTime.now(),
    );
  }

  factory Address.fromPresta(AddressPresta addressPresta, CountryPresta countryPresta, AddressType addressType) {
    return Address(
      id: UniqueID().value,
      companyName: addressPresta.company,
      firstName: addressPresta.firstname,
      lastName: addressPresta.lastname,
      name: '${addressPresta.firstname} ${addressPresta.lastname}',
      street: addressPresta.address1,
      street2: addressPresta.address2,
      postcode: addressPresta.postcode,
      city: addressPresta.city,
      country: Country.countryList.where((e) => e.isoCode.toUpperCase() == countryPresta.isoCode.toUpperCase()).first,
      phone: addressPresta.phone,
      phoneMobile: addressPresta.phoneMobile,
      addressType: addressType,
      isDefault: true,
      creationDate: DateTime.now(),
      lastEditingDate: DateTime.now(),
    );
  }

  Address copyWith({
    String? id,
    String? companyName,
    String? firstName,
    String? lastName,
    String? name,
    String? street,
    String? street2,
    String? postcode,
    String? city,
    Country? country,
    String? phone,
    String? phoneMobile,
    AddressType? addressType,
    bool? isDefault,
    DateTime? creationDate,
    DateTime? lastEditingDate,
  }) {
    return Address(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      name: name ?? this.name,
      street: street ?? this.street,
      street2: street2 ?? this.street2,
      postcode: postcode ?? this.postcode,
      city: city ?? this.city,
      country: country ?? this.country,
      phone: phone ?? this.phone,
      phoneMobile: phoneMobile ?? this.phoneMobile,
      addressType: addressType ?? this.addressType,
      isDefault: isDefault ?? this.isDefault,
      creationDate: creationDate ?? this.creationDate,
      lastEditingDate: lastEditingDate ?? this.lastEditingDate,
    );
  }

  @override
  String toString() {
    return 'Address(id: $id, companyName: $companyName, firstName: $firstName, lastName: $lastName, name: $name, street: $street, street2: $street2, postcode: $postcode, city: $city, country: $country, phone: $phone, phoneMobile: $phoneMobile, addressType: $addressType, isDefault: $isDefault, creationDate: $creationDate, lastEditingDate: $lastEditingDate)';
  }

  @override
  List<Object> get props {
    return [
      companyName,
      firstName,
      lastName,
      name,
      street,
      street2,
      postcode,
      city,
      phone,
      phoneMobile,
      addressType,
    ];
  }
}
