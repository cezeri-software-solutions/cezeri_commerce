// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carrier_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarrierProduct _$CarrierProductFromJson(Map<String, dynamic> json) =>
    CarrierProduct(
      id: json['id'] as String,
      productName: json['productName'] as String,
      isDefault: json['isDefault'] as bool,
      isReturn: json['isReturn'] as bool,
      isActive: json['isActive'] as bool,
      country: Country.fromJson(json['country'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CarrierProductToJson(CarrierProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productName': instance.productName,
      'isDefault': instance.isDefault,
      'isReturn': instance.isReturn,
      'isActive': instance.isActive,
      'country': instance.country.toJson(),
    };
