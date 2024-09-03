// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_address_shopify.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerAddressShopify _$CustomerAddressShopifyFromJson(
        Map<String, dynamic> json) =>
    CustomerAddressShopify(
      address1: json['address1'] as String?,
      address2: json['address2'] as String?,
      city: json['city'] as String?,
      company: json['company'] as String?,
      country: json['country'] as String?,
      countryCode: json['country_code'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      province: json['province'] as String?,
      provinceCode: json['province_code'] as String?,
      zip: json['zip'] as String?,
    );

Map<String, dynamic> _$CustomerAddressShopifyToJson(
        CustomerAddressShopify instance) =>
    <String, dynamic>{
      'address1': instance.address1,
      'address2': instance.address2,
      'city': instance.city,
      'company': instance.company,
      'country': instance.country,
      'country_code': instance.countryCode,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'name': instance.name,
      'phone': instance.phone,
      'province': instance.province,
      'province_code': instance.provinceCode,
      'zip': instance.zip,
    };
