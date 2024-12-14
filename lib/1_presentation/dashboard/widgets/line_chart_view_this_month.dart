import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../3_domain/entities/statistic/stat_sales_per_day.dart';
import '../../../constants.dart';
import '../../core/core.dart';

class LineChartViewThisMonth extends StatefulWidget {
  final StatSalesBetweenDates dataMainPeriod;
  final StatSalesBetweenDates? dataComparePeriod;

  const LineChartViewThisMonth({super.key, required this.dataMainPeriod, this.dataComparePeriod});

  @override
  State<LineChartViewThisMonth> createState() => _LineChartViewThisMonthState();
}

class _LineChartViewThisMonthState extends State<LineChartViewThisMonth> {
  final _weekdays = ['Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag', 'Sonntag'];

  final List<({String id, String name, Color color})> _marketplaces = [];

  @override
  void initState() {
    super.initState();
    _initializeMarketplaces();
  }

  void _initializeMarketplaces() {
    final Set<String> uniqueMarketplaceIds = {};
    for (final day in widget.dataMainPeriod.listOfStatSalesPerDay) {
      for (final mp in day.listOfStatSalesPerDayPerMarketplace) {
        if (uniqueMarketplaceIds.add(mp.marketplaceId)) {
          _marketplaces.add((id: mp.marketplaceId, name: mp.marketplaceName, color: getRandomColor(_marketplaces.length + 1)));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isTabletOrLarger = ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET);

    return AspectRatio(
      aspectRatio: isTabletOrLarger ? 4 : 1.8, // getAspectRatio(isTabletOrLarger ? screenWidth / 2 : screenWidth),
      child: Padding(
        padding: const EdgeInsets.only(right: 24, left: 0, top: 24, bottom: 12),
        child: LineChart(mainData(themeData, screenWidth)),
      ),
    );
  }

  LineChartData mainData(ThemeData themeData, double screenWidth) {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          fitInsideHorizontally: true,
          maxContentWidth: 350,
          showOnTopOfTheChartBoxArea: true,
          getTooltipColor: (touchedSpot) => Colors.white,
          tooltipBorder: BorderSide(color: Colors.grey[400]!, width: 1.5),
          getTooltipItems: (touchedSpots) {
            if (widget.dataComparePeriod != null) return getTooltipItemsThisMonthComparedToLastMonth(touchedSpots);
            return getTooltipItemsThisMonthPerMarketplace(touchedSpots);
          },
        ),
      ),
      backgroundColor: CustomColors.ultraLightGrey,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) => FlLine(color: themeData.colorScheme.primaryContainer, strokeWidth: 1),
        getDrawingVerticalLine: (value) => FlLine(color: themeData.colorScheme.primaryContainer, strokeWidth: 1),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: calculateInterval(screenWidth, widget.dataMainPeriod.dateRange!.duration.inDays),
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 60)),
      ),
      borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey)),
      minX: 0,
      maxX: widget.dataMainPeriod.dateRange!.duration.inDays.toDouble(),
      minY: 0,
      maxY: ((getMaxValue() * 1.05) / 10).ceil() * 10,
      lineBarsData: [
        LineChartBarData(
          spots: listOfFlSpotSalesVolumesTotal(widget.dataMainPeriod),
          isCurved: false,
          preventCurveOverShooting: true,
          color: CustomColors.chartColorBlue,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            color: widget.dataComparePeriod != null ? Colors.transparent : CustomColors.chartColorCyan.withValues(alpha: 0.08),
          ),
        ),
        if (widget.dataComparePeriod == null)
          ..._marketplaces.map((marketplace) {
            return LineChartBarData(
              spots: listOfFlSpotSalesVolumesPerMarketplace(marketplace),
              isCurved: false,
              preventCurveOverShooting: true,
              gradient: LinearGradient(colors: [marketplace.color.withValues(alpha: 0.9), marketplace.color]),
              barWidth: 1.5,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(show: true, color: Colors.transparent),
            );
          })
        else
          LineChartBarData(
            spots: listOfFlSpotSalesVolumesTotal(widget.dataComparePeriod!),
            isCurved: false,
            preventCurveOverShooting: true,
            // gradient: LinearGradient(colors: _totalColorLastMonth),
            color: CustomColors.chartColorCyan,
            barWidth: 1.5,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(show: true, color: Colors.transparent),
          )
      ],
    );
  }

  List<LineTooltipItem> getTooltipItemsThisMonthComparedToLastMonth(List<LineBarSpot> touchedSpots) {
    final startDateMainPeriod = widget.dataMainPeriod.dateRange!.start;
    final dateMainPeriod = DateTime(
      startDateMainPeriod.year,
      startDateMainPeriod.month,
      touchedSpots[touchedSpots[0].barIndex].spotIndex + startDateMainPeriod.day,
    );
    final dayThisMonth = dateMainPeriod.day.toString().padLeft(2, '0');
    final monthThisMonth = dateMainPeriod.month.toString().padLeft(2, '0');
    final formattedDateThisMonth = "$dayThisMonth.$monthThisMonth.${dateMainPeriod.year}";

    final weekDayMainPeriod = _weekdays[dateMainPeriod.weekday - 1];

    // #############################################################################################

    final startDateComparePeriod = widget.dataComparePeriod!.dateRange!.start;
    final dateComparePeriod = DateTime(
      startDateComparePeriod.year,
      startDateComparePeriod.month,
      touchedSpots[touchedSpots[0].barIndex].spotIndex + startDateComparePeriod.day,
    );
    final dateLastMonth = DateTime(
      startDateComparePeriod.year,
      startDateComparePeriod.month,
      touchedSpots[touchedSpots[0].barIndex].spotIndex + startDateComparePeriod.day,
    );
    final dayLastMonth = dateLastMonth.day.toString().padLeft(2, '0');
    final monthLastMonth = dateLastMonth.month.toString().padLeft(2, '0');
    final formattedDateLastMonth = "$dayLastMonth.$monthLastMonth.${dateComparePeriod.year}";

    final weekDayComparePeriod = _weekdays[dateComparePeriod.weekday - 1];

    // ############################################################################################

    final salesThisMonth = touchedSpots[touchedSpots[0].barIndex].y;
    final salesLastMonth = touchedSpots[touchedSpots[1].barIndex].y;

    final tooltipItemThisMonth = LineTooltipItem(
      '$weekDayMainPeriod - $formattedDateThisMonth\n',
      const TextStyle(fontWeight: FontWeight.w900, color: CustomColors.chartColorBlue),
      children: [TextSpan(text: 'Dieser Monat: ${salesThisMonth.toMyCurrencyStringToShow(0)}')],
    );

    final tooltipItemLastMonth = LineTooltipItem(
      '$weekDayComparePeriod - $formattedDateLastMonth\n',
      const TextStyle(fontWeight: FontWeight.w900, color: CustomColors.chartColorCyan),
      children: [TextSpan(text: 'Letzter Monat: ${salesLastMonth.toMyCurrencyStringToShow(0)}')],
    );

    if (salesThisMonth > salesLastMonth) {
      return [tooltipItemThisMonth, tooltipItemLastMonth];
    } else {
      return [tooltipItemLastMonth, tooltipItemThisMonth];
    }
  }

  List<LineTooltipItem> getTooltipItemsThisMonthPerMarketplace(List<LineBarSpot> touchedSpots) {
    return touchedSpots.map((LineBarSpot touchedSpot) {
      final startMainPeriod = widget.dataMainPeriod.dateRange!.start;
      final date = DateTime(startMainPeriod.year, startMainPeriod.month, touchedSpot.spotIndex + startMainPeriod.day);
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      final formattedDate = "$day.$month.${date.year}";

      final weekDay = _weekdays[date.weekday - 1];

      final index = touchedSpot.barIndex;
      final value = touchedSpot.y;
      String title;
      Color color;

      if (index == 0) {
        title = '$weekDay - $formattedDate\nGesamt: ${value.toMyCurrencyStringToShow(0)}';
        color = CustomColors.chartColorBlue;
      } else {
        final marketplace = _marketplaces[index - 1];
        title = '${marketplace.name}: ${value.toMyCurrencyStringToShow(0)}';
        color = marketplace.color;
      }
      return LineTooltipItem(title, TextStyle(fontWeight: FontWeight.w900, color: color));
    }).toList();
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    if (widget.dataMainPeriod.listOfStatSalesPerDay.length == 1) {
      final date = widget.dataMainPeriod.listOfStatSalesPerDay.first.date;
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      final formattedDate = "$day.$month";

      return SideTitleWidget(axisSide: meta.axisSide, child: Text(formattedDate));
    }

    final data = widget.dataMainPeriod.listOfStatSalesPerDay;
    final sortedList = data..sort((a, b) => a.date.compareTo(b.date));

    // Finde das Datum, das zu 'value' passt. Hier wird angenommen, dass 'value' dem Index entspricht.
    int index = value.toInt();
    if (index < 0 || index >= widget.dataMainPeriod.dateRange!.duration.inDays + 1) {
      return const SizedBox.shrink(); // falls der Index außerhalb des gültigen Bereichs liegt
    }

    final date = sortedList[index].date;
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final formattedDate = "$day.$month";

    return SideTitleWidget(axisSide: meta.axisSide, child: Text(formattedDate));
  }

  double getMaxValue() {
    final dataThisMonth = widget.dataMainPeriod.listOfStatSalesPerDay;
    if (dataThisMonth.isEmpty) return 0;

    final sortedListThisMonth = dataThisMonth..sort((a, b) => a.totalNetSum.compareTo(b.totalNetSum));
    final maxFromListThisMonth = sortedListThisMonth.last.totalNetSum;

    double maxFromList = maxFromListThisMonth;

    if (widget.dataComparePeriod != null) {
      final dataLastMonth = widget.dataComparePeriod!.listOfStatSalesPerDay;
      final sortedListLastMonth = dataLastMonth..sort((a, b) => a.totalNetSum.compareTo(b.totalNetSum));
      final maxFromListLastMonth = sortedListLastMonth.last.totalNetSum;

      maxFromList = maxFromList > maxFromListLastMonth ? maxFromList : maxFromListLastMonth;
    }

    const max = double.negativeInfinity;
    return maxFromList > max ? maxFromList : max;
  }

  double roundDouble(double number) => double.parse(number.toStringAsFixed(0));

  List<FlSpot> listOfFlSpotSalesVolumesTotal(StatSalesBetweenDates salesData) {
    final data = salesData.listOfStatSalesPerDay..sort((a, b) => a.date.compareTo(b.date));
    final firstDate = data.first.date;

    List<FlSpot> spots = [];
    for (int i = 0; i < salesData.dateRange!.duration.inDays + 1; i++) {
      final dayMonthYear = DateTime(firstDate.year, firstDate.month, firstDate.day + i);
      final matchingElement = data.firstWhere(
        (e) => e.date.toConvertedYearMonthDay() == dayMonthYear.toConvertedYearMonthDay(),
        orElse: () => StatSalesPerDay.empty(),
      );
      spots.add(FlSpot(i.toDouble(), roundDouble(matchingElement.totalNetSum)));
    }
    return spots;
  }

  List<FlSpot> listOfFlSpotSalesVolumesPerMarketplace(({String id, String name, Color color}) marketplace) {
    final data = widget.dataMainPeriod.listOfStatSalesPerDay..sort((a, b) => a.date.compareTo(b.date));
    final firstDate = data.first.date;

    List<FlSpot> spots = [];
    for (int i = 0; i < widget.dataMainPeriod.dateRange!.duration.inDays + 1; i++) {
      final dayMonthYear = DateTime(firstDate.year, firstDate.month, firstDate.day + i);
      final matchingElement = data[i].listOfStatSalesPerDayPerMarketplace.firstWhere(
            (e) => e.date.toConvertedYearMonthDay() == dayMonthYear.toConvertedYearMonthDay() && e.marketplaceId == marketplace.id,
            orElse: () => StatSalesPerDayPerMarketplace.empty(),
          );
      spots.add(FlSpot(i.toDouble(), roundDouble(matchingElement.totalNetSum)));
    }
    return spots;
  }
}

double calculateInterval(double screenWidth, int dataPointCount) {
  if (dataPointCount < 4) return 1.0;

  // Annahme: ein Label benötigt ca. 50 Pixel Breite
  const labelWidth = 50.0;
  final maxLabels = (screenWidth / labelWidth).floor();
  final interval = (dataPointCount / maxLabels).ceil();

  return interval.toDouble();
}
