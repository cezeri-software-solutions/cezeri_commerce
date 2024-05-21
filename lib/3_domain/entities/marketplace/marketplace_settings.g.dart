// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marketplace_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketplaceSettings _$MarketplaceSettingsFromJson(Map<String, dynamic> json) =>
    MarketplaceSettings(
      id: json['id'] as String,
      nextIdToImport: (json['nextIdToImport'] as num).toInt(),
      lastImportDateTime: DateTime.parse(json['lastImportDateTime'] as String),
      orderStatusIdsToImport: (json['orderStatusIdsToImport'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      statusIdAfterImport: (json['statusIdAfterImport'] as num).toInt(),
      statusIdAfterShipping: (json['statusIdAfterShipping'] as num).toInt(),
      statusIdAfterCancellation:
          (json['statusIdAfterCancellation'] as num).toInt(),
      statusIdAfterDelete: (json['statusIdAfterDelete'] as num).toInt(),
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
