import 'package:cezeri_commerce/1_presentation/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:redacted/redacted.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../2_application/database/dashboard/dashboard_bloc.dart';
import '../../3_domain/entities/statistic/stat_dashboard.dart';
import '../../3_domain/entities/statistic/stat_sales_grouped.dart';
import '../../3_domain/entities/statistic/stat_sales_per_day.dart';
import '../../3_domain/enums/enums.dart';
import '../../constants.dart';
import 'functions/select_date_range.dart';
import 'widgets/data_this_month_last_month.dart';
import 'widgets/line_chart_view_last_13_month.dart';
import 'widgets/line_chart_view_this_month.dart';
import 'widgets/main_sales_data.dart';
import 'widgets/sales_by_brand_chart.dart';
import 'widgets/sales_grouped_by_country.dart';

class DashboardPage extends StatelessWidget {
  final DashboardBloc dashboardBloc;

  const DashboardPage({super.key, required this.dashboardBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      bloc: dashboardBloc,
      builder: (context, state) {
        final isTablet = ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET);

        final padding = switch (isTablet) {
          true => 16.0,
          false => 8.0,
        };

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainSalesData(listOfAppointments: state.listOfAppointments!, curStatDashboard: state.curStatDashboard!),
              _SalesVolumeThisMonthLastMonthChart(dashboardBloc: dashboardBloc, dashboardState: state, padding: padding),
              _SalesVolumeThisMonthPerMarketplaceChart(dashboardState: state, padding: padding),
              _SalesVolumeMainPeriodComparePeriodChart(dashboardBloc: dashboardBloc, dashboardState: state, padding: padding),
              _SalesVolumeMainPeriodComparePeriodPerMarketplaceChart(dashboardState: state, padding: padding),
              _SalesVolumePerMonthLast13MonthsChart(listOfStatDashboards: state.listOfStatDashboards!, padding: padding),
              Gaps.h24,
              _SalesVolumePerBrand(dashboardBloc: dashboardBloc, dashboardState: state, padding: padding),
              Gaps.h24,
              _SalesVolumeGroupedHeader(
                dashboardBloc: dashboardBloc,
                dashboardState: state,
                listOfSalesVolumeGrouped: state.salesVolumeGroupedByCountry,
                padding: padding,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: isTablet
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _SalesVolumeGrouped(title: 'Länder', listOfSalesVolumeGrouped: state.salesVolumeGroupedByCountry, dashboardState: state),
                          _SalesVolumeGrouped(
                              title: 'Marktplätze', listOfSalesVolumeGrouped: state.salesVolumeGroupedByMarketplace, dashboardState: state),
                        ],
                      )
                    : Column(
                        children: [
                          _SalesVolumeGrouped(title: 'Länder', listOfSalesVolumeGrouped: state.salesVolumeGroupedByCountry, dashboardState: state),
                          _SalesVolumeGrouped(
                              title: 'Marktplätze', listOfSalesVolumeGrouped: state.salesVolumeGroupedByMarketplace, dashboardState: state),
                        ],
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 16,
                  runSpacing: 16,
                  children: state.salesVolumeGroupedByMarketplaceAndCountry!.map((grouped) {
                    return _SalesVolumeGrouped(title: grouped.marketplace, listOfSalesVolumeGrouped: grouped.countries, dashboardState: state);
                  }).toList(),
                ),
              ),
              Gaps.h42,
            ],
          ),
        );
      },
    );
  }
}

class _SelectDateRangeCard extends StatelessWidget {
  final DashboardBloc dashboardBloc;
  final DashboardState dashboardState;
  final DateTimeRange dateRange;
  final DashboardType dashboardType;

  const _SelectDateRangeCard({required this.dashboardBloc, required this.dashboardState, required this.dateRange, required this.dashboardType});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => selectDateRange(context, dashboardBloc, dashboardState, dashboardType),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${DateFormat('dd.MM.yyy', 'de').format(dateRange.start)} - ${DateFormat('dd.MM.yyy', 'de').format(DateTime(dateRange.end.year, dateRange.end.month, dateRange.end.day))}',
            style: TextStyles.defaultBold,
          ),
        ),
      ),
    );
  }
}

