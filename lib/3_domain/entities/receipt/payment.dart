import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

@JsonSerializable()
class Payment {
  double paidAmount;
  String comment;
  DateTime dateOfPay;

  Payment(
    this.paidAmount,
    this.comment,
    this.dateOfPay,
  );

  factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);

  factory Payment.empty() {
    return Payment(
      0,
      '',
      DateTime.now(),
    );
  }

  Payment copyWith({
    double? paidAmount,
    String? comment,
    DateTime? dateOfPay,
  }) {
    return Payment(
      paidAmount ?? this.paidAmount,
      comment ?? this.comment,
      dateOfPay ?? this.dateOfPay,
    );
  }
}
