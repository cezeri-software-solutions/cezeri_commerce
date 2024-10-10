// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incoming_invoice_supplier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncomingInvoiceSupplier _$IncomingInvoiceSupplierFromJson(
        Map<String, dynamic> json) =>
    IncomingInvoiceSupplier(
      id: json['id'] as String,
      supplierId: json['supplier_id'] as String,
      company: json['company'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      street: json['street'] as String,
      postcode: json['postcode'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
      phone: json['phone'] as String?,
      uidNumber: json['uid_number'] as String?,
      bankName: json['tax_number'] as String?,
      bankIban: json['bank_iban'] as String?,
      bankBic: json['bank_bic'] as String?,
      paypalEmail: json['paypal_email'] as String?,
    );

Map<String, dynamic> _$IncomingInvoiceSupplierToJson(
        IncomingInvoiceSupplier instance) =>
    <String, dynamic>{
      'supplier_id': instance.supplierId,
      'company': instance.company,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'street': instance.street,
      'postcode': instance.postcode,
      'city': instance.city,
      'country': instance.country,
      'phone': instance.phone,
      'uid_number': instance.uidNumber,
      'tax_number': instance.bankName,
      'bank_iban': instance.bankIban,
      'bank_bic': instance.bankBic,
      'paypal_email': instance.paypalEmail,
    };