class _SalesVolumeThisMonthLastMonthChart extends StatelessWidget {
  final DashboardBloc dashboardBloc;
  final DashboardState dashboardState;
  final double padding;

  const _SalesVolumeThisMonthLastMonthChart({required this.dashboardBloc, required this.dashboardState, required this.padding});

  @override
  Widget build(BuildContext context) {
    if (dashboardState.isFailureStatSalesBetweenDatesThisMonth) return const Center(child: Text('Beim Laden der Daten ist ein Fehler aufgetreten!'));
    if (dashboardState.listOfStatSalesBetweenDatesThisMonth!.listOfStatSalesPerDay.isEmpty) {
      return const Center(child: Text('Für den ausgewählten Zeitraum sind keine Daten in der Datenbank enthalten.'));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.all(padding),
          child: const Text.rich(
            TextSpan(
              text: 'Umsatz pro Tag ',
              style: TextStyles.h2Bold,
              children: [TextSpan(text: '(Akt. Monat) im Vergleich zum letzten Monat', style: TextStyles.defaultt)],
            ),
          ),
        ),
        DataThisMonthLastMonth(
          dashboardBloc: dashboardBloc,
          statSalesThisMonth: dashboardState.listOfStatSalesBetweenDatesThisMonth!,
          statSalesLastMonth: dashboardState.listOfStatSalesBetweenDatesLastMonth ?? StatSalesBetweenDates.empty(),
        ),
        LineChartViewThisMonth(
          dataMainPeriod: dashboardState.listOfStatSalesBetweenDatesThisMonth!,
          dataComparePeriod: dashboardState.listOfStatSalesBetweenDatesLastMonth ?? StatSalesBetweenDates.empty(),
        ),
      ],
    ).redacted(context: context, redact: dashboardState.isLoadingStatSalesBetweenDatesThisMonth);
  }
}

class _SalesVolumeThisMonthPerMarketplaceChart extends StatelessWidget {
  final DashboardState dashboardState;
  final double padding;

  const _SalesVolumeThisMonthPerMarketplaceChart({required this.dashboardState, required this.padding});

  @override
  Widget build(BuildContext context) {
    if (dashboardState.isFailureStatSalesBetweenDatesThisMonth) return const Center(child: Text('Beim Laden der Daten ist ein Fehler aufgetreten!'));
    if (dashboardState.listOfStatSalesBetweenDatesThisMonth!.listOfStatSalesPerDay.isEmpty) {
      return const Center(child: Text('Für den ausgewählten Zeitraum sind keine Daten in der Datenbank enthalten.'));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.all(padding),
          child: const Text.rich(
            TextSpan(
              text: 'Umsatz pro Tag ',
              style: TextStyles.h2Bold,
              children: [TextSpan(text: '(Akt. Monat) je Marktplatz', style: TextStyles.defaultt)],
            ),
          ),
        ),
        LineChartViewThisMonth(dataMainPeriod: dashboardState.listOfStatSalesBetweenDatesThisMonth!),
      ],
    ).redacted(context: context, redact: dashboardState.isLoadingStatSalesBetweenDatesThisMonth);
  }
}

class _SalesVolumeMainPeriodComparePeriodChart extends StatelessWidget {
  final DashboardBloc dashboardBloc;
  final DashboardState dashboardState;
  final double padding;

  const _SalesVolumeMainPeriodComparePeriodChart({required this.dashboardBloc, required this.dashboardState, required this.padding});

