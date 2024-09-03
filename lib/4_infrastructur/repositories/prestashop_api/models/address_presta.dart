import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'address_presta.g.dart';

@JsonSerializable()
class AddressesPresta {
  static const _encoder = JsonEncoder.withIndent('  ');

  @JsonKey(name: 'addresses')
  final List<AddressPresta> items;

  const AddressesPresta({required this.items});

  factory AddressesPresta.fromJson(Map<String, dynamic> json) => _$AddressesPrestaFromJson(json);
  Map<String, dynamic> toJson() => _$AddressesPrestaToJson(this);

  List<Object?> get props => [items];

  @override
  String toString() => _encoder.convert(toJson());
}

@JsonSerializable()
class AddressPresta {
  static const _encoder = JsonEncoder.withIndent('  ');

  final int id;
  @JsonKey(name: 'id_customer')
  final String idCustomer;
  @JsonKey(name: 'id_manufacturer')
  final String idManufacturer;
  @JsonKey(name: 'id_supplier')
  final String idSupplier;
  @JsonKey(name: 'id_warehouse')
  final String idWarehouse;
  @JsonKey(name: 'id_country')
  final String idCountry;
  @JsonKey(name: 'id_state')
  final String idState;
  final String alias;
  final String company;
  final String lastname;
  final String firstname;
  @JsonKey(name: 'vat_number')
  final String vatNumber;
  final String address1;
  final String address2;
  final String postcode;
  final String city;
  final String other;
  final String phone;
  @JsonKey(name: 'phone_mobile')
  final String phoneMobile;
  final String dni;
  final String deleted;
  @JsonKey(name: 'date_add')
  final String dateAdd;
  @JsonKey(name: 'date_upd')
  final String dateUpd;

  const AddressPresta({
    required this.id,
    required this.idCustomer,
    required this.idManufacturer,
    required this.idSupplier,
    required this.idWarehouse,
    required this.idCountry,
    required this.idState,
    required this.alias,
    required this.company,
    required this.lastname,
    required this.firstname,
    required this.vatNumber,
    required this.address1,
    required this.address2,
    required this.postcode,
    required this.city,
    required this.other,
    required this.phone,
    required this.phoneMobile,
    required this.dni,
    required this.deleted,
    required this.dateAdd,
    required this.dateUpd,
  });

  factory AddressPresta.fromJson(Map<String, dynamic> json) => _$AddressPrestaFromJson(json);
  Map<String, dynamic> toJson() => _$AddressPrestaToJson(this);

  List<Object?> get props => [id];

  @override
  String toString() => _encoder.convert(toJson());
}
