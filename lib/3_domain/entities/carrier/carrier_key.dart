import 'package:json_annotation/json_annotation.dart';

part 'carrier_key.g.dart';

@JsonSerializable()
class CarrierKey {
  // @JsonKey(name: 'client_id')
  final String clientId;
  // @JsonKey(name: 'org_unit_id')
  final String orgUnitId;
  // @JsonKey(name: 'org_unit_guide')
  final String orgUnitGuide;

  const CarrierKey({required this.clientId, required this.orgUnitId, required this.orgUnitGuide});

  factory CarrierKey.fromJson(Map<String, dynamic> json) => _$CarrierKeyFromJson(json);

  Map<String, dynamic> toJson() => _$CarrierKeyToJson(this);

  factory CarrierKey.empty() {
    return const CarrierKey(clientId: '', orgUnitId: '', orgUnitGuide: '');
  }

  CarrierKey copyWith({
    String? clientId,
    String? orgUnitId,
    String? orgUnitGuide,
  }) {
    return CarrierKey(
      clientId: clientId ?? this.clientId,
      orgUnitId: orgUnitId ?? this.orgUnitId,
      orgUnitGuide: orgUnitGuide ?? this.orgUnitGuide,
    );
  }

  @override
  String toString() => 'CarrierKey(clientId: $clientId, orgUnitId: $orgUnitId, orgUnitGuide: $orgUnitGuide)';
}