  @override
  Widget build(BuildContext context) {
    if (dashboardState.isFailureStatSalesBetweenDatesMainPeriod) return const Center(child: Text('Beim Laden der Daten ist ein Fehler aufgetreten!'));
    if (dashboardState.listOfStatSalesBetweenDatesMainPeriod!.listOfStatSalesPerDay.isEmpty) {
      return const Center(child: Text('Für den ausgewählten Zeitraum sind keine Daten in der Datenbank enthalten.'));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            children: [
              const Text.rich(
                TextSpan(
                  text: 'Umsatz pro Tag ',
                  style: TextStyles.h2Bold,
                  children: [TextSpan(text: '(Akt. Periode) im Vergleich zur letzten Periode', style: TextStyles.defaultt)],
                ),
              ),
              Gaps.h10,
              Align(
                alignment: Alignment.centerLeft,
                child: _SelectDateRangeCard(
                  dashboardBloc: dashboardBloc,
                  dashboardState: dashboardState,
                  dateRange: DateTimeRange(
                    start: dashboardState.dateRangeStatSalesBetweenDatesMainPeriod.start,
                    end: dashboardState.dateRangeStatSalesBetweenDatesMainPeriod.end,
                  ),
                  dashboardType: DashboardType.salesVolumeBetweenDates,
                ),
              ),
            ],
          ),
        ),
        DataThisMonthLastMonth(
          dashboardBloc: dashboardBloc,
          statSalesThisMonth: dashboardState.listOfStatSalesBetweenDatesMainPeriod!,
          statSalesLastMonth: dashboardState.listOfStatSalesBetweenDatesComparePeriod ?? StatSalesBetweenDates.empty(),
        ),
        LineChartViewThisMonth(
          dataMainPeriod: dashboardState.listOfStatSalesBetweenDatesMainPeriod!,
          dataComparePeriod: dashboardState.listOfStatSalesBetweenDatesComparePeriod ?? StatSalesBetweenDates.empty(),
        ),
      ],
    ).redacted(context: context, redact: dashboardState.isLoadingStatSalesBetweenDatesMainPeriod);
  }
}

class _SalesVolumeMainPeriodComparePeriodPerMarketplaceChart extends StatelessWidget {
  final DashboardState dashboardState;
  final double padding;

  const _SalesVolumeMainPeriodComparePeriodPerMarketplaceChart({required this.dashboardState, required this.padding});

  @override
  Widget build(BuildContext context) {
    if (dashboardState.isFailureStatSalesBetweenDatesMainPeriod) return const Center(child: Text('Beim Laden der Daten ist ein Fehler aufgetreten!'));
    if (dashboardState.listOfStatSalesBetweenDatesMainPeriod!.listOfStatSalesPerDay.isEmpty) {
      return const Center(child: Text('Für den ausgewählten Zeitraum sind keine Daten in der Datenbank enthalten.'));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.all(padding),
          child: const Text.rich(
            TextSpan(
              text: 'Umsatz pro Tag ',
              style: TextStyles.h2Bold,
              children: [TextSpan(text: '(Akt. Periode) je Marktplatz', style: TextStyles.defaultt)],
            ),
          ),
        ),
        LineChartViewThisMonth(dataMainPeriod: dashboardState.listOfStatSalesBetweenDatesMainPeriod!),
      ],
    ).redacted(context: context, redact: dashboardState.isLoadingStatSalesBetweenDatesMainPeriod);
  }
}

class _SalesVolumePerMonthLast13MonthsChart extends StatelessWidget {
  final List<StatDashboard> listOfStatDashboards;
  final double padding;

  const _SalesVolumePerMonthLast13MonthsChart({required this.listOfStatDashboards, required this.padding});

  @override
  Widget build(BuildContext context) {
    if (ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET)) {
      return Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.all(padding), child: const Text('Auftragseingang pro Monat', style: TextStyles.h2Bold)),
                LineChartViewLast13Month(listOfStatDashboards: listOfStatDashboards, chartTyp: ChartType.incomingOrder),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.all(padding), child: const Text('Umsatz pro Monat', style: TextStyles.h2Bold)),
                LineChartViewLast13Month(listOfStatDashboards: listOfStatDashboards, chartTyp: ChartType.salesVolume),
              ],
            ),
          )
        ],
      );
    } else {
      return Column(
        children: [
          Padding(padding: EdgeInsets.all(padding), child: const Text('Auftragseingang pro Monat', style: TextStyles.h2Bold)),
          LineChartViewLast13Month(listOfStatDashboards: listOfStatDashboards, chartTyp: ChartType.incomingOrder),
          Padding(padding: EdgeInsets.all(padding), child: const Text('Umsatz pro Monat', style: TextStyles.h2Bold)),
          LineChartViewLast13Month(listOfStatDashboards: listOfStatDashboards, chartTyp: ChartType.salesVolume),
        ],
      );
    }
  }
}

