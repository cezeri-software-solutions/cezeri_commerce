import 'package:json_annotation/json_annotation.dart';

part 'parcel_tracking.g.dart';

@JsonSerializable(explicitToJson: true)
class ParcelTracking {
  final int deliveryNoteId;
  final String trackingUrl;
  final String trackingNumber;

  const ParcelTracking({
    required this.deliveryNoteId,
    required this.trackingUrl,
    required this.trackingNumber,
  });

  factory ParcelTracking.fromJson(Map<String, dynamic> json) => _$ParcelTrackingFromJson(json);

  Map<String, dynamic> toJson() => _$ParcelTrackingToJson(this);

  factory ParcelTracking.empty() {
    return const ParcelTracking(deliveryNoteId: 0, trackingUrl: '', trackingNumber: '');
  }

  ParcelTracking copyWith({
    int? deliveryNoteId,
    String? trackingUrl,
    String? trackingNumber,
  }) {
    return ParcelTracking(
      deliveryNoteId: deliveryNoteId ?? this.deliveryNoteId,
      trackingUrl: trackingUrl ?? this.trackingUrl,
      trackingNumber: trackingNumber ?? this.trackingNumber,
    );
  }

  @override
  String toString() => 'ParcelTracking(deliveryNoteId: $deliveryNoteId, trackingUrl: $trackingUrl, trackingNumber: $trackingNumber)';
}
