// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reorder_supplier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReorderSupplier _$ReorderSupplierFromJson(Map<String, dynamic> json) =>
    ReorderSupplier(
      id: json['id'] as String,
      supplierNumber: (json['supplierNumber'] as num).toInt(),
      company: json['company'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$ReorderSupplierToJson(ReorderSupplier instance) =>
    <String, dynamic>{
      'id': instance.id,
      'supplierNumber': instance.supplierNumber,
      'company': instance.company,
      'name': instance.name,
    };
