import 'package:json_annotation/json_annotation.dart';

part 'parcel_tracking.g.dart';

@JsonSerializable(explicitToJson: true)
class ParcelTracking {
  final int deliveryNoteId;
  final String trackingUrl;
  final String? trackingUrl2;
  final String trackingNumber;
  final String? trackingNumber2;
  final String pdfString;

  const ParcelTracking({
    required this.deliveryNoteId,
    required this.trackingUrl,
    required this.trackingUrl2,
    required this.trackingNumber,
    required this.trackingNumber2,
    required this.pdfString,
  });

  factory ParcelTracking.fromJson(Map<String, dynamic> json) => _$ParcelTrackingFromJson(json);

  Map<String, dynamic> toJson() => _$ParcelTrackingToJson(this);

  factory ParcelTracking.empty() {
    return const ParcelTracking(
      deliveryNoteId: 0,
      trackingUrl: '',
      trackingUrl2: null,
      trackingNumber: '',
      trackingNumber2: null,
      pdfString: '',
    );
  }

  ParcelTracking copyWith({
    int? deliveryNoteId,
    String? trackingUrl,
    String? trackingUrl2,
    String? trackingNumber,
    String? trackingNumber2,
    String? pdfString,
  }) {
    return ParcelTracking(
      deliveryNoteId: deliveryNoteId ?? this.deliveryNoteId,
      trackingUrl: trackingUrl ?? this.trackingUrl,
      trackingUrl2: trackingUrl2 ?? this.trackingUrl2,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      trackingNumber2: trackingNumber2 ?? this.trackingNumber2,
      pdfString: pdfString ?? this.pdfString,
    );
  }

  @override
  String toString() {
    return 'ParcelTracking(deliveryNoteId: $deliveryNoteId, trackingUrl: $trackingUrl, trackingUrl2: $trackingUrl2, trackingNumber: $trackingNumber, trackingNumber2: $trackingNumber2, pdfString: $pdfString)';
  }
}
