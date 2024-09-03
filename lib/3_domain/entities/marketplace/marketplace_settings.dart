import 'package:json_annotation/json_annotation.dart';

import '../e_mail_automation.dart';

part 'marketplace_settings.g.dart';

@JsonSerializable(explicitToJson: true)
class MarketplaceSettings {
  final String id;
  final int nextIdToImport;
  final DateTime lastImportDateTime;
  final List<int> orderStatusIdsToImport;
  final int statusIdAfterImport;
  final int statusIdAfterShipping;
  final int statusIdAfterCancellation;
  final int statusIdAfterDelete;
  final List<EMailAutomation> listOfEMailAutomations;

  const MarketplaceSettings({
    required this.id,
    required this.nextIdToImport,
    required this.lastImportDateTime,
    required this.orderStatusIdsToImport,
    required this.statusIdAfterImport,
    required this.statusIdAfterShipping,
    required this.statusIdAfterCancellation,
    required this.statusIdAfterDelete,
    required this.listOfEMailAutomations,
  });

  factory MarketplaceSettings.fromJson(Map<String, dynamic> json) => _$MarketplaceSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$MarketplaceSettingsToJson(this);

  factory MarketplaceSettings.empty() {
    return MarketplaceSettings(
      id: '',
      nextIdToImport: 1,
      lastImportDateTime: DateTime.now(),
      orderStatusIdsToImport: [],
      statusIdAfterImport: 0,
      statusIdAfterShipping: 0,
      statusIdAfterCancellation: 0,
      statusIdAfterDelete: 0,
      listOfEMailAutomations: [],
    );
  }

  MarketplaceSettings copyWith({
    String? id,
    int? nextIdToImport,
    DateTime? lastImportDateTime,
    List<int>? orderStatusIdsToImport,
    int? statusIdAfterImport,
    int? statusIdAfterShipping,
    int? statusIdAfterCancellation,
    int? statusIdAfterDelete,
    List<EMailAutomation>? listOfEMailAutomations,
  }) {
    return MarketplaceSettings(
      id: id ?? this.id,
      nextIdToImport: nextIdToImport ?? this.nextIdToImport,
      lastImportDateTime: lastImportDateTime ?? this.lastImportDateTime,
      orderStatusIdsToImport: orderStatusIdsToImport ?? this.orderStatusIdsToImport,
      statusIdAfterImport: statusIdAfterImport ?? this.statusIdAfterImport,
      statusIdAfterShipping: statusIdAfterShipping ?? this.statusIdAfterShipping,
      statusIdAfterCancellation: statusIdAfterCancellation ?? this.statusIdAfterCancellation,
      statusIdAfterDelete: statusIdAfterDelete ?? this.statusIdAfterDelete,
      listOfEMailAutomations: listOfEMailAutomations ?? this.listOfEMailAutomations,
    );
  }

  @override
  String toString() {
    return 'MarketplaceSettings(id: $id, nextIdToImport: $nextIdToImport, lastImportDateTime: $lastImportDateTime, orderStatusIdsToImport: $orderStatusIdsToImport, statusIdAfterImport: $statusIdAfterImport, statusIdAfterShipping: $statusIdAfterShipping, statusIdAfterCancellation: $statusIdAfterCancellation, statusIdAfterDelete: $statusIdAfterDelete, listOfEMailAutomations: $listOfEMailAutomations)';
  }
}
