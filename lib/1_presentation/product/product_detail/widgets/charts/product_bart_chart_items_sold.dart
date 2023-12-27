import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '/3_domain/entities/statistic/stat_product.dart';
import '/constants.dart';

class ProductBartChartItemsSold extends StatelessWidget {
  final List<StatProduct> statProducts;

  ProductBartChartItemsSold({super.key, required this.statProducts});

  final now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final soldList = statProducts.map((e) => e.numberOfItemsSold).toList();
    final highestNumber = soldList.reduce((a, b) => a > b ? a : b);
    final maxY = (highestNumber * 0.1) + highestNumber;

    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: getBarGroups(),
        gridData: const FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: CustomColors.chartColorRed,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    DateTime now = DateTime.now();
    const style = TextStyle(fontSize: 14);

    // Berechnen des Monats basierend auf dem Wert
    int monthToShow = DateTime(now.year, now.month - 12 + value.toInt()).month;

    // Erstellen des Text-Widgets mit dem berechneten Monat
    Widget text = Text(monthToShow.toString(), style: style);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          CustomColors.chartColorYellow,
          CustomColors.chartColorRed,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  double roundDouble(int number) {
    return double.parse(number.toStringAsFixed(0));
  }

  List<BarChartGroupData> getBarGroups() {
    List<BarChartGroupData> bcgd = [];
    for (int i = 0; i < 13; i++) {
      DateTime monthYear = DateTime(now.year, now.month - 12 + i);
      var matchingElement = statProducts.firstWhere(
        (e) => DateTime(e.creationDate.year, e.creationDate.month) == monthYear,
        orElse: () => StatProduct.empty(),
      );
      bcgd.add(
        BarChartGroupData(
          x: i,
          barRods: [BarChartRodData(toY: roundDouble(matchingElement.numberOfItemsSold), gradient: _barsGradient)],
          showingTooltipIndicators: [0],
        ),
      );
    }
    return bcgd;
  }
}
