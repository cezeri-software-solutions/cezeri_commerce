import 'package:json_annotation/json_annotation.dart';

import '../../entities_presta/address_presta.dart';
import '../../entities_presta/country_presta.dart';
import '../../entities_presta/customer_presta.dart';
import '../../enums/enums.dart';
import '../address.dart';
import '../marketplace/marketplace.dart';
import '../settings/tax.dart';
import 'customer_marketplace.dart';

part 'customer.g.dart';

enum CustomerInvoiceType { standardInvoice, collectiveInvoice }

@JsonSerializable(explicitToJson: true)
class Customer {
  final String id;
  final int customerNumber;
  final CustomerMarketplace customerMarketplace;
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
  final CustomerInvoiceType customerInvoiceType;
  final String uidNumber;
  final String taxNumber;
  final Tax tax;
  final DateTime creationDate;
  final DateTime lastEditingDate;

  const Customer({
    required this.id,
    required this.customerNumber,
    required this.customerMarketplace,
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
    required this.customerInvoiceType,
    required this.uidNumber,
    required this.taxNumber,
    required this.tax,
    required this.creationDate,
    required this.lastEditingDate,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  factory Customer.empty() {
    return Customer(
      id: '',
      customerNumber: 0,
      customerMarketplace: CustomerMarketplace.empty(),
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
      customerInvoiceType: CustomerInvoiceType.standardInvoice,
      uidNumber: '',
      taxNumber: '',
      tax: Tax.empty(),
      creationDate: DateTime.now(),
      lastEditingDate: DateTime.now(),
    );
  }

  factory Customer.fromPresta(
    CustomerPresta customerPresta,
    int customerNumber,
    Marketplace marketplace,
    AddressPresta addressInvoicePresta,
    AddressPresta addressDeliveryPresta,
    CountryPresta countryInvoicePresta,
    CountryPresta countryDeliveryPresta,
    Tax tax,
  ) {
    String getUidNumber(String uidFromAddressInvoice, String uidFromAddressDelivery) {
      if (uidFromAddressInvoice != '') return uidFromAddressInvoice;
      if (uidFromAddressDelivery != '') return uidFromAddressDelivery;
      return '';
    }

    String getPhone(String phoneFromAddressInvoice, String phoneFromAddressDelivery) {
      if (phoneFromAddressInvoice != '') return phoneFromAddressInvoice;
      if (phoneFromAddressDelivery != '') return phoneFromAddressDelivery;
      return '';
    }

    String getPhoneMobile(String phoneFromAddressInvoice, String phoneFromAddressDelivery) {
      if (phoneFromAddressInvoice != '') return phoneFromAddressInvoice;
      if (phoneFromAddressDelivery != '') return phoneFromAddressDelivery;
      return '';
    }

    return Customer(
      id: '',
      customerNumber: customerNumber,
      customerMarketplace: CustomerMarketplace.fromPresta(customerPresta, marketplace),
      company: customerPresta.company != null ? addressInvoicePresta.company : null,
      firstName: customerPresta.firstname,
      lastName: customerPresta.lastname,
      name: '${customerPresta.firstname} ${customerPresta.lastname}',
      email: customerPresta.email,
      gender: switch (customerPresta.idGender) {
        '1' => Gender.male,
        '2' => Gender.female,
        (_) => Gender.empty,
      },
      birthday: customerPresta.birthday,
      phone: getPhone(addressInvoicePresta.phone, addressDeliveryPresta.phone),
      phoneMobile: getPhoneMobile(addressInvoicePresta.phone, addressDeliveryPresta.phone),
      listOfAddress: [
        Address.fromPresta(addressInvoicePresta, countryInvoicePresta, AddressType.invoice),
        Address.fromPresta(addressDeliveryPresta, countryDeliveryPresta, AddressType.delivery),
      ],
      customerInvoiceType: CustomerInvoiceType.standardInvoice,
      uidNumber: getUidNumber(addressInvoicePresta.vatNumber, addressDeliveryPresta.vatNumber),
      taxNumber: '',
      tax: tax,
      creationDate: DateTime.now(),
      lastEditingDate: DateTime.now(),
    );
  }

  Customer copyWith({
    String? id,
    int? customerNumber,
    CustomerMarketplace? customerMarketplace,
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
    CustomerInvoiceType? customerInvoiceType,
    String? uidNumber,
    String? taxNumber,
    Tax? tax,
    DateTime? creationDate,
    DateTime? lastEditingDate,
  }) {
    return Customer(
      id: id ?? this.id,
      customerNumber: customerNumber ?? this.customerNumber,
      customerMarketplace: customerMarketplace ?? this.customerMarketplace,
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
      customerInvoiceType: customerInvoiceType ?? this.customerInvoiceType,
      uidNumber: uidNumber ?? this.uidNumber,
      taxNumber: taxNumber ?? this.taxNumber,
      tax: tax ?? this.tax,
      creationDate: creationDate ?? this.creationDate,
      lastEditingDate: lastEditingDate ?? this.lastEditingDate,
    );
  }

  @override
  String toString() {
    return 'Customer(id: $id, customerNumber: $customerNumber, customerMarketplace: $customerMarketplace, company: $company, firstName: $firstName, lastName: $lastName, name: $name, email: $email, gender: $gender, birthday: $birthday, phone: $phone, phoneMobile: $phoneMobile, listOfAddress: $listOfAddress, customerInvoiceType: $customerInvoiceType, uidNumber: $uidNumber, taxNumber: $taxNumber, tax: $tax, creationDate: $creationDate, lastEditingDate: $lastEditingDate)';
  }
}
