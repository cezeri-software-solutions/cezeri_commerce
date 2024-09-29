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
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
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
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$ReductionTypeEnumMap = {
  ReductionType.fixed: 'fixed',
  ReductionType.percent: 'percent',
};

const _$FixedReductionTypeEnumMap = {
  FixedReductionType.amount: 'amount',
  FixedReductionType.percent: 'percent',
};
