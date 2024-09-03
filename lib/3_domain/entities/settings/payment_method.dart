import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_method.g.dart';

@JsonSerializable()
class PaymentMethod extends Equatable {
  // @JsonKey(toJson: null)
  final String id;
  final String name;
  // @JsonKey(name: 'name_in_marketplace')
  final String nameInMarketplace;
  // @JsonKey(name: 'is_paid_automatically')
  final bool isPaidAutomatically;
  // @JsonKey(name: 'logo_url')
  final String logoUrl;
  // @JsonKey(name: 'logo_path')
  final String logoPath;
  // @JsonKey(name: 'is_not_deletable')
  final bool isNotDeletable;
  // @JsonKey(name: 'is_default')
  final bool isDefault;

  const PaymentMethod({
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
    return const PaymentMethod(
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
  List<Object?> get props => [id];

  @override
  bool get stringify => true;

  static List<PaymentMethod> paymentMethodList = [
    const PaymentMethod(
      id: '',
      name: 'Barzahlung',
      nameInMarketplace: 'Barzahlung',
      isPaidAutomatically: true,
      logoUrl: '',
      logoPath: 'assets/payment_methods/cash.png',
      isNotDeletable: false,
      isDefault: false,
    ),
    const PaymentMethod(
      id: '',
      name: 'Kartenzahlung',
      nameInMarketplace: 'Kartenzahlung',
      isPaidAutomatically: true,
      logoUrl: '',
      logoPath: 'assets/payment_methods/card.png',
      isNotDeletable: false,
      isDefault: false,
    ),
    const PaymentMethod(
      id: '',
      name: 'Vorkasse',
      nameInMarketplace: 'Banküberweisung',
      isPaidAutomatically: false,
      logoUrl: '',
      logoPath: 'assets/payment_methods/bank_transfer.png',
      isNotDeletable: false,
      isDefault: false,
    ),
    const PaymentMethod(
      id: '',
      name: 'Kauf auf Rechnung',
      nameInMarketplace: 'Kauf auf Rechnung',
      isPaidAutomatically: false,
      logoUrl: '',
      logoPath: 'assets/payment_methods/purchase_on_account.png',
      isNotDeletable: false,
      isDefault: false,
    ),
    const PaymentMethod(
      id: '',
      name: 'Amazon Pay',
      nameInMarketplace: 'Amazon Pay - Login and Pay with Amazon',
      isPaidAutomatically: true,
      logoUrl: '',
      logoPath: 'assets/payment_methods/amazon_pay.png',
      isNotDeletable: false,
      isDefault: false,
    ),
    const PaymentMethod(
      id: '',
      name: 'PayPal',
      nameInMarketplace: 'PayPal',
      isPaidAutomatically: true,
      logoUrl: '',
      logoPath: 'assets/payment_methods/paypal.png',
      isNotDeletable: false,
      isDefault: false,
    ),
    const PaymentMethod(
      id: '',
      name: 'eps',
      nameInMarketplace: 'eps',
      isPaidAutomatically: true,
      logoUrl: '',
      logoPath: 'assets/payment_methods/eps.png',
      isNotDeletable: false,
      isDefault: false,
    ),
    const PaymentMethod(
      id: '',
      name: 'Giropay',
      nameInMarketplace: 'Giropay',
      isPaidAutomatically: true,
      logoUrl: '',
      logoPath: 'assets/payment_methods/giropay.png',
      isNotDeletable: false,
      isDefault: false,
    ),
    const PaymentMethod(
      id: '',
      name: 'Klarna',
      nameInMarketplace: 'SOFORT Banking',
      isPaidAutomatically: true,
      logoUrl: '',
      logoPath: 'assets/payment_methods/klarna.png',
      isNotDeletable: false,
      isDefault: false,
    ),
    const PaymentMethod(
      id: '',
      name: 'Kreditkarte',
      nameInMarketplace: 'Credit/Debit Card',
      isPaidAutomatically: true,
      logoUrl: '',
      logoPath: 'assets/payment_methods/credit_card.png',
      isNotDeletable: false,
      isDefault: false,
    ),
    const PaymentMethod(
      id: '',
      name: 'Shopify Payments',
      nameInMarketplace: 'shopify_payments',
      isPaidAutomatically: true,
      logoUrl: '',
      logoPath: 'assets/payment_methods/shopify_payments.png',
      isNotDeletable: false,
      isDefault: false,
    ),
  ];
}
