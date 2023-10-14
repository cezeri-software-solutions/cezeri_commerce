import 'package:json_annotation/json_annotation.dart';

part 'marketplace_settings.g.dart';

@JsonSerializable()
class MarketplaceSettings {
  final String id;
  final int nextIdToImport;
  final List<int> orderStatusIdsToImport;
  final int statusIdAfterImport;
  final int statusIdAfterShipping;
  final int statusIdAfterCancellation;
  final int statusIdAfterDelete;

  const MarketplaceSettings({
    required this.id,
    required this.nextIdToImport,
    required this.orderStatusIdsToImport,
    required this.statusIdAfterImport,
    required this.statusIdAfterShipping,
    required this.statusIdAfterCancellation,
    required this.statusIdAfterDelete,
  });

  factory MarketplaceSettings.fromJson(Map<String, dynamic> json) => _$MarketplaceSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$MarketplaceSettingsToJson(this);

  factory MarketplaceSettings.empty() {
    return const MarketplaceSettings(
      id: '',
      nextIdToImport: 1,
      orderStatusIdsToImport: [],
      statusIdAfterImport: 0,
      statusIdAfterShipping: 0,
      statusIdAfterCancellation: 0,
      statusIdAfterDelete: 0,
    );
  }

  MarketplaceSettings copyWith({
    String? id,
    int? nextIdToImport,
    List<int>? orderStatusIdsToImport,
    int? statusIdAfterImport,
    int? statusIdAfterShipping,
    int? statusIdAfterCancellation,
    int? statusIdAfterDelete,
  }) {
    return MarketplaceSettings(
      id: id ?? this.id,
      nextIdToImport: nextIdToImport ?? this.nextIdToImport,
      orderStatusIdsToImport: orderStatusIdsToImport ?? this.orderStatusIdsToImport,
      statusIdAfterImport: statusIdAfterImport ?? this.statusIdAfterImport,
      statusIdAfterShipping: statusIdAfterShipping ?? this.statusIdAfterShipping,
      statusIdAfterCancellation: statusIdAfterCancellation ?? this.statusIdAfterCancellation,
      statusIdAfterDelete: statusIdAfterDelete ?? this.statusIdAfterDelete,
    );
  }

  @override
  String toString() {
    return 'MarketplaceSettings(id: $id, nextIdToImport: $nextIdToImport, orderStatusIdsToImport: $orderStatusIdsToImport, statusIdAfterImport: $statusIdAfterImport, statusIdAfterShipping: $statusIdAfterShipping, statusIdAfterCancellation: $statusIdAfterCancellation, statusIdAfterDelete: $statusIdAfterDelete)';
  }
}
