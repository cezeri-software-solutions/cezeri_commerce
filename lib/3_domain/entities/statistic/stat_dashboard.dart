import 'package:json_annotation/json_annotation.dart';

part 'stat_dashboard.g.dart';

@JsonSerializable(explicitToJson: true)
class StatDashboard {
  final String id;
  final String month;
  @JsonKey(name: 'offer_volume')
  final double offerVolume;
  @JsonKey(name: 'appointment_volume')
  final double appointmentVolume;
  @JsonKey(name: 'invoice_volume')
  final double invoiceVolume;
  @JsonKey(name: 'credit_volume')
  final double creditVolume;
  @JsonKey(name: 'last_editing_date')
  final DateTime lastEditingDate;
  @JsonKey(name: 'creation_date')
  final DateTime creationDate;

  StatDashboard({
    required this.id,
    required this.month,
    required this.offerVolume,
    required this.appointmentVolume,
    required this.invoiceVolume,
    required this.creditVolume,
    required this.lastEditingDate,
    required this.creationDate,
  });

  factory StatDashboard.fromJson(Map<String, dynamic> json) => _$StatDashboardFromJson(json);

  Map<String, dynamic> toJson() => _$StatDashboardToJson(this);

  factory StatDashboard.empty() {
    return StatDashboard(
      id: '',
      month: '',
      offerVolume: 0,
      appointmentVolume: 0,
      invoiceVolume: 0,
      creditVolume: 0,
      lastEditingDate: DateTime.now(),
      creationDate: DateTime.now(),
    );
  }

  StatDashboard copyWith({
    String? id,
    String? month,
    double? offerVolume,
    double? appointmentVolume,
    double? invoiceVolume,
    double? creditVolume,
    DateTime? lastEditingDate,
    DateTime? creationDate,
  }) {
    return StatDashboard(
      id: id ?? this.id,
      month: month ?? this.month,
      offerVolume: offerVolume ?? this.offerVolume,
      appointmentVolume: appointmentVolume ?? this.appointmentVolume,
      invoiceVolume: invoiceVolume ?? this.invoiceVolume,
      creditVolume: creditVolume ?? this.creditVolume,
      lastEditingDate: lastEditingDate ?? this.lastEditingDate,
      creationDate: creationDate ?? this.creationDate,
    );
  }

  @override
  String toString() {
    return 'StatDashboard(id: $id, month: $month, offerVolume: $offerVolume, appointmentVolume: $appointmentVolume, invoiceVolume: $invoiceVolume, creditVolume: $creditVolume, lastEditingDate: $lastEditingDate, creationDate: $creationDate)';
  }
}
