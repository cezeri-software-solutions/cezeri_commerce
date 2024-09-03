import 'package:cezeri_commerce/1_presentation/core/core.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../2_application/database/dashboard/dashboard_bloc.dart';
import '../../../3_domain/entities/statistic/stat_sales_per_day.dart';
import '../../../constants.dart';
import 'stat_container_compared.dart';

class DataThisMonthLastMonth extends StatelessWidget {
  final DashboardBloc dashboardBloc;
  final StatSalesBetweenDates statSalesThisMonth;
  final StatSalesBetweenDates statSalesLastMonth;

  const DataThisMonthLastMonth({super.key, required this.dashboardBloc, required this.statSalesThisMonth, required this.statSalesLastMonth});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isTabletOrLarger = ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET);
    final padding = isTabletOrLarger ? 20.0 : 12.0;
    final defStatContainerWidth = isTabletOrLarger ? screenWidth / 5 - padding : screenWidth / 2 - padding - padding / 2;

    if (isTabletOrLarger) {
      return Padding(
        padding: EdgeInsets.all(padding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _statContainer(statSalesThisMonth, statSalesLastMonth, defStatContainerWidth),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(padding),
      child: SizedBox(
        height: 140,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _statContainer(statSalesThisMonth, statSalesLastMonth, defStatContainerWidth).length,
          separatorBuilder: (context, index) => Gaps.w12,
          itemBuilder: (context, index) => _statContainer(statSalesThisMonth, statSalesLastMonth, defStatContainerWidth)[index],
        ),
      ),
    );
  }
}

List<Widget> _statContainer(statSalesThisMonth, statSalesLastMonth, defStatContainerWidth) {
  return [
    _SalesVolume(statSalesThisMonth: statSalesThisMonth, statSalesLastMonth: statSalesLastMonth, containerWidth: defStatContainerWidth),
    _SalesVolumeAverage(
      statSalesThisMonth: statSalesThisMonth,
      statSalesLastMonth: statSalesLastMonth,
      containerWidth: defStatContainerWidth,
    ),
    _BasketAverage(statSalesThisMonth: statSalesThisMonth, statSalesLastMonth: statSalesLastMonth, containerWidth: defStatContainerWidth),
    _SalesCount(statSalesThisMonth: statSalesThisMonth, statSalesLastMonth: statSalesLastMonth, containerWidth: defStatContainerWidth),
    _SalesCountAverage(
      statSalesThisMonth: statSalesThisMonth,
      statSalesLastMonth: statSalesLastMonth,
      containerWidth: defStatContainerWidth,
    ),
  ];
}

class _SalesVolume extends StatelessWidget {
  final StatSalesBetweenDates statSalesThisMonth;
  final StatSalesBetweenDates statSalesLastMonth;
  final double containerWidth;

  const _SalesVolume({required this.statSalesThisMonth, required this.statSalesLastMonth, required this.containerWidth});

  @override
  Widget build(BuildContext context) {
    final salesThis = statSalesThisMonth.totalNetSum;
    final salesLast = statSalesLastMonth.totalNetSum;

    final isWin = salesThis > salesLast;

    final color = isWin ? Colors.green : Colors.red;

    double dif = 0;

    if (salesThis > salesLast) {
      dif = (((salesLast * 100) / salesThis) - 100) * -1;
    } else {
      dif = (((salesThis * 100) / salesLast) - 100) * -1;
    }

    final icon = Icon(isWin ? Icons.keyboard_double_arrow_up : Icons.keyboard_double_arrow_down, color: color, size: 20);
    final text = Text('${dif.toMyCurrencyString()} %', style: TextStyle(color: color));

    return StatContainerCompared(
      title: 'Umsatz',
      value1: '${salesThis.toMyCurrencyStringToShow()} €',
      value2: '${salesLast.toMyCurrencyStringToShow()} €',
      thirdLine: Row(mainAxisAlignment: MainAxisAlignment.center, children: [icon, text]),
      width: containerWidth,
    );
  }
}

class _SalesVolumeAverage extends StatelessWidget {
  final StatSalesBetweenDates statSalesThisMonth;
  final StatSalesBetweenDates statSalesLastMonth;
  final double containerWidth;

  const _SalesVolumeAverage({required this.statSalesThisMonth, required this.statSalesLastMonth, required this.containerWidth});

  @override
  Widget build(BuildContext context) {
    final salesAverageThis = statSalesThisMonth.averageTotalAmount;
    final salesAverageLast = statSalesLastMonth.averageTotalAmount;

    final isWin = salesAverageThis > salesAverageLast;

    final color = isWin ? Colors.green : Colors.red;

    double dif = 0;

    if (salesAverageThis > salesAverageLast) {
      dif = (((salesAverageLast * 100) / salesAverageThis) - 100) * -1;
    } else {
      dif = (((salesAverageThis * 100) / salesAverageLast) - 100) * -1;
    }

    final icon = Icon(isWin ? Icons.keyboard_double_arrow_up : Icons.keyboard_double_arrow_down, color: color, size: 20);
    final text = Text('${dif.toMyCurrencyString()} %', style: TextStyle(color: color));

    return StatContainerCompared(
      title: 'Durchschnittlicher Umsatz pro Tag',
      value1: '${salesAverageThis.toMyCurrencyStringToShow()} €',
      value2: '${salesAverageLast.toMyCurrencyStringToShow()} €',
      thirdLine: Row(mainAxisAlignment: MainAxisAlignment.center, children: [icon, text]),
      width: containerWidth,
    );
  }
}

