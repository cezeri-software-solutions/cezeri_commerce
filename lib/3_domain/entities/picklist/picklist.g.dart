// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picklist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Picklist _$PicklistFromJson(Map<String, dynamic> json) => Picklist(
      id: json['id'] as String,
      listOfPicklistAppointments: (json['listOfPicklistAppointments']
              as List<dynamic>)
          .map((e) => PicklistAppointment.fromJson(e as Map<String, dynamic>))
          .toList(),
      listOfPicklistProducts: (json['listOfPicklistProducts'] as List<dynamic>)
          .map((e) => PicklistProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      creationDate: DateTime.parse(json['creationDate'] as String),
      creationDateInt: (json['creationDateInt'] as num).toInt(),
      lastEditingDate: DateTime.parse(json['lastEditingDate'] as String),
    );

Map<String, dynamic> _$PicklistToJson(Picklist instance) => <String, dynamic>{
      'id': instance.id,
      'listOfPicklistAppointments':
          instance.listOfPicklistAppointments.map((e) => e.toJson()).toList(),
      'listOfPicklistProducts':
          instance.listOfPicklistProducts.map((e) => e.toJson()).toList(),
      'creationDate': instance.creationDate.toIso8601String(),
      'creationDateInt': instance.creationDateInt,
      'lastEditingDate': instance.lastEditingDate.toIso8601String(),
    };
