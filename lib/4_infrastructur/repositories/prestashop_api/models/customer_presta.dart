import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'customer_presta.g.dart';

@JsonSerializable()
class CustomersPresta {
  static const _encoder = JsonEncoder.withIndent('  ');

  @JsonKey(name: 'customers')
  final List<CustomerPresta> items;

  const CustomersPresta({required this.items});

  factory CustomersPresta.fromJson(Map<String, dynamic> json) => _$CustomersPrestaFromJson(json);
  Map<String, dynamic> toJson() => _$CustomersPrestaToJson(this);

  List<Object?> get props => [items];

  @override
  String toString() => _encoder.convert(toJson());
}

@JsonSerializable()
class CustomerPresta {
  static const _encoder = JsonEncoder.withIndent('  ');

  final int id;
  @JsonKey(name: 'id_default_group')
  final String idDefaultGroup;
  @JsonKey(name: 'id_lang')
  final String idLang;
  @JsonKey(name: 'newsletter_date_add')
  final String newsletterDateAdd;
  @JsonKey(name: 'ip_registration_newsletter')
  final String? ipRegistrationNewsletter;
  @JsonKey(name: 'last_passwd_gen')
  final String lastPasswdGen;
  @JsonKey(name: 'secure_key')
  final String secureKey;
  final String deleted;
  final String passwd;
  final String lastname;
  final String firstname;
  final String email;
  @JsonKey(name: 'id_gender')
  final String idGender;
  final String birthday;
  final String newsletter;
  final String optin;
  final String? website;
  final String? company;
  final String? siret;
  final String? ape;
  @JsonKey(name: 'outstanding_allow_amount')
  final String outstandingAllowAmount;
  @JsonKey(name: 'show_public_prices')
  final String showPublicPrices;
  @JsonKey(name: 'id_risk')
  final String idRisk;
  @JsonKey(name: 'max_payment_days')
  final String maxPaymentDays;
  final String active;
  final String? note;
  @JsonKey(name: 'is_guest')
  final String isGuest;
  @JsonKey(name: 'id_shop')
  final String idShop;
  @JsonKey(name: 'id_shop_group')
  final String idShopGroup;
  @JsonKey(name: 'date_add')
  final String dateAdd;
  @JsonKey(name: 'date_upd')
  final String dateUpd;
  @JsonKey(name: 'reset_password_token')
  final String? resetPasswordToken;
  @JsonKey(name: 'reset_password_validity')
  final String resetPasswordValidity;
  final AssociationsCustomer associations;

  CustomerPresta({
    required this.id,
    required this.idDefaultGroup,
    required this.idLang,
    required this.newsletterDateAdd,
    this.ipRegistrationNewsletter,
    required this.lastPasswdGen,
    required this.secureKey,
    required this.deleted,
    required this.passwd,
    required this.lastname,
    required this.firstname,
    required this.email,
    required this.idGender,
    required this.birthday,
    required this.newsletter,
    required this.optin,
    this.website,
    this.company,
    this.siret,
    this.ape,
    required this.outstandingAllowAmount,
    required this.showPublicPrices,
    required this.idRisk,
    required this.maxPaymentDays,
    required this.active,
    this.note,
    required this.isGuest,
    required this.idShop,
    required this.idShopGroup,
    required this.dateAdd,
    required this.dateUpd,
    this.resetPasswordToken,
    required this.resetPasswordValidity,
    required this.associations,
  });

  factory CustomerPresta.fromJson(Map<String, dynamic> json) => _$CustomerPrestaFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerPrestaToJson(this);

  List<Object?> get props => [id];

  @override
  String toString() => _encoder.convert(toJson());
}

@JsonSerializable()
class AssociationsCustomer {
  static const _encoder = JsonEncoder.withIndent('  ');

  final List<GroupId> groups;

  AssociationsCustomer({required this.groups});

  factory AssociationsCustomer.fromJson(Map<String, dynamic> json) => _$AssociationsCustomerFromJson(json);
  Map<String, dynamic> toJson() => _$AssociationsCustomerToJson(this);

  List<Object?> get props => [groups];

  @override
  String toString() => _encoder.convert(toJson());
}

@JsonSerializable()
class GroupId {
  final String id;

  GroupId({required this.id});

  factory GroupId.fromJson(Map<String, dynamic> json) => _$GroupIdFromJson(json);
  Map<String, dynamic> toJson() => _$GroupIdToJson(this);
}
