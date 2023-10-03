// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_method.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) =>
    PaymentMethod(
      id: json['id'] as String,
      name: json['name'] as String,
      nameInMarketplace: json['nameInMarketplace'] as String,
      isPaidAutomatically: json['isPaidAutomatically'] as bool,
      logoUrl: json['logoUrl'] as String,
      logoPath: json['logoPath'] as String,
      isNotDeletable: json['isNotDeletable'] as bool,
      isDefault: json['isDefault'] as bool,
    );

Map<String, dynamic> _$PaymentMethodToJson(PaymentMethod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nameInMarketplace': instance.nameInMarketplace,
      'isPaidAutomatically': instance.isPaidAutomatically,
      'logoUrl': instance.logoUrl,
      'logoPath': instance.logoPath,
      'isNotDeletable': instance.isNotDeletable,
      'isDefault': instance.isDefault,
    };
