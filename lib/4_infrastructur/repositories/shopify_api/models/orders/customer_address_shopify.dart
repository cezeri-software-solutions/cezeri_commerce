import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer_address_shopify.g.dart';

@JsonSerializable()
class CustomerAddressShopify extends Equatable {
  @JsonKey(name: 'address1')
  final String? address1;
  @JsonKey(name: 'address2')
  final String? address2;
  @JsonKey(name: 'city')
  final String? city;
  @JsonKey(name: 'company')
  final String? company;
  @JsonKey(name: 'country')
  final String? country;
  @JsonKey(name: 'country_code')
  final String countryCode;
  @JsonKey(name: 'first_name')
  final String? firstName;
  @JsonKey(name: 'last_name')
  final String? lastName;
  @JsonKey(name: 'latitude')
  final double? latitude;
  @JsonKey(name: 'longitude')
  final double? longitude;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'phone')
  final String? phone;
  @JsonKey(name: 'province')
  final String? province;
  @JsonKey(name: 'province_code')
  final String? provinceCode;
  @JsonKey(name: 'zip')
  final String? zip;

  const CustomerAddressShopify({
    required this.address1,
    this.address2,
    required this.city,
    this.company,
    required this.country,
    required this.countryCode,
    required this.firstName,
    required this.lastName,
    this.latitude,
    this.longitude,
    required this.name,
    this.phone,
    this.province,
    this.provinceCode,
    required this.zip,
  });

  factory CustomerAddressShopify.fromJson(Map<String, dynamic> json) => _$CustomerAddressShopifyFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerAddressShopifyToJson(this);

  @override
  List<Object?> get props => [
        address1,
        address2,
        city,
        company,
        country,
        countryCode,
        firstName,
        lastName,
        latitude,
        longitude,
        name,
        phone,
        province,
        provinceCode,
        zip,
      ];

  @override
  bool get stringify => true;
}