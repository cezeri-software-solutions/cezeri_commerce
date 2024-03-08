import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../models.dart';

part 'order_customer_shopify.g.dart';

@JsonSerializable()
class OrderCustomerShopify extends Equatable {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'state')
  final String state;
  @JsonKey(name: 'note')
  final String? note;
  @JsonKey(name: 'verified_email')
  final bool verifiedEmail;
  @JsonKey(name: 'multipass_identifier')
  final String? multipassIdentifier;
  @JsonKey(name: 'tax_exempt')
  final bool taxExempt;
  @JsonKey(name: 'email_marketing_consent')
  final dynamic emailMarketingConsent;
  @JsonKey(name: 'sms_marketing_consent')
  final dynamic smsMarketingConsent; // Use dynamic if structure not provided or unknown
  @JsonKey(name: 'tags')
  final String tags;
  @JsonKey(name: 'currency')
  final String currency;
  @JsonKey(name: 'tax_exemptions')
  final List<String> taxExemptions;
  @JsonKey(name: 'admin_graphql_api_id')
  final String adminGraphqlApiId;
  @JsonKey(name: 'default_address')
  final CustomerAddressShopify defaultAddress;

  const OrderCustomerShopify({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.state,
    this.note,
    required this.verifiedEmail,
    this.multipassIdentifier,
    required this.taxExempt,
    this.emailMarketingConsent,
    this.smsMarketingConsent,
    required this.tags,
    required this.currency,
    required this.taxExemptions,
    required this.adminGraphqlApiId,
    required this.defaultAddress,
  });

  factory OrderCustomerShopify.fromJson(Map<String, dynamic> json) => _$OrderCustomerShopifyFromJson(json);
  Map<String, dynamic> toJson() => _$OrderCustomerShopifyToJson(this);

  @override
  List<Object?> get props => [
        id,
        createdAt,
        updatedAt,
        state,
        note,
        verifiedEmail,
        multipassIdentifier,
        taxExempt,
        emailMarketingConsent,
        smsMarketingConsent,
        tags,
        currency,
        taxExemptions,
        adminGraphqlApiId,
        defaultAddress,
      ];

  @override
  bool get stringify => true;
}
