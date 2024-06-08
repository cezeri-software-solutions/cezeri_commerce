import 'package:cezeri_commerce/1_presentation/core/widgets/my_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../2_application/database/dashboard/dashboard_bloc.dart';
import '../../3_domain/enums/enums.dart';
import '../../constants.dart';
import 'widgets/line_chart_view.dart';
import 'widgets/main_sales_data.dart';
import 'widgets/sales_by_brand_chart.dart';

class DashboardPage extends StatelessWidget {
  final DashboardBloc dashboardBloc;

  const DashboardPage({super.key, required this.dashboardBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      bloc: dashboardBloc,
      builder: (context, state) {
        final screenHeight = MediaQuery.sizeOf(context).height;
        final screenWidth = MediaQuery.sizeOf(context).width;

        final isTablet = ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET);

        final padding = switch (ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET)) {
          true => 16.0,
          false => 8.0,
        };

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainSalesData(listOfAppointments: state.listOfAppointments!, curStatDashboard: state.curStatDashboard!),
              Padding(
                padding: EdgeInsets.all(padding),
                child: const Text('Auftragseingang pro Monat', style: TextStyles.h2Bold),
              ),
              LineChartView(listOfStatDashboards: state.listOfStatDashboards!, chartTyp: ChartType.incomingOrder),
              Padding(
                padding: EdgeInsets.all(padding),
                child: const Text('Umsatz pro Monat', style: TextStyles.h2Bold),
              ),
              LineChartView(listOfStatDashboards: state.listOfStatDashboards!, chartTyp: ChartType.salesVolume),
              Gaps.h24,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${DateFormat('dd.MM.yyy', 'de').format(state.dateRangeBrands.start)} - ${DateFormat('dd.MM.yyy', 'de').format(DateTime(state.dateRangeBrands.end.year, state.dateRangeBrands.end.month, state.dateRangeBrands.end.day - 1))}',
                          style: TextStyles.defaultBold,
                        ),
                        IconButton(
                          onPressed: () => _showDateRangePicker(context, dashboardBloc, state.dateRangeBrands),
                          icon: const Icon(Icons.date_range, color: CustomColors.primaryColor),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              if (state.isLoadingProductSalesByBrand)
                SizedBox(height: isTablet ? 300 : screenHeight / 2, child: const Center(child: MyCircularProgressIndicator()))
              else if (state.isFailureOnProductSalesByBrand)
                SizedBox(
                    height: isTablet ? 300 : screenHeight / 2, child: const Center(child: Text('Beim Laden der Daten ist ein Fehler aufgetreten!')))
              else
                SizedBox(
                  width: screenWidth,
                  height: isTablet ? 300 : screenHeight / 2,
                  child: SalesByBrandChart(listOfSalesByBrand: state.listOfProductSalesByBrand!),
                ),
              Gaps.h42,
            ],
          ),
        );
      },
    );
  }
}

Future<void> _showDateRangePicker(BuildContext context, DashboardBloc dashboardBloc, DateTimeRange initialDateRange) async {
  final now = DateTime.now();

  final init = DateTimeRange(
    start: initialDateRange.start,
    end: DateTime(initialDateRange.end.year, initialDateRange.end.month, initialDateRange.end.day - 1),
  );

  final newDateRange = await showDateRangePicker(
    context: context,
    initialDateRange: init,
    firstDate: DateTime(now.year - 1),
    lastDate: now,
  );

  if (newDateRange != null) dashboardBloc.add(SetProductSalesDateTimeRangeEvent(dateRange: newDateRange));
}
