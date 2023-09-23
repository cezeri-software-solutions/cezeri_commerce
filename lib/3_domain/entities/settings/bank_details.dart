import 'package:json_annotation/json_annotation.dart';

part 'bank_details.g.dart';

@JsonSerializable()
class BankDetails {
  String bankName;
  String bankIban;
  String bankBic;
  String paypalEmail;

  BankDetails(
    this.bankName,
    this.bankIban,
    this.bankBic,
    this.paypalEmail,
  );

  factory BankDetails.fromJson(Map<String, dynamic> json) =>
      _$BankDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$BankDetailsToJson(this);

  factory BankDetails.empty() {
    return BankDetails(
      '',
      '',
      '',
      '',
    );
  }



  BankDetails copyWith({
    String? bankName,
    String? bankIban,
    String? bankBic,
    String? paypalEmail,
  }) {
    return BankDetails(
      bankName ?? this.bankName,
      bankIban ?? this.bankIban,
      bankBic ?? this.bankBic,
      paypalEmail ?? this.paypalEmail,
    );
  }
}
