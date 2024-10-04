// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specific_price.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpecificPrice _$SpecificPriceFromJson(Map<String, dynamic> json) =>
    SpecificPrice(
      id: json['id'] as String,
      title: json['title'] as String,
      fromQuantity: (json['from_quantity'] as num).toInt(),
      value: (json['value'] as num).toDouble(),
      reductionType:
          $enumDecode(_$ReductionTypeEnumMap, json['reduction_type']),
      fixedReductionType: $enumDecode(
          _$FixedReductionTypeEnumMap, json['fixed_reduction_type']),
      isActive: json['is_active'] as bool,
      isDiscountInternal: json['is_discount_internal'] as bool,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      discountedPriceNet: (json['discounted_price_net'] as num).toDouble(),
      discountedPriceGross: (json['discounted_price_gross'] as num).toDouble(),
      listOfSpecificPriceMarketplaces:
          (json['marketplace_specific_price'] as List<dynamic>)
              .map((e) => _$recordConvert(
                    e,
                    ($jsonValue) => (
                      marketplaceId: $jsonValue['marketplaceId'] as String,
                      specificPriceId: $jsonValue['specificPriceId'] as String?,
                    ),
                  ))
              .toList(),
    );

Map<String, dynamic> _$SpecificPriceToJson(SpecificPrice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'from_quantity': instance.fromQuantity,
      'value': instance.value,
      'reduction_type': _$ReductionTypeEnumMap[instance.reductionType]!,
      'fixed_reduction_type':
          _$FixedReductionTypeEnumMap[instance.fixedReductionType]!,
      'is_active': instance.isActive,
      'is_discount_internal': instance.isDiscountInternal,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'discounted_price_net': instance.discountedPriceNet,
      'discounted_price_gross': instance.discountedPriceGross,
      'marketplace_specific_price': instance.listOfSpecificPriceMarketplaces
          .map((e) => <String, dynamic>{
                'marketplaceId': e.marketplaceId,
                'specificPriceId': e.specificPriceId,
              })
          .toList(),
    };

const _$ReductionTypeEnumMap = {
  ReductionType.fixed: 'fixed',
  ReductionType.percent: 'percent',
};

const _$FixedReductionTypeEnumMap = {
  FixedReductionType.net: 'net',
  FixedReductionType.gross: 'gross',
};

$Rec _$recordConvert<$Rec>(
  Object? value,
  $Rec Function(Map) convert,
) =>
    convert(value as Map<String, dynamic>);
