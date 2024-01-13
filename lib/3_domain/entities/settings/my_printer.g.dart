// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_printer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyPrinter _$MyPrinterFromJson(Map<String, dynamic> json) => MyPrinter(
      url: json['url'] as String,
      name: json['name'] as String?,
      model: json['model'] as String?,
      location: json['location'] as String?,
      comment: json['comment'] as String?,
      isDefault: json['isDefault'] as bool?,
      isAvailable: json['isAvailable'] as bool?,
    );

Map<String, dynamic> _$MyPrinterToJson(MyPrinter instance) => <String, dynamic>{
      'url': instance.url,
      'name': instance.name,
      'model': instance.model,
      'location': instance.location,
      'comment': instance.comment,
      'isDefault': instance.isDefault,
      'isAvailable': instance.isAvailable,
    };
