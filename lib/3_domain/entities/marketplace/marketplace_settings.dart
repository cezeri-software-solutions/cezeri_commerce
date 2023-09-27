import 'package:json_annotation/json_annotation.dart';

part 'marketplace_settings.g.dart';

@JsonSerializable()
class MarketplaceSettings {
  final String id;
  final int nextIdToImport;
  final List<int> orderStatusIdsToImport;

  const MarketplaceSettings({
    required this.id,
    required this.nextIdToImport,
    required this.orderStatusIdsToImport,
  });

  factory MarketplaceSettings.fromJson(Map<String, dynamic> json) => _$MarketplaceSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$MarketplaceSettingsToJson(this);

  factory MarketplaceSettings.empty() {
    return const MarketplaceSettings(
      id: '',
      nextIdToImport: 1,
      orderStatusIdsToImport: [],
    );
  }

  MarketplaceSettings copyWith({
    String? id,
    int? nextIdToImport,
    List<int>? orderStatusIdsToImport,
  }) {
    return MarketplaceSettings(
      id: id ?? this.id,
      nextIdToImport: nextIdToImport ?? this.nextIdToImport,
      orderStatusIdsToImport: orderStatusIdsToImport ?? this.orderStatusIdsToImport,
    );
  }

  @override
  String toString() => 'MarketplaceSettings(id: $id, lastImportedOrderId: $nextIdToImport, orderStatusIdsToImport: $orderStatusIdsToImport)';
}
