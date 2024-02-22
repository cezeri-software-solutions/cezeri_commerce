import 'package:json_annotation/json_annotation.dart';

part 'payment_method.g.dart';

@JsonSerializable()
class PaymentMethod {
  final String id;
  final String name;
  final String nameInMarketplace;
  final bool isPaidAutomatically;
  final String logoUrl;
  final String logoPath;
  final bool isNotDeletable;
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.nameInMarketplace,
    required this.isPaidAutomatically,
    required this.logoUrl,
    required this.logoPath,
    required this.isNotDeletable,
    required this.isDefault,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => _$PaymentMethodFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);

  factory PaymentMethod.empty() {
    return PaymentMethod(
      id: '',
      name: '',
      nameInMarketplace: '',
      isPaidAutomatically: false,
      logoUrl: '',
      logoPath: '',
      isNotDeletable: false,
      isDefault: false,
    );
  }

  PaymentMethod copyWith({
    String? id,
    String? name,
    String? nameInMarketplace,
    bool? isPaidAutomatically,
    String? logoUrl,
    String? logoPath,
    bool? isNotDeletable,
    bool? isDefault,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      name: name ?? this.name,
      nameInMarketplace: nameInMarketplace ?? this.nameInMarketplace,
      isPaidAutomatically: isPaidAutomatically ?? this.isPaidAutomatically,
      logoUrl: logoUrl ?? this.logoUrl,
      logoPath: logoPath ?? this.logoPath,
      isNotDeletable: isNotDeletable ?? this.isNotDeletable,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  @override
  String toString() {
    return 'PaymentMethod(id: $id, name: $name, nameInMarketplace: $nameInMarketplace, isPaidAutomatically: $isPaidAutomatically, logoUrl: $logoUrl, logoPath: $logoPath, isNotDeletable: $isNotDeletable, isDefault: $isDefault)';
  }

  static List<PaymentMethod> paymentMethodList = [
    PaymentMethod(
      id: '',
      name: 'Vorkasse',
      nameInMarketplace: 'Banküberweisung',
      isPaidAutomatically: false,
      logoUrl: '',
      logoPath: 'assets/payment_methods/bank_transfer.png',
      isNotDeletable: false,
      isDefault: false,
    ),
    PaymentMethod(
      id: '',
      name: 'Kauf auf Rechnung',
      nameInMarketplace: 'Kauf auf Rechnung',
      isPaidAutomatically: false,
      logoUrl: '',
      logoPath: 'assets/payment_methods/purchase_on_account.png',
      isNotDeletable: false,
      isDefault: false,
    ),
    PaymentMethod(
      id: '',
      name: 'Amazon Pay',
      nameInMarketplace: 'Amazon Pay - Login and Pay with Amazon',
      isPaidAutomatically: true,
      logoUrl: '',
      logoPath: 'assets/payment_methods/amazon_pay.png',
      isNotDeletable: false,
      isDefault: false,
    ),
    PaymentMethod(
      id: '',
      name: 'PayPal',
      nameInMarketplace: 'PayPal',
      isPaidAutomatically: true,
      logoUrl: '',
      logoPath: 'assets/payment_methods/paypal.png',
      isNotDeletable: false,
      isDefault: false,
    ),
    PaymentMethod(
      id: '',
      name: 'eps',
      nameInMarketplace: 'eps',
      isPaidAutomatically: true,
      logoUrl: '',
      logoPath: 'assets/payment_methods/eps.png',
      isNotDeletable: false,
      isDefault: false,
    ),
    PaymentMethod(
      id: '',
      name: 'Giropay',
      nameInMarketplace: 'Giropay',
      isPaidAutomatically: true,
      logoUrl: '',
      logoPath: 'assets/payment_methods/giropay.png',
      isNotDeletable: false,
      isDefault: false,
    ),
    PaymentMethod(
      id: '',
      name: 'Klarna',
      nameInMarketplace: 'SOFORT Banking',
      isPaidAutomatically: true,
      logoUrl: '',
      logoPath: 'assets/payment_methods/klarna.png',
      isNotDeletable: false,
      isDefault: false,
    ),
    PaymentMethod(
      id: '',
      name: 'Kreditkarte',
      nameInMarketplace: 'Credit/Debit Card',
      isPaidAutomatically: true,
      logoUrl: '',
      logoPath: 'assets/payment_methods/credit_card.png',
      isNotDeletable: false,
      isDefault: false,
    ),
  ];
}
