import 'package:json_annotation/json_annotation.dart';

part 'parcel_tracking.g.dart';

@JsonSerializable(explicitToJson: true)
class ParcelTracking {
  final int deliveryNoteId;
  final String trackingUrl;
  final String trackingNumber;
  final String pdfString;

  const ParcelTracking({
    required this.deliveryNoteId,
    required this.trackingUrl,
    required this.trackingNumber,
    required this.pdfString,
  });

  factory ParcelTracking.fromJson(Map<String, dynamic> json) => _$ParcelTrackingFromJson(json);

  Map<String, dynamic> toJson() => _$ParcelTrackingToJson(this);

  factory ParcelTracking.empty() {
    return const ParcelTracking(deliveryNoteId: 0, trackingUrl: '', trackingNumber: '', pdfString: '');
  }

  ParcelTracking copyWith({
    int? deliveryNoteId,
    String? trackingUrl,
    String? trackingNumber,
    String? pdfString,
  }) {
    return ParcelTracking(
      deliveryNoteId: deliveryNoteId ?? this.deliveryNoteId,
      trackingUrl: trackingUrl ?? this.trackingUrl,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      pdfString: pdfString ?? this.pdfString,
    );
  }

  @override
  String toString() {
    return 'ParcelTracking(deliveryNoteId: $deliveryNoteId, trackingUrl: $trackingUrl, trackingNumber: $trackingNumber, pdfString: $pdfString)';
  }
}