class _SalesVolumePerBrand extends StatelessWidget {
  final DashboardBloc dashboardBloc;
  final DashboardState dashboardState;
  final double padding;

  const _SalesVolumePerBrand({required this.dashboardBloc, required this.dashboardState, required this.padding});

  @override
  Widget build(BuildContext context) {
    final screenHeight = context.screenHeight;
    final screenWidth = context.screenWidth;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Umsatz nach Hersteller', style: TextStyles.h2Bold),
                  IconButton(
                    onPressed: () => dashboardBloc.add(GetListOfProductSalesByBrandEvent()),
                    icon: const Icon(Icons.refresh),
                  )
                ],
              ),
              _SelectDateRangeCard(
                dashboardBloc: dashboardBloc,
                dashboardState: dashboardState,
                dateRange: DateTimeRange(start: dashboardState.dateRangeBrands.start, end: dashboardState.dateRangeBrands.end),
                dashboardType: DashboardType.salesVolumePerBrand,
              ),
            ],
          ),
        ),
        SizedBox(
          width: screenWidth,
          height: ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET) ? 300 : screenHeight / 2,
          child: SalesByBrandChart(
            listOfSalesByBrand: dashboardState.listOfProductSalesByBrand!,
            isLoadingProductSalesByBrand: dashboardState.isLoadingProductSalesByBrand,
            isFailureOnProductSalesByBrand: dashboardState.isFailureOnProductSalesByBrand,
          ),
        ),
      ],
    );
  }
}

class _SalesVolumeGroupedHeader extends StatelessWidget {
  final DashboardBloc dashboardBloc;
  final DashboardState dashboardState;
  final List<StatSalesGrouped>? listOfSalesVolumeGrouped;
  final double padding;

  const _SalesVolumeGroupedHeader({
    required this.dashboardBloc,
    required this.dashboardState,
    required this.listOfSalesVolumeGrouped,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Gruppierter Umsatz nach', style: TextStyles.h2Bold),
              IconButton(
                onPressed: () => dashboardBloc.add(GetListOfProductSalesByBrandEvent()),
                icon: const Icon(Icons.refresh),
              )
            ],
          ),
          _SelectDateRangeCard(
            dashboardBloc: dashboardBloc,
            dashboardState: dashboardState,
            dateRange: DateTimeRange(start: dashboardState.dateRangeGroups.start, end: dashboardState.dateRangeGroups.end),
            dashboardType: DashboardType.groupedSalesVolume,
          ),
          Gaps.h8,
          if (listOfSalesVolumeGrouped != null && listOfSalesVolumeGrouped!.isNotEmpty)
            Text('Umsatz: ${listOfSalesVolumeGrouped?.first.totalNetSum.toMyCurrencyStringToShow()} €', style: TextStyles.h3BoldPrimary),
        ],
      ),
    );
  }
}

class _SalesVolumeGrouped extends StatelessWidget {
  final String title;
  final List<StatSalesGrouped>? listOfSalesVolumeGrouped;
  final DashboardState dashboardState;

  const _SalesVolumeGrouped({required this.title, required this.listOfSalesVolumeGrouped, required this.dashboardState});

  @override
  Widget build(BuildContext context) {
    final screenHeight = context.screenHeight;
    final screenWidth = context.screenWidth;
    final isTablet = ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET);

    return Card(
      color: const Color.fromARGB(240, 255, 255, 255),
      child: Column(
        children: [
          Text(title, style: TextStyles.h2Bold),
          Gaps.h10,
          SizedBox(
            width: isTablet ? screenWidth / 2 - 32 : screenWidth,
            height: isTablet ? 350 : screenHeight / 2,
            child: SalesGroupedByCountry(
              listOfSalesVolumeGrouped: listOfSalesVolumeGrouped,
              isLoadingProductSalesByBrand: dashboardState.isLoadingProductSalesByBrand,
              isFailureOnGroups: dashboardState.isFailureOnGroups,
            ),
          ),
        ],
      ),
    );
  }
}
