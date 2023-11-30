// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stat_dashboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatDashboard _$StatDashboardFromJson(Map<String, dynamic> json) =>
    StatDashboard(
      statDashboardId: json['statDashboardId'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      incomingOrders: (json['incomingOrders'] as num).toDouble(),
      salesVolume: (json['salesVolume'] as num).toDouble(),
      offerVolume: (json['offerVolume'] as num).toDouble(),
    );

Map<String, dynamic> _$StatDashboardToJson(StatDashboard instance) =>
    <String, dynamic>{
      'statDashboardId': instance.statDashboardId,
      'dateTime': instance.dateTime.toIso8601String(),
      'incomingOrders': instance.incomingOrders,
      'salesVolume': instance.salesVolume,
      'offerVolume': instance.offerVolume,
    };
