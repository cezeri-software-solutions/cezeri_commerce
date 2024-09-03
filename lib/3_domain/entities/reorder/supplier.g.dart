// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Supplier _$SupplierFromJson(Map<String, dynamic> json) => Supplier(
      id: json['id'] as String,
      supplierNumber: (json['supplierNumber'] as num).toInt(),
      company: json['company'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      street: json['street'] as String,
      street2: json['street2'] as String,
      postcode: json['postcode'] as String,
      city: json['city'] as String,
      country: Country.fromJson(json['country'] as Map<String, dynamic>),
      email: json['email'] as String,
      homepage: json['homepage'] as String,
      phone: json['phone'] as String,
      phoneMobile: json['phoneMobile'] as String,
      uidNumber: json['uidNumber'] as String,
      taxNumber: json['taxNumber'] as String,
      tax: Tax.fromJson(json['tax'] as Map<String, dynamic>),
      creationDate: DateTime.parse(json['creationDate'] as String),
      lastEditingDate: DateTime.parse(json['lastEditingDate'] as String),
    );

Map<String, dynamic> _$SupplierToJson(Supplier instance) => <String, dynamic>{
      'supplierNumber': instance.supplierNumber,
      'company': instance.company,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'street': instance.street,
      'street2': instance.street2,
      'postcode': instance.postcode,
      'city': instance.city,
      'country': instance.country.toJson(),
      'email': instance.email,
      'homepage': instance.homepage,
      'phone': instance.phone,
      'phoneMobile': instance.phoneMobile,
      'uidNumber': instance.uidNumber,
      'taxNumber': instance.taxNumber,
      'tax': instance.tax.toJson(),
      'creationDate': instance.creationDate.toIso8601String(),
      'lastEditingDate': instance.lastEditingDate.toIso8601String(),
    };
