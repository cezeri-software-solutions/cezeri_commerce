import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../3_domain/entities/statistic/stat_dashboard.dart';
import '../../../constants.dart';
import '../../core/core.dart';
import 'stat_container.dart';

class MainSalesData extends StatelessWidget {
  final List<Receipt>? listOfAppointments;
  final StatDashboard? curStatDashboard;

  const MainSalesData({super.key, required this.listOfAppointments, required this.curStatDashboard});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final padding = switch (ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET)) {
      true => 20.0,
      false => 12.0,
    };
    final defStatContainerWidth = switch (ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET)) {
      true => screenWidth / 5 - padding,
      false => screenWidth / 2 - padding - padding / 2,
    };

    if (ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET)) {
      return Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatContainer(
                  title: 'Offene Aufträge seit letztem Werktag',
                  body: listOfAppointments!.length.toString(),
                  width: defStatContainerWidth,
                ),
                StatContainer(
                  title: 'Offene & bezahlte Aufträge seit letztem Werktag',
                  body: listOfAppointments!.where((e) => e.paymentStatus == PaymentStatus.paid).toList().length.toString(),
                  width: defStatContainerWidth,
                ),
                StatContainer(
                  title: 'Offene Angebote akt. Monat',
                  body: '${curStatDashboard!.offerVolume.toMyCurrencyStringToShow()} €',
                  width: defStatContainerWidth,
                ),
                StatContainer(
                  title: 'Auftragseingang akt. Monat',
                  body: '${curStatDashboard!.appointmentVolume.toMyCurrencyStringToShow()} €',
                  width: defStatContainerWidth,
                ),
                StatContainer(
                  title: 'Umsatz akt. Monat',
                  body: '${curStatDashboard!.invoiceVolume.toMyCurrencyStringToShow()} €',
                  width: defStatContainerWidth,
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatContainer(
                title: 'Offene Aufträge seit letztem Werktag',
                body: listOfAppointments!.length.toString(),
                width: defStatContainerWidth,
              ),
              StatContainer(
                title: 'Offene & bezahlte Aufträge seit letztem Werktag',
                body: listOfAppointments!.where((e) => e.paymentStatus == PaymentStatus.paid).toList().length.toString(),
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
                body: '${curStatDashboard!.offerVolume.toMyCurrencyStringToShow()} €',
                width: defStatContainerWidth,
              ),
              StatContainer(
                title: 'Auftragseingang akt. Monat',
                body: '${curStatDashboard!.appointmentVolume.toMyCurrencyStringToShow()} €',
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
                body: '${curStatDashboard!.invoiceVolume.toMyCurrencyStringToShow()} €',
                width: defStatContainerWidth,
              ),
            ],
          ),
          Gaps.h24,
        ],
      ),
    );
  }
}
