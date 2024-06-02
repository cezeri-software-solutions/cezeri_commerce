// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stat_dashboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatDashboard _$StatDashboardFromJson(Map<String, dynamic> json) =>
    StatDashboard(
      id: json['id'] as String,
      month: json['month'] as String,
      offerVolume: (json['offer_volume'] as num).toDouble(),
      appointmentVolume: (json['appointment_volume'] as num).toDouble(),
      invoiceVolume: (json['invoice_volume'] as num).toDouble(),
      creditVolume: (json['credit_volume'] as num).toDouble(),
      lastEditingDate: DateTime.parse(json['last_editing_date'] as String),
      creationDate: DateTime.parse(json['creation_date'] as String),
    );

Map<String, dynamic> _$StatDashboardToJson(StatDashboard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'month': instance.month,
      'offer_volume': instance.offerVolume,
      'appointment_volume': instance.appointmentVolume,
      'invoice_volume': instance.invoiceVolume,
      'credit_volume': instance.creditVolume,
      'last_editing_date': instance.lastEditingDate.toIso8601String(),
      'creation_date': instance.creationDate.toIso8601String(),
    };
