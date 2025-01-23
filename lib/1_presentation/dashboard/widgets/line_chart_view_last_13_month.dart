import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../3_domain/entities/statistic/stat_dashboard.dart';
import '../../../3_domain/enums/enums.dart';
import '../../../constants.dart';
import '../../core/core.dart';

class LineChartViewLast13Month extends StatefulWidget {
  final List<StatDashboard> listOfStatDashboards;
  final ChartType chartTyp;

  const LineChartViewLast13Month({super.key, required this.listOfStatDashboards, required this.chartTyp});

  @override
  State<LineChartViewLast13Month> createState() => _LineChartViewLast13MonthState();
}

class _LineChartViewLast13MonthState extends State<LineChartViewLast13Month> {
  List<Color> gradientColorOnSalesVolume = [
    CustomColors.chartColorCyan,
    CustomColors.chartColorBlue,
  ];
  List<Color> gradientColorOnIncomingOrders = [
    CustomColors.chartColorYellow,
    CustomColors.chartColorRed,
  ];

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final screenWidth = context.screenWidth;
    final isTabletOrLarger = ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET);

    return Stack(
      children: [
        AspectRatio(
          aspectRatio: getAspectRatio(isTabletOrLarger ? screenWidth / 2 : screenWidth),
          child: Padding(
            padding: const EdgeInsets.only(
              right: 24, //18,
              left: 0, //12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(mainData(themeData)),
          ),
        ),
      ],
    );
  }

  LineChartData mainData(ThemeData themeData) {
    DateTime now = DateTime.now();
    Color touchToolTipTextColor = widget.chartTyp == ChartType.incomingOrder
        ? CustomColors.chartColorOrange.withValues(alpha: 0.8)
        : CustomColors.chartColorCyan.withValues(alpha: 0.8);
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
      backgroundColor: CustomColors.ultraLightGrey,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        //horizontalInterval: getGritInterval(getMaxValue(widget.listOfStatDashboards)),
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: themeData.colorScheme.primaryContainer, //AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: themeData.colorScheme.primaryContainer, //AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
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
      maxY: ((getMaxValue(widget.listOfStatDashboards) * 1.05) / 10).ceil() * 10, //getMaxValue(widget.listOfStatDashboards), // * 1.1,
      lineBarsData: [
        LineChartBarData(
          spots: widget.chartTyp == ChartType.incomingOrder ? listOfFlSpotIncomingOrders(now) : listOfFlSpotSalesVolumes(now),
          isCurved: true,
          //curveSmoothness: 0.25,
          preventCurveOverShooting: true,
          gradient: LinearGradient(
            colors: widget.chartTyp == ChartType.incomingOrder ? gradientColorOnIncomingOrders : gradientColorOnSalesVolume,
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: widget.chartTyp == ChartType.incomingOrder
                  ? gradientColorOnIncomingOrders.map((color) => color.withValues(alpha: 0.3)).toList()
                  : gradientColorOnSalesVolume.map((color) => color.withValues(alpha: 0.3)).toList(),
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

  double getMaxValue(List<StatDashboard> listOfStatDashboards) {
    if (listOfStatDashboards.isEmpty) return 0;
    List<double> numbers = [];
    for (var statDashboard in listOfStatDashboards) {
      if (widget.chartTyp == ChartType.incomingOrder) {
        numbers.add(statDashboard.appointmentVolume);
      } else {
        numbers.add(statDashboard.invoiceVolume);
      }
    }

    double max = double.negativeInfinity;
    for (double num in numbers) {
      if (num > max) {
        max = num;
      }
    }
    return max;
  }

  double roundDouble(double number) => double.parse(number.toStringAsFixed(0));

  List<FlSpot> listOfFlSpotIncomingOrders(DateTime now) {
    List<FlSpot> spots = [];
    for (int i = 0; i < 13; i++) {
      DateTime monthYear = DateTime(now.year, now.month - 12 + i);
      var matchingElement = widget.listOfStatDashboards.firstWhere(
        (e) => e.month == monthYear.toConvertedYearMonth(),
        orElse: () => StatDashboard.empty(),
      );
      spots.add(FlSpot(i.toDouble(), roundDouble(matchingElement.appointmentVolume)));
    }
    return spots;
  }

  List<FlSpot> listOfFlSpotSalesVolumes(DateTime now) {
    List<FlSpot> spots = [];
    for (int i = 0; i < 13; i++) {
      DateTime monthYear = DateTime(now.year, now.month - 12 + i);
      var matchingElement = widget.listOfStatDashboards.firstWhere(
        (e) => e.month == monthYear.toConvertedYearMonth(),
        orElse: () => StatDashboard.empty(),
      );
      spots.add(FlSpot(i.toDouble(), roundDouble(matchingElement.invoiceVolume)));
    }
    return spots;
  }
}
