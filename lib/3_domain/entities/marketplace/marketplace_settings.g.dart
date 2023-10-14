// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marketplace_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketplaceSettings _$MarketplaceSettingsFromJson(Map<String, dynamic> json) =>
    MarketplaceSettings(
      id: json['id'] as String,
      nextIdToImport: json['nextIdToImport'] as int,
      orderStatusIdsToImport: (json['orderStatusIdsToImport'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      statusIdAfterImport: json['statusIdAfterImport'] as int,
      statusIdAfterShipping: json['statusIdAfterShipping'] as int,
      statusIdAfterCancellation: json['statusIdAfterCancellation'] as int,
      statusIdAfterDelete: json['statusIdAfterDelete'] as int,
    );

Map<String, dynamic> _$MarketplaceSettingsToJson(
        MarketplaceSettings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nextIdToImport': instance.nextIdToImport,
      'orderStatusIdsToImport': instance.orderStatusIdsToImport,
      'statusIdAfterImport': instance.statusIdAfterImport,
      'statusIdAfterShipping': instance.statusIdAfterShipping,
      'statusIdAfterCancellation': instance.statusIdAfterCancellation,
      'statusIdAfterDelete': instance.statusIdAfterDelete,
    };
