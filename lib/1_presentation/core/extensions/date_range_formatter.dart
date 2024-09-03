import 'package:flutter/material.dart';

import '../../../3_domain/enums/enums.dart';

extension DateRangeTypeToStringExtension on DateRangeType {
  String toDateRangeString() => switch (this) {
        DateRangeType.today => 'Heute',
        DateRangeType.yesterday => 'Gestern',
        DateRangeType.thisWeek => 'Diese Woche (Mo bis Heute)',
        DateRangeType.last7Days => 'Letzte 7 Tage',
        DateRangeType.last30Days => 'Letzte 30 Tage',
        DateRangeType.last90Days => 'Letzte 90 Tage',
        DateRangeType.thisMonth => 'Dieser Monat (1. bis Heute)',
        DateRangeType.lastMonth => 'Letzter Monat',
        DateRangeType.thisYear => 'Dieses Jahr',
        DateRangeType.lastYear => 'Letztes Jahr',
      };
}

extension DateRangeTypeToDateRangeExtension on DateRangeType {
  DateTimeRange toDateRange() {
    final dateTimeNow = DateTime.now();
    final now = DateTime(dateTimeNow.year, dateTimeNow.month, dateTimeNow.day);

    return switch (this) {
      DateRangeType.today => DateTimeRange(start: now, end: now),
      DateRangeType.yesterday => DateTimeRange(start: now.subtract(const Duration(days: 1)), end: now.subtract(const Duration(days: 1))),
      DateRangeType.thisWeek => DateTimeRange(start: now.subtract(Duration(days: now.weekday - 1)), end: now),
      DateRangeType.last7Days => DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now),
      DateRangeType.last30Days => DateTimeRange(start: now.subtract(const Duration(days: 30)), end: now),
      DateRangeType.last90Days => DateTimeRange(start: now.subtract(const Duration(days: 90)), end: now),
      DateRangeType.thisMonth => DateTimeRange(start: DateTime(now.year, now.month, 1), end: now),
      DateRangeType.lastMonth => DateTimeRange(start: DateTime(now.year, now.month - 1, 1), end: DateTime(now.year, now.month, 0)),
      DateRangeType.thisYear => DateTimeRange(start: DateTime(now.year, 1, 1), end: now),
      DateRangeType.lastYear => DateTimeRange(start: DateTime(now.year - 1, 1, 1), end: DateTime(now.year - 1, 12, 31)),
    };
  }
}

extension DateRangeToCompareDateRangeExtension on DateTimeRange {
  DateTimeRange toCompareDateRange() {
    final compareStart = DateTime(start.year, start.month, start.day - duration.inDays - 1);
    final compareEnd = DateTime(start.year, start.month, start.day - 1);

    return DateTimeRange(start: compareStart, end: compareEnd);
  }
}

// Benutzerdefinierter Zeitraum