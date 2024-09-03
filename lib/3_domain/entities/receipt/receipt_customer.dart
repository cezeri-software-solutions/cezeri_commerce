import 'package:json_annotation/json_annotation.dart';

import '../../enums/enums.dart';
import '../address.dart';
import '../customer/customer.dart';

part 'receipt_customer.g.dart';

@JsonSerializable(explicitToJson: true)
class ReceiptCustomer {
  final String id;
  final int customerNumber;
  final String? company;
  final String firstName;
  final String lastName;
  final String name;
  final String email;
  final Gender gender;
  final String birthday;
  final String phone;
  final String phoneMobile;
  final List<Address> listOfAddress;
  final String uidNumber;
  final String taxNumber;

  ReceiptCustomer({
    required this.id,
    required this.customerNumber,
    required this.company,
    required this.firstName,
    required this.lastName,
    required this.name,
    required this.email,
    required this.gender,
    required this.birthday,
    required this.phone,
    required this.phoneMobile,
    required this.listOfAddress,
    required this.uidNumber,
    required this.taxNumber,
  });

  factory ReceiptCustomer.fromJson(Map<String, dynamic> json) => _$ReceiptCustomerFromJson(json);

  Map<String, dynamic> toJson() => _$ReceiptCustomerToJson(this);

  factory ReceiptCustomer.empty() {
    return ReceiptCustomer(
      id: '',
      customerNumber: 0,
      company: null,
      firstName: '',
      lastName: '',
      name: '',
      email: '',
      gender: Gender.empty,
      birthday: '',
      phone: '',
      phoneMobile: '',
      listOfAddress: [],
      uidNumber: '',
      taxNumber: '',
    );
  }

  factory ReceiptCustomer.fromCustomer(Customer customer) {
    return ReceiptCustomer(
      id: customer.id,
      customerNumber: customer.customerNumber,
      company: customer.company,
      firstName: customer.firstName,
      lastName: customer.lastName,
      name: customer.name,
      email: customer.email,
      gender: customer.gender,
      birthday: customer.birthday,
      phone: customer.phone,
      phoneMobile: customer.phoneMobile,
      listOfAddress: customer.listOfAddress,
      uidNumber: customer.uidNumber,
      taxNumber: customer.taxNumber,
    );
  }

  ReceiptCustomer copyWith({
    String? id,
    int? customerNumber,
    String? company,
    String? firstName,
    String? lastName,
    String? name,
    String? email,
    Gender? gender,
    String? birthday,
    String? phone,
    String? phoneMobile,
    List<Address>? listOfAddress,
    String? uidNumber,
    String? taxNumber,
  }) {
    return ReceiptCustomer(
      id: id ?? this.id,
      customerNumber: customerNumber ?? this.customerNumber,
      company: company ?? this.company,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      name: name ?? this.name,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      phone: phone ?? this.phone,
      phoneMobile: phoneMobile ?? this.phoneMobile,
      listOfAddress: listOfAddress ?? this.listOfAddress,
      uidNumber: uidNumber ?? this.uidNumber,
      taxNumber: taxNumber ?? this.taxNumber,
    );
  }

  @override
  String toString() {
    return 'ReceiptCustomer(id: $id, customerNumber: $customerNumber, company: $company, firstName: $firstName, lastName: $lastName, name: $name, email: $email, gender: $gender, birthday: $birthday, phone: $phone, phoneMobile: $phoneMobile, listOfAddress: $listOfAddress, uidNumber: $uidNumber, taxNumber: $taxNumber)';
  }
}
