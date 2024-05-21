// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_customer_shopify.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderCustomerShopify _$OrderCustomerShopifyFromJson(
        Map<String, dynamic> json) =>
    OrderCustomerShopify(
      id: (json['id'] as num).toInt(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      state: json['state'] as String,
      note: json['note'] as String?,
      verifiedEmail: json['verified_email'] as bool,
      multipassIdentifier: json['multipass_identifier'] as String?,
      taxExempt: json['tax_exempt'] as bool,
      emailMarketingConsent: json['email_marketing_consent'],
      smsMarketingConsent: json['sms_marketing_consent'],
      tags: json['tags'] as String,
      currency: json['currency'] as String,
      taxExemptions: (json['tax_exemptions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      adminGraphqlApiId: json['admin_graphql_api_id'] as String,
      defaultAddress: CustomerAddressShopify.fromJson(
          json['default_address'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderCustomerShopifyToJson(
        OrderCustomerShopify instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'state': instance.state,
      'note': instance.note,
      'verified_email': instance.verifiedEmail,
      'multipass_identifier': instance.multipassIdentifier,
      'tax_exempt': instance.taxExempt,
      'email_marketing_consent': instance.emailMarketingConsent,
      'sms_marketing_consent': instance.smsMarketingConsent,
      'tags': instance.tags,
      'currency': instance.currency,
      'tax_exemptions': instance.taxExemptions,
      'admin_graphql_api_id': instance.adminGraphqlApiId,
      'default_address': instance.defaultAddress,
    };
