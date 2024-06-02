// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parcel_tracking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParcelTracking _$ParcelTrackingFromJson(Map<String, dynamic> json) =>
    ParcelTracking(
      deliveryNoteId: (json['deliveryNoteId'] as num).toInt(),
      trackingUrl: json['trackingUrl'] as String,
      trackingUrl2: json['trackingUrl2'] as String?,
      trackingNumber: json['trackingNumber'] as String,
      trackingNumber2: json['trackingNumber2'] as String?,
      pdfString: json['pdfString'] as String,
    );

Map<String, dynamic> _$ParcelTrackingToJson(ParcelTracking instance) =>
    <String, dynamic>{
      'deliveryNoteId': instance.deliveryNoteId,
      'trackingUrl': instance.trackingUrl,
      'trackingUrl2': instance.trackingUrl2,
      'trackingNumber': instance.trackingNumber,
      'trackingNumber2': instance.trackingNumber2,
      'pdfString': instance.pdfString,
    };
