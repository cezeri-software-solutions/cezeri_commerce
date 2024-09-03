import 'dart:math';

import 'package:cezeri_commerce/1_presentation/core/extensions/date_range_formatter.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../2_application/database/dashboard/dashboard_bloc.dart';
import '../../../3_domain/enums/enums.dart';

void selectDateRange(BuildContext context, DashboardBloc dashboardBloc, DashboardState dashboardState, DashboardType dashboardType) {
  TextStyle getTextStyle(DateTimeRange range) {
    final dateTimeRange = switch (dashboardType) {
      DashboardType.salesVolumePerBrand => dashboardState.dateRangeBrands,
      DashboardType.groupedSalesVolume => dashboardState.dateRangeGroups,
      DashboardType.salesVolumeBetweenDates => dashboardState.dateRangeStatSalesBetweenDatesMainPeriod,
    };

    final normalizedCurrentRange = DateTimeRange(
      start: DateTime(dateTimeRange.start.year, dateTimeRange.start.month, dateTimeRange.start.day),
      end: DateTime(dateTimeRange.end.year, dateTimeRange.end.month, dateTimeRange.end.day),
    );

    return normalizedCurrentRange == range ? const TextStyle(fontWeight: FontWeight.bold) : const TextStyle(fontWeight: FontWeight.normal);
  }

  bool isAnyPredefinedRangeSelected() {
    final dateTimeRange = switch (dashboardType) {
      DashboardType.salesVolumePerBrand => dashboardState.dateRangeBrands,
      DashboardType.groupedSalesVolume => dashboardState.dateRangeGroups,
      DashboardType.salesVolumeBetweenDates => dashboardState.dateRangeStatSalesBetweenDatesMainPeriod,
    };

    final normalizedCurrentRange = DateTimeRange(
      start: DateTime(dateTimeRange.start.year, dateTimeRange.start.month, dateTimeRange.start.day),
      end: DateTime(dateTimeRange.end.year, dateTimeRange.end.month, dateTimeRange.end.day),
    );

    return DateRangeType.values.any((type) {
      final range = type.toDateRange();
      return normalizedCurrentRange == range;
    });
  }

  WoltModalSheet.show(
    context: context,
    useSafeArea: false,
    showDragHandle: false,
    pageListBuilder: (woltContext) {
      return [
        WoltModalSheetPage(
          hasTopBarLayer: false,
          isTopBarLayerAlwaysVisible: false,
          child: Padding(
            padding: EdgeInsets.only(bottom: max(MediaQuery.paddingOf(context).bottom, 24)),
            child: Column(
              children: [
                ListTile(
                  title: Text(DateRangeType.today.toDateRangeString(), style: getTextStyle(DateRangeType.today.toDateRange())),
                  onTap: () {
                    dashboardBloc.add(switch (dashboardType) {
                      DashboardType.salesVolumePerBrand => SetProductSalesDateTimeRangeEvent(dateRange: DateRangeType.today.toDateRange()),
                      DashboardType.groupedSalesVolume => SetGroupsDateTimeRangeEvent(dateRange: DateRangeType.today.toDateRange()),
                      DashboardType.salesVolumeBetweenDates => SetStatSalesBetweenDatesTimeRangeEvent(dateRange: DateRangeType.today.toDateRange()),
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text(DateRangeType.yesterday.toDateRangeString(), style: getTextStyle(DateRangeType.yesterday.toDateRange())),
                  onTap: () {
                    dashboardBloc.add(switch (dashboardType) {
                      DashboardType.salesVolumePerBrand => SetProductSalesDateTimeRangeEvent(dateRange: DateRangeType.yesterday.toDateRange()),
                      DashboardType.groupedSalesVolume => SetGroupsDateTimeRangeEvent(dateRange: DateRangeType.yesterday.toDateRange()),
                      DashboardType.salesVolumeBetweenDates =>
                        SetStatSalesBetweenDatesTimeRangeEvent(dateRange: DateRangeType.yesterday.toDateRange()),
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text(DateRangeType.thisWeek.toDateRangeString(), style: getTextStyle(DateRangeType.thisWeek.toDateRange())),
                  onTap: () {
                    dashboardBloc.add(switch (dashboardType) {
                      DashboardType.salesVolumePerBrand => SetProductSalesDateTimeRangeEvent(dateRange: DateRangeType.thisWeek.toDateRange()),
                      DashboardType.groupedSalesVolume => SetGroupsDateTimeRangeEvent(dateRange: DateRangeType.thisWeek.toDateRange()),
                      DashboardType.salesVolumeBetweenDates =>
                        SetStatSalesBetweenDatesTimeRangeEvent(dateRange: DateRangeType.thisWeek.toDateRange()),
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text(DateRangeType.last7Days.toDateRangeString(), style: getTextStyle(DateRangeType.last7Days.toDateRange())),
                  onTap: () {
                    dashboardBloc.add(switch (dashboardType) {
                      DashboardType.salesVolumePerBrand => SetProductSalesDateTimeRangeEvent(dateRange: DateRangeType.last7Days.toDateRange()),
                      DashboardType.groupedSalesVolume => SetGroupsDateTimeRangeEvent(dateRange: DateRangeType.last7Days.toDateRange()),
                      DashboardType.salesVolumeBetweenDates =>
                        SetStatSalesBetweenDatesTimeRangeEvent(dateRange: DateRangeType.last7Days.toDateRange()),
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text(DateRangeType.last30Days.toDateRangeString(), style: getTextStyle(DateRangeType.last30Days.toDateRange())),
                  onTap: () {
                    dashboardBloc.add(switch (dashboardType) {
                      DashboardType.salesVolumePerBrand => SetProductSalesDateTimeRangeEvent(dateRange: DateRangeType.last30Days.toDateRange()),
                      DashboardType.groupedSalesVolume => SetGroupsDateTimeRangeEvent(dateRange: DateRangeType.last30Days.toDateRange()),
                      DashboardType.salesVolumeBetweenDates =>
                        SetStatSalesBetweenDatesTimeRangeEvent(dateRange: DateRangeType.last30Days.toDateRange()),
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text(DateRangeType.last90Days.toDateRangeString(), style: getTextStyle(DateRangeType.last90Days.toDateRange())),
                  onTap: () {
                    dashboardBloc.add(switch (dashboardType) {
                      DashboardType.salesVolumePerBrand => SetProductSalesDateTimeRangeEvent(dateRange: DateRangeType.last90Days.toDateRange()),
                      DashboardType.groupedSalesVolume => SetGroupsDateTimeRangeEvent(dateRange: DateRangeType.last90Days.toDateRange()),
                      DashboardType.salesVolumeBetweenDates =>
                        SetStatSalesBetweenDatesTimeRangeEvent(dateRange: DateRangeType.last90Days.toDateRange()),
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text(DateRangeType.thisMonth.toDateRangeString(), style: getTextStyle(DateRangeType.thisMonth.toDateRange())),
                  onTap: () {
                    dashboardBloc.add(switch (dashboardType) {
                      DashboardType.salesVolumePerBrand => SetProductSalesDateTimeRangeEvent(dateRange: DateRangeType.thisMonth.toDateRange()),
                      DashboardType.groupedSalesVolume => SetGroupsDateTimeRangeEvent(dateRange: DateRangeType.thisMonth.toDateRange()),
                      DashboardType.salesVolumeBetweenDates =>
                        SetStatSalesBetweenDatesTimeRangeEvent(dateRange: DateRangeType.thisMonth.toDateRange()),
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text(DateRangeType.lastMonth.toDateRangeString(), style: getTextStyle(DateRangeType.lastMonth.toDateRange())),
                  onTap: () {
                    dashboardBloc.add(switch (dashboardType) {
                      DashboardType.salesVolumePerBrand => SetProductSalesDateTimeRangeEvent(dateRange: DateRangeType.lastMonth.toDateRange()),
                      DashboardType.groupedSalesVolume => SetGroupsDateTimeRangeEvent(dateRange: DateRangeType.lastMonth.toDateRange()),
                      DashboardType.salesVolumeBetweenDates =>
                        SetStatSalesBetweenDatesTimeRangeEvent(dateRange: DateRangeType.lastMonth.toDateRange()),
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text(DateRangeType.thisYear.toDateRangeString(), style: getTextStyle(DateRangeType.thisYear.toDateRange())),
                  onTap: () {
                    dashboardBloc.add(switch (dashboardType) {
                      DashboardType.salesVolumePerBrand => SetProductSalesDateTimeRangeEvent(dateRange: DateRangeType.thisYear.toDateRange()),
                      DashboardType.groupedSalesVolume => SetGroupsDateTimeRangeEvent(dateRange: DateRangeType.thisYear.toDateRange()),
                      DashboardType.salesVolumeBetweenDates =>
                        SetStatSalesBetweenDatesTimeRangeEvent(dateRange: DateRangeType.thisYear.toDateRange()),
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text(DateRangeType.lastYear.toDateRangeString(), style: getTextStyle(DateRangeType.lastYear.toDateRange())),
                  onTap: () {
                    dashboardBloc.add(switch (dashboardType) {
                      DashboardType.salesVolumePerBrand => SetProductSalesDateTimeRangeEvent(dateRange: DateRangeType.lastYear.toDateRange()),
                      DashboardType.groupedSalesVolume => SetGroupsDateTimeRangeEvent(dateRange: DateRangeType.lastYear.toDateRange()),
                      DashboardType.salesVolumeBetweenDates =>
                        SetStatSalesBetweenDatesTimeRangeEvent(dateRange: DateRangeType.lastYear.toDateRange()),
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text(
                    'Zeitraum auswählen',
                    style: isAnyPredefinedRangeSelected()
                        ? const TextStyle(fontWeight: FontWeight.normal)
                        : const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showDateRangePicker(
                      context: context,
                      dashboardBloc: dashboardBloc,
                      initialDateRange: switch (dashboardType) {
                        DashboardType.salesVolumePerBrand => dashboardState.dateRangeBrands,
                        DashboardType.groupedSalesVolume => dashboardState.dateRangeGroups,
                        DashboardType.salesVolumeBetweenDates => dashboardState.dateRangeStatSalesBetweenDatesMainPeriod,
                      },
                      dashboardType: dashboardType,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ];
    },
  );
}

Future<void> _showDateRangePicker({
  required BuildContext context,
  required DashboardBloc dashboardBloc,
  required DateTimeRange initialDateRange,
  required DashboardType dashboardType,
}) async {
  final now = DateTime.now();
  final initialStartDate = initialDateRange.start;
  final initialEndDate = DateTime(initialDateRange.end.year, initialDateRange.end.month, initialDateRange.end.day);

  final newDateRange = await showDateRangePicker(
    context: context,
    initialDateRange: DateTimeRange(start: initialStartDate, end: initialEndDate),
    firstDate: DateTime(now.year - 2),
    lastDate: now,
  );

  if (newDateRange != null) {
    switch (dashboardType) {
      case DashboardType.salesVolumeBetweenDates:
        dashboardBloc.add(SetStatSalesBetweenDatesTimeRangeEvent(dateRange: newDateRange));
        break;
      case DashboardType.groupedSalesVolume:
        dashboardBloc.add(SetGroupsDateTimeRangeEvent(dateRange: newDateRange));
        break;
      case DashboardType.salesVolumePerBrand:
        dashboardBloc.add(SetProductSalesDateTimeRangeEvent(dateRange: newDateRange));
        break;
    }
  }
}
