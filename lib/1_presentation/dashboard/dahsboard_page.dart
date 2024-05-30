import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../2_application/database/dashboard/dashboard_bloc.dart';
import '../../3_domain/entities/receipt/receipt.dart';
import '../../3_domain/enums/enums.dart';
import '../../constants.dart';
import 'widgets/line_chart_view.dart';
import 'widgets/stat_container.dart';

class DashboardPage extends StatelessWidget {
  final DashboardBloc dashboardBloc;

  const DashboardPage({super.key, required this.dashboardBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      bloc: dashboardBloc,
      builder: (context, state) {
        final screenWidth = MediaQuery.sizeOf(context).width;
        final responsiveness = screenWidth > 700 ? Responsiveness.isTablet : Responsiveness.isMobil;
        final padding = switch (responsiveness) {
          Responsiveness.isTablet => 20.0,
          Responsiveness.isMobil => 12.0,
        };
        final defStatContainerWidth = switch (responsiveness) {
          Responsiveness.isTablet => screenWidth / 5 - padding,
          Responsiveness.isMobil => screenWidth / 2 - padding - padding / 2,
        };

        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  children: [
                    if (responsiveness == Responsiveness.isTablet) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StatContainer(
                            title: 'Offene Aufträge seit letztem Werktag',
                            body: state.listOfAppointments!.length.toString(),
                            width: defStatContainerWidth,
                          ),
                          StatContainer(
                            title: 'Offene & bezahlte Aufträge seit letztem Werktag',
                            body: state.listOfAppointments!.where((e) => e.paymentStatus == PaymentStatus.paid).toList().length.toString(),
                            width: defStatContainerWidth,
                          ),
                          StatContainer(
                            title: 'Offene Angebote akt. Monat',
                            body: '${state.curStatDashboard!.offerVolume.toMyCurrencyStringToShow()} €',
                            width: defStatContainerWidth,
                          ),
                          StatContainer(
                            title: 'Auftragseingang akt. Monat',
                            body: '${state.curStatDashboard!.incomingOrders.toMyCurrencyStringToShow()} €',
                            width: defStatContainerWidth,
                          ),
                          StatContainer(
                            title: 'Umsatz akt. Monat',
                            body: '${state.curStatDashboard!.salesVolume.toMyCurrencyStringToShow()} €',
                            width: defStatContainerWidth,
                          ),
                        ],
                      ),
                      Gaps.h32,
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StatContainer(
                            title: 'Offene Aufträge seit letztem Werktag',
                            body: state.listOfAppointments!.length.toString(),
                            width: defStatContainerWidth,
                          ),
                          StatContainer(
                            title: 'Offene & bezahlte Aufträge seit letztem Werktag',
                            body: state.listOfAppointments!.where((e) => e.paymentStatus == PaymentStatus.paid).toList().length.toString(),
                            width: defStatContainerWidth,
                          ),
                        ],
                      ),
                      Gaps.h10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StatContainer(
                            title: 'Offene Angebote akt. Monat',
                            body: '${state.curStatDashboard!.offerVolume.toMyCurrencyStringToShow()} €',
                            width: defStatContainerWidth,
                          ),
                          StatContainer(
                            title: 'Auftragseingang akt. Monat',
                            body: '${state.curStatDashboard!.incomingOrders.toMyCurrencyStringToShow()} €',
                            width: defStatContainerWidth,
                          ),
                        ],
                      ),
                      Gaps.h10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StatContainer(
                            title: 'Umsatz akt. Monat',
                            body: '${state.curStatDashboard!.salesVolume.toMyCurrencyStringToShow()} €',
                            width: defStatContainerWidth,
                          ),
                        ],
                      ),
                      Gaps.h24,
                    ],
                  ],
                ),
              ),
              const Text('Auftragseingang pro Monat', style: TextStyles.h2Bold),
              LineChartView(listOfStatDashboards: state.listOfStatDashboards!, chartTyp: ChartType.incomingOrder),
              const Text('Umsatz pro Monat', style: TextStyles.h2Bold),
              LineChartView(listOfStatDashboards: state.listOfStatDashboards!, chartTyp: ChartType.salesVolume),
              
            ],
          ),
        );
      },
    );
  }
}
