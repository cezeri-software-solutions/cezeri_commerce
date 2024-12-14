import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '/constants.dart';
import '../../../../../3_domain/entities/statistic/product_sales_data.dart';
import '../../../../core/core.dart';

class ProductLineChartSalesVolume extends StatelessWidget {
  final List<ProductSalesData> statProducts;

  ProductLineChartSalesVolume({super.key, required this.statProducts});

  final List<Color> gradientColorOnSalesVolume = [
    CustomColors.chartColorCyan,
    CustomColors.chartColorBlue,
  ];
  final List<Color> gradientColorOnIncomingOrders = [
    CustomColors.chartColorYellow,
    CustomColors.chartColorRed,
  ];

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return LineChart(
      mainDataSalesVolume(themeData),
      duration: const Duration(milliseconds: 250),
    );
  }

  LineChartData mainDataSalesVolume(ThemeData themeData) {
    List<Color> gradientColorOnSalesVolume = [
      CustomColors.chartColorCyan,
      CustomColors.chartColorBlue,
    ];

    DateTime now = DateTime.now();
    Color touchToolTipTextColor = CustomColors.chartColorCyan.withValues(alpha: 0.8);
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (value) {
            return value
                .map((e) => LineTooltipItem(e.y.toMyCurrencyString(0), TextStyle(fontWeight: FontWeight.w900, color: touchToolTipTextColor)))
                .toList();
          },
          //tooltipBgColor:
          //    widget.chartTyp == ChartTyp.incomingOrder ? AppColors.contentColorOrange.withValues(alpha:0.8) : AppColors.contentColorCyan.withValues(alpha:0.8),
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        //horizontalInterval: getGritInterval(getMaxValue(statProducts)),
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) => FlLine(color: themeData.colorScheme.primaryContainer, strokeWidth: 1),
        getDrawingVerticalLine: (value) => FlLine(color: themeData.colorScheme.primaryContainer, strokeWidth: 1),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
          /* axisNameWidget: const Text(
            'Auftragseingang',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          axisNameSize: 30, */
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            //interval: 1,
            //getTitlesWidget: leftTitleWidgets,
            reservedSize: 60,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        //border: Border.all(color: const Color(0xff37434d)),
        border: Border.all(color: Colors.grey),
      ),
      minX: 0,
      maxX: 12,
      minY: 0,
      maxY: ((getMaxValue(statProducts) * 1.05) / 10).ceil() * 10,
      lineBarsData: [
        LineChartBarData(
          spots: listOfFlSpotSalesVolumes(now),
          isCurved: true,
          // curveSmoothness: 0.25,
          preventCurveOverShooting: true,
          gradient: LinearGradient(colors: gradientColorOnSalesVolume),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColorOnSalesVolume.map((color) => color.withValues(alpha: 0.3)).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
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

  double getMaxValue(List<ProductSalesData> listOfStatDashboards) {
    if (listOfStatDashboards.isEmpty) return 0;
    List<double> numbers = [];
    for (var statDashboard in listOfStatDashboards) {
      numbers.add(statDashboard.totalRevenue);
    }

    double max = double.negativeInfinity;
    for (double num in numbers) {
      if (num > max) {
        max = num;
      }
    }
    return max;
  }

  double roundDouble(double number) {
    return double.parse(number.toStringAsFixed(0));
  }

  List<FlSpot> listOfFlSpotSalesVolumes(DateTime now) {
    List<FlSpot> spots = [];
    for (int i = 0; i < 13; i++) {
      DateTime monthYear = DateTime(now.year, now.month - 12 + i);
      var matchingElement = statProducts.firstWhere(
        (element) => DateTime(element.month.year, element.month.month) == monthYear,
        orElse: () => ProductSalesData.empty(),
      );
      spots.add(FlSpot(i.toDouble(), roundDouble(matchingElement.totalRevenue)));
    }
    return spots;
  }
}
