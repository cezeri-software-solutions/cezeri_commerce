// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marketplace_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketplaceSettings _$MarketplaceSettingsFromJson(Map<String, dynamic> json) =>
    MarketplaceSettings(
      id: json['id'] as String,
      nextIdToImport: json['nextIdToImport'] as int,
      lastImportDateTime: DateTime.parse(json['lastImportDateTime'] as String),
      orderStatusIdsToImport: (json['orderStatusIdsToImport'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      statusIdAfterImport: json['statusIdAfterImport'] as int,
      statusIdAfterShipping: json['statusIdAfterShipping'] as int,
      statusIdAfterCancellation: json['statusIdAfterCancellation'] as int,
      statusIdAfterDelete: json['statusIdAfterDelete'] as int,
      listOfEMailAutomations: (json['listOfEMailAutomations'] as List<dynamic>)
          .map((e) => EMailAutomation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MarketplaceSettingsToJson(
        MarketplaceSettings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nextIdToImport': instance.nextIdToImport,
      'lastImportDateTime': instance.lastImportDateTime.toIso8601String(),
      'orderStatusIdsToImport': instance.orderStatusIdsToImport,
      'statusIdAfterImport': instance.statusIdAfterImport,
      'statusIdAfterShipping': instance.statusIdAfterShipping,
      'statusIdAfterCancellation': instance.statusIdAfterCancellation,
      'statusIdAfterDelete': instance.statusIdAfterDelete,
      'listOfEMailAutomations':
          instance.listOfEMailAutomations.map((e) => e.toJson()).toList(),
    };
