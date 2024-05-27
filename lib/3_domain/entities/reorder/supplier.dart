import 'package:json_annotation/json_annotation.dart';

import '../country.dart';
import '../settings/tax.dart';

part 'supplier.g.dart';

@JsonSerializable(explicitToJson: true)
class Supplier {
  @JsonKey(includeToJson: false)
  final String id;
  final int supplierNumber;
  final String company;
  final String firstName;
  final String lastName;
  final String name;
  final String street;
  final String street2;
  final String postcode;
  final String city;
  final Country country;
  final String email;
  final String homepage;
  final String phone;
  final String phoneMobile;
  final String uidNumber;
  final String taxNumber;
  final Tax tax;
  final DateTime creationDate;
  final DateTime lastEditingDate;

  Supplier({
    required this.id,
    required this.supplierNumber,
    required this.company,
    required this.firstName,
    required this.lastName,
    required this.street,
    required this.street2,
    required this.postcode,
    required this.city,
    required this.country,
    required this.email,
    required this.homepage,
    required this.phone,
    required this.phoneMobile,
    required this.uidNumber,
    required this.taxNumber,
    required this.tax,
    required this.creationDate,
    required this.lastEditingDate,
  }) : name = '$firstName $lastName';

  factory Supplier.fromJson(Map<String, dynamic> json) => _$SupplierFromJson(json);
  Map<String, dynamic> toJson() => _$SupplierToJson(this);

  factory Supplier.empty() {
    return Supplier(
      id: '',
      supplierNumber: 0,
      company: '',
      firstName: '',
      lastName: '',
      street: '',
      street2: '',
      postcode: '',
      city: '',
      country: Country.empty(),
      email: '',
      homepage: '',
      phone: '',
      phoneMobile: '',
      uidNumber: '',
      taxNumber: '',
      tax: Tax.empty(),
      creationDate: DateTime.now(),
      lastEditingDate: DateTime.now(),
    );
  }

  Supplier copyWith({
    String? id,
    int? supplierNumber,
    String? company,
    String? firstName,
    String? lastName,
    String? street,
    String? street2,
    String? postcode,
    String? city,
    Country? country,
    String? email,
    String? homepage,
    String? phone,
    String? phoneMobile,
    String? uidNumber,
    String? taxNumber,
    Tax? tax,
    DateTime? creationDate,
    DateTime? lastEditingDate,
  }) {
    return Supplier(
      id: id ?? this.id,
      supplierNumber: supplierNumber ?? this.supplierNumber,
      company: company ?? this.company,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      street: street ?? this.street,
      street2: street2 ?? this.street2,
      postcode: postcode ?? this.postcode,
      city: city ?? this.city,
      country: country ?? this.country,
      email: email ?? this.email,
      homepage: homepage ?? this.homepage,
      phone: phone ?? this.phone,
      phoneMobile: phoneMobile ?? this.phoneMobile,
      uidNumber: uidNumber ?? this.uidNumber,
      taxNumber: taxNumber ?? this.taxNumber,
      tax: tax ?? this.tax,
      creationDate: creationDate ?? this.creationDate,
      lastEditingDate: lastEditingDate ?? this.lastEditingDate,
    );
  }

  @override
  String toString() {
    return 'Supplier(id: $id, supplierNumber: $supplierNumber, company: $company, firstName: $firstName, lastName: $lastName, street: $street, street2: $street2, postcode: $postcode, city: $city, country: $country, email: $email, homepage: $homepage, phone: $phone, phoneMobile: $phoneMobile, uidNumber: $uidNumber, taxNumber: $taxNumber, tax: $tax, creationDate: $creationDate, lastEditingDate: $lastEditingDate)';
  }
}
