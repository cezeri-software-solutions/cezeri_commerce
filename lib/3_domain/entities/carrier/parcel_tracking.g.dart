// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parcel_tracking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParcelTracking _$ParcelTrackingFromJson(Map<String, dynamic> json) =>
    ParcelTracking(
      deliveryNoteId: json['deliveryNoteId'] as int,
      trackingUrl: json['trackingUrl'] as String,
      trackingNumber: json['trackingNumber'] as String,
    );

Map<String, dynamic> _$ParcelTrackingToJson(ParcelTracking instance) =>
    <String, dynamic>{
      'deliveryNoteId': instance.deliveryNoteId,
      'trackingUrl': instance.trackingUrl,
      'trackingNumber': instance.trackingNumber,
    };
