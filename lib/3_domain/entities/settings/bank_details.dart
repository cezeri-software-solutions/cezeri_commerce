// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'bank_details.g.dart';

@JsonSerializable()
class BankDetails {
  // @JsonKey(name: 'bank_name')
  final String bankName;
  // @JsonKey(name: 'bank_iban')
  final String bankIban;
  // @JsonKey(name: 'bank_bic')
  final String bankBic;
  // @JsonKey(name: 'paypal_email')
  final String paypalEmail;

  const BankDetails({
    required this.bankName,
    required this.bankIban,
    required this.bankBic,
    required this.paypalEmail,
  });

  factory BankDetails.fromJson(Map<String, dynamic> json) => _$BankDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$BankDetailsToJson(this);

  factory BankDetails.empty() {
    return const BankDetails(
      bankName: '',
      bankIban: '',
      bankBic: '',
      paypalEmail: '',
    );
  }

  BankDetails copyWith({
    String? bankName,
    String? bankIban,
    String? bankBic,
    String? paypalEmail,
  }) {
    return BankDetails(
      bankName: bankName ?? this.bankName,
      bankIban: bankIban ?? this.bankIban,
      bankBic: bankBic ?? this.bankBic,
      paypalEmail: paypalEmail ?? this.paypalEmail,
    );
  }

  @override
  String toString() {
    return 'BankDetails(bankName: $bankName, bankIban: $bankIban, bankBic: $bankBic, paypalEmail: $paypalEmail)';
  }
}