class _BasketAverage extends StatelessWidget {
  final StatSalesBetweenDates statSalesThisMonth;
  final StatSalesBetweenDates statSalesLastMonth;
  final double containerWidth;

  const _BasketAverage({required this.statSalesThisMonth, required this.statSalesLastMonth, required this.containerWidth});

  @override
  Widget build(BuildContext context) {
    final salesAverageThis = statSalesThisMonth.averageTotalAmount;
    final salesAverageLast = statSalesLastMonth.averageTotalAmount;

    final salesCountAverageThis = statSalesThisMonth.averageTotalCount;
    final salesCountAverageLast = statSalesLastMonth.averageTotalCount;

    final basketAverageThis = salesAverageThis / salesCountAverageThis;
    final basketAverageLast = salesAverageLast / salesCountAverageLast;

    final isWin = basketAverageThis > basketAverageLast;

    final color = isWin ? Colors.green : Colors.red;

    double dif = 0;

    if (basketAverageThis > basketAverageLast) {
      dif = (((basketAverageLast * 100) / basketAverageThis) - 100) * -1;
    } else {
      dif = (((basketAverageThis * 100) / basketAverageLast) - 100) * -1;
    }

    final icon = Icon(isWin ? Icons.keyboard_double_arrow_up : Icons.keyboard_double_arrow_down, color: color, size: 20);
    final text = Text('${dif.toMyCurrencyString()} %', style: TextStyle(color: color));

    return StatContainerCompared(
      title: 'Durchschnittlicher Warenkorbwert',
      value1: '${basketAverageThis.toMyCurrencyStringToShow()} €',
      value2: '${basketAverageLast.toMyCurrencyStringToShow()} €',
      thirdLine: Row(mainAxisAlignment: MainAxisAlignment.center, children: [icon, text]),
      width: containerWidth,
    );
  }
}

class _SalesCount extends StatelessWidget {
  final StatSalesBetweenDates statSalesThisMonth;
  final StatSalesBetweenDates statSalesLastMonth;
  final double containerWidth;

  const _SalesCount({required this.statSalesThisMonth, required this.statSalesLastMonth, required this.containerWidth});

  @override
  Widget build(BuildContext context) {
    final countThis = statSalesThisMonth.countTotal;
    final countLast = statSalesLastMonth.countTotal;

    final isWin = countThis > countLast;

    final color = isWin ? Colors.green : Colors.red;

    double dif = 0;

    if (countThis > countLast) {
      dif = (((countLast * 100) / countThis) - 100) * -1;
    } else {
      dif = (((countThis * 100) / countLast) - 100) * -1;
    }

    final icon = Icon(isWin ? Icons.keyboard_double_arrow_up : Icons.keyboard_double_arrow_down, color: color, size: 20);
    final text = Text('${dif.toMyCurrencyString()} %', style: TextStyle(color: color));

    return StatContainerCompared(
      title: 'Anzahl',
      value1: countThis.toString(),
      value2: countLast.toString(),
      thirdLine: Row(mainAxisAlignment: MainAxisAlignment.center, children: [icon, text]),
      width: containerWidth,
    );
  }
}

class _SalesCountAverage extends StatelessWidget {
  final StatSalesBetweenDates statSalesThisMonth;
  final StatSalesBetweenDates statSalesLastMonth;
  final double containerWidth;

  const _SalesCountAverage({required this.statSalesThisMonth, required this.statSalesLastMonth, required this.containerWidth});

  @override
  Widget build(BuildContext context) {
    final salesCountAverageThis = statSalesThisMonth.averageTotalCount;
    final salesCountAverageLast = statSalesLastMonth.averageTotalCount;

    final isWin = salesCountAverageThis > salesCountAverageLast;

    final color = isWin ? Colors.green : Colors.red;

    double dif = 0;

    if (salesCountAverageThis > salesCountAverageLast) {
      dif = (((salesCountAverageLast * 100) / salesCountAverageThis) - 100) * -1;
    } else {
      dif = (((salesCountAverageThis * 100) / salesCountAverageLast) - 100) * -1;
    }

    final icon = Icon(isWin ? Icons.keyboard_double_arrow_up : Icons.keyboard_double_arrow_down, color: color, size: 20);
    final text = Text('${dif.toMyCurrencyString()} %', style: TextStyle(color: color));

    return StatContainerCompared(
      title: 'Durchschnittliche Anzahl',
      value1: salesCountAverageThis.toMyCurrencyStringToShow(),
      value2: salesCountAverageLast.toMyCurrencyStringToShow(),
      thirdLine: Row(mainAxisAlignment: MainAxisAlignment.center, children: [icon, text]),
      width: containerWidth,
    );
  }
}
