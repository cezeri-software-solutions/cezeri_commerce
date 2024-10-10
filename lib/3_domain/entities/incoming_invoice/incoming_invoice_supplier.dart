import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'incoming_invoice_supplier.g.dart';

@JsonSerializable(explicitToJson: true)
class IncomingInvoiceSupplier extends Equatable {
  @JsonKey(includeToJson: false)
  final String id;
  @JsonKey(name: 'supplier_id')
  final String supplierId;
  final String company;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  @JsonKey(includeToJson: false, includeFromJson: false)
  final String name;
  final String street;
  final String postcode;
  final String city;
  final String country;
  final String? phone;
  @JsonKey(name: 'uid_number')
  final String? uidNumber;
  @JsonKey(name: 'tax_number')
  final String? bankName;
  @JsonKey(name: 'bank_iban')
  final String? bankIban;
  @JsonKey(name: 'bank_bic')
  final String? bankBic;
  @JsonKey(name: 'paypal_email')
  final String? paypalEmail;

  IncomingInvoiceSupplier({
    required this.id,
    required this.supplierId,
    required this.company,
    required this.firstName,
    required this.lastName,
    required this.street,
    required this.postcode,
    required this.city,
    required this.country,
    required this.phone,
    required this.uidNumber,
    required this.bankName,
    required this.bankIban,
    required this.bankBic,
    required this.paypalEmail,
  }) : name = _createName(firstName, lastName);

  static String _createName(String firstName, String lastName) {
    final names = [
      firstName,
      lastName,
    ].where((element) => element.isNotEmpty);

    if (names.isEmpty) return '';
    return names.join(' ');
  }

  factory IncomingInvoiceSupplier.fromJson(Map<String, dynamic> json) => _$IncomingInvoiceSupplierFromJson(json);
  Map<String, dynamic> toJson() => _$IncomingInvoiceSupplierToJson(this);

  factory IncomingInvoiceSupplier.empty() {
    return IncomingInvoiceSupplier(
      id: '',
      supplierId: '',
      company: '',
      firstName: '',
      lastName: '',
      street: '',
      postcode: '',
      city: '',
      country: '',
      phone: null,
      uidNumber: null,
      bankName: null,
      bankIban: null,
      bankBic: null,
      paypalEmail: null,
    );
  }

  IncomingInvoiceSupplier copyWith({
    String? id,
    String? supplierId,
    String? company,
    String? firstName,
    String? lastName,
    String? street,
    String? postcode,
    String? city,
    String? country,
    String? phone,
    String? uidNumber,
    String? bankName,
    String? bankIban,
    String? bankBic,
    String? paypalEmail,
  }) {
    return IncomingInvoiceSupplier(
      id: id ?? this.id,
      supplierId: supplierId ?? this.supplierId,
      company: company ?? this.company,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      street: street ?? this.street,
      postcode: postcode ?? this.postcode,
      city: city ?? this.city,
      country: country ?? this.country,
      phone: phone ?? this.phone,
      uidNumber: uidNumber ?? this.uidNumber,
      bankName: bankName ?? this.bankName,
      bankIban: bankIban ?? this.bankIban,
      bankBic: bankBic ?? this.bankBic,
      paypalEmail: paypalEmail ?? this.paypalEmail,
    );
  }

  @override
  List<Object?> get props => [
        id,
        supplierId,
        company,
        firstName,
        lastName,
        street,
        postcode,
        city,
        country,
        phone,
        uidNumber,
        bankName,
        bankIban,
        bankBic,
        paypalEmail,
      ];

  @override
  bool get stringify => true;
}
