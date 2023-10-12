// import 'package:json_annotation/json_annotation.dart';

// import '../address.dart';
// import 'customer_marketplace.dart';

// part 'customer.g.dart';

// enum Gender { empty, male, female }

// enum CustomerInvoiceType { standardInvoice, collectiveInvoice }

// @JsonSerializable(explicitToJson: true)
// class Customer {
//   final String id;
//   final CustomerMarketplace customerMarketplace;
//   final String? company;
//   final String firstName;
//   final String lastName;
//   final String name;
//   final String email;
//   final Gender gender;
//   final String birthday;
//   final String phone; //* NEU
//   final String phoneMobile; //* NEU
//   final bool isNewsletterAccepted;
//   final bool isGuest;
//   final List<Address> listOfAddress;
//   final CustomerInvoiceType customerInvoiceType; //* NEU
//   final String uidNumber; //* NEU
//   final String taxNumber; //* NEU
//   final DateTime creationDate;
//   final DateTime lastEditingDate;

//   const Customer({
//     required this.id,
//     required this.customerMarketplace,
//     this.company,
//     required this.firstName,
//     required this.lastName,
//     required this.name,
//     required this.email,
//     required this.gender,
//     required this.birthday,
//     required this.isNewsletterAccepted,
//     required this.isGuest,
//     required this.listOfAddress,
//     required this.creationDate,
//     required this.lastEditingDate,
//   });

//   factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);

//   Map<String, dynamic> toJson() => _$CustomerToJson(this);

//   factory Customer.empty() {
//     return Customer(
//       id: '',
//       customerMarketplace: CustomerMarketplace.empty(),
//       company: null,
//       firstName: '',
//       lastName: '',
//       name: '',
//       email: '',
//       gender: Gender.empty,
//       birthday: '',
//       isNewsletterAccepted: false,
//       isGuest: false,
//       listOfAddress: [],
//       creationDate: DateTime.now(),
//       lastEditingDate: DateTime.now(),
//     );
//   }

//   Customer copyWith({
//     String? id,
//     CustomerMarketplace? customerMarketplace,
//     String? company,
//     String? firstName,
//     String? lastName,
//     String? name,
//     String? email,
//     Gender? gender,
//     String? birthday,
//     bool? isNewsletterAccepted,
//     bool? isGuest,
//     List<Address>? listOfAddress,
//     DateTime? creationDate,
//     DateTime? lastEditingDate,
//   }) {
//     return Customer(
//       id: id ?? this.id,
//       customerMarketplace: customerMarketplace ?? this.customerMarketplace,
//       company: company ?? this.company,
//       firstName: firstName ?? this.firstName,
//       lastName: lastName ?? this.lastName,
//       name: name ?? this.name,
//       email: email ?? this.email,
//       gender: gender ?? this.gender,
//       birthday: birthday ?? this.birthday,
//       isNewsletterAccepted: isNewsletterAccepted ?? this.isNewsletterAccepted,
//       isGuest: isGuest ?? this.isGuest,
//       listOfAddress: listOfAddress ?? this.listOfAddress,
//       creationDate: creationDate ?? this.creationDate,
//       lastEditingDate: lastEditingDate ?? this.lastEditingDate,
//     );
//   }

//   @override
//   String toString() {
//     return 'Customer(id: $id, customerMarketplace: $customerMarketplace, company: $company, firstName: $firstName, lastName: $lastName, name: $name, email: $email, gender: $gender, birthday: $birthday, isNewsletterAccepted: $isNewsletterAccepted, isGuest: $isGuest, listOfAddress: $listOfAddress, creationDate: $creationDate, lastEditingDate: $lastEditingDate)';
//   }
// }
