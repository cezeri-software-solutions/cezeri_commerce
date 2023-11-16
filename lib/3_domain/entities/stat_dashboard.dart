import 'package:json_annotation/json_annotation.dart';

part 'stat_dashboard.g.dart';

@JsonSerializable(explicitToJson: true)
class StatDashboard {
  // Wird durch Datum ermittelt
  final String statDashboardId;
  // Datum des letzten Eintrages
  final DateTime dateTime;
  // Auftragseingang
  final double incomingOrders;
  // Umsatz
  final double salesVolume;
  // Offene Aufträge
  final double offerVolume;

  StatDashboard({
    required this.statDashboardId,
    required this.dateTime,
    required this.incomingOrders,
    required this.salesVolume,
    required this.offerVolume,
  });

  factory StatDashboard.empty() {
    return StatDashboard(statDashboardId: '', dateTime: DateTime.now(), incomingOrders: 0, salesVolume: 0, offerVolume: 0);
  }

  factory StatDashboard.fromJson(Map<String, dynamic> json) => _$StatDashboardFromJson(json);

  Map<String, dynamic> toJson() => _$StatDashboardToJson(this);

  StatDashboard copyWith({
    String? statDashboardId,
    DateTime? dateTime,
    double? incomingOrders,
    double? salesVolume,
    double? offerVolume,
  }) {
    return StatDashboard(
      statDashboardId: statDashboardId ?? this.statDashboardId,
      dateTime: dateTime ?? this.dateTime,
      incomingOrders: incomingOrders ?? this.incomingOrders,
      salesVolume: salesVolume ?? this.salesVolume,
      offerVolume: offerVolume ?? this.offerVolume,
    );
  }

  @override
  String toString() {
    return 'StatDashboard(statDashboardId: $statDashboardId, dateTime: $dateTime, incomingOrders: $incomingOrders, salesVolume: $salesVolume, offerVolume: $offerVolume)';
  }
}
