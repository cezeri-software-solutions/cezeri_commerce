// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incoming_invoice_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncomingInvoiceFile _$IncomingInvoiceFileFromJson(Map<String, dynamic> json) =>
    IncomingInvoiceFile(
      id: json['id'] as String,
      sortId: json['sortId'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$IncomingInvoiceFileToJson(
        IncomingInvoiceFile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sortId': instance.sortId,
      'name': instance.name,
      'url': instance.url,
    };
