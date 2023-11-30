import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../3_domain/entities/statistic/stat_dashboard.dart';
import '../../../3_domain/enums/enums.dart';
import '../../../constants.dart';

class LineChartView extends StatefulWidget {
  final List<StatDashboard> listOfStatDashboards;
  final ChartType chartTyp;
  const LineChartView({
    super.key,
    required this.listOfStatDashboards,
    required this.chartTyp,
  });

  @override
  State<LineChartView> createState() => _LineChartViewState();
}

class _LineChartViewState extends State<LineChartView> {
  List<Color> gradientColorOnSalesVolume = [
    CustomColors.chartColorCyan,
    CustomColors.chartColorBlue,
  ];
  List<Color> gradientColorOnIncomingOrders = [
    CustomColors.chartColorYellow,
    CustomColors.chartColorRed,
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 3.5, //* 1.7
          child: Padding(
            padding: const EdgeInsets.only(
              right: 25, //18,
              left: 0, //12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              /* showAvg ? avgData() : */ mainData(themeData),
            ),
          ),
        ),
        /* SizedBox(
          width: 60,
          height: 34,
          child: TextButton(
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: Text(
              'avg',
              style: TextStyle(
                fontSize: 12,
                color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
              ),
            ),
          ),
        ), */
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    DateTime now = DateTime.now();
    const style = TextStyle(
      //fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text(DateTime(now.year, now.month - 12).month.toString(), style: style);
        break;
      case 1:
        text = Text(DateTime(now.year, now.month - 11).month.toString(), style: style);
        break;
      case 2:
        text = Text(DateTime(now.year, now.month - 10).month.toString(), style: style);
        break;
      case 3:
        text = Text(DateTime(now.year, now.month - 9).month.toString(), style: style);
        break;
      case 4:
        text = Text(DateTime(now.year, now.month - 8).month.toString(), style: style);
        break;
      case 5:
        text = Text(DateTime(now.year, now.month - 7).month.toString(), style: style);
        break;
      case 6:
        text = Text(DateTime(now.year, now.month - 6).month.toString(), style: style);
        break;
      case 7:
        text = Text(DateTime(now.year, now.month - 5).month.toString(), style: style);
        break;
      case 8:
        text = Text(DateTime(now.year, now.month - 4).month.toString(), style: style);
        break;
      case 9:
        text = Text(DateTime(now.year, now.month - 3).month.toString(), style: style);
        break;
      case 10:
        text = Text(DateTime(now.year, now.month - 2).month.toString(), style: style);
        break;
      case 11:
        text = Text(DateTime(now.year, now.month - 1).month.toString(), style: style);
        break;
      case 12:
        text = Text(now.month.toString(), style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  //? Wird automatisch generiert
  /* Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  } */

  LineChartData mainData(ThemeData themeData) {
    DateTime now = DateTime.now();
    Color touchToolTipTextColor =
        widget.chartTyp == ChartType.incomingOrder ? CustomColors.chartColorOrange.withOpacity(0.8) : CustomColors.chartColorCyan.withOpacity(0.8);
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (value) {
            return value
                .map((e) => LineTooltipItem(e.y.toMyCurrencyString(0), TextStyle(fontWeight: FontWeight.w900, color: touchToolTipTextColor)))
                .toList();
          },
          //tooltipBgColor:
          //    widget.chartTyp == ChartTyp.incomingOrder ? AppColors.contentColorOrange.withOpacity(0.8) : AppColors.contentColorCyan.withOpacity(0.8),
        ),
      ),
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
      maxY: getMaxValue(widget.listOfStatDashboards), // * 1.1,
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
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: widget.chartTyp == ChartType.incomingOrder
                  ? gradientColorOnIncomingOrders.map((color) => color.withOpacity(0.3)).toList()
                  : gradientColorOnSalesVolume.map((color) => color.withOpacity(0.3)).toList(),
            ),
          ),
        ),
      ],
    );
  }

  /* LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2)!.withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1]).lerp(0.2)!.withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  } */
  double getMaxValue(List<StatDashboard> listOfStatDashboards) {
    if (listOfStatDashboards.isEmpty) return 0;
    List<double> numbers = [];
    for (var statDashboard in listOfStatDashboards) {
      if (widget.chartTyp == ChartType.incomingOrder) {
        numbers.add(statDashboard.incomingOrders);
      } else {
        numbers.add(statDashboard.salesVolume);
      }
    }

    // Die höchste Zahl wird berechnet
    double max = double.negativeInfinity;
    for (double num in numbers) {
      if (num > max) {
        max = num;
      }
    }

    // Die höchste Zahl wird aufgerundet
    /* max = max * 1.1;
    double rounder = 1000;
    if (max < 1000) {
      rounder = 10;
    } else if (max < 10000) {
      rounder = 100;
    } else if (max < 100000) {
      rounder = 1000;
    } else if (max < 1000000) {
      rounder = 10000;
    } else if (max < 1000000) {
      rounder = 10000;
    }

    double roundedMax = (max / rounder).ceil() * rounder;
 */
    //return roundedMax;
    return max;
  }

  double roundDouble(double number) {
    return double.parse(number.toStringAsFixed(0));
  }

  List<FlSpot> listOfFlSpotIncomingOrders(DateTime now) => [
        widget.listOfStatDashboards
                .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 12))
                .isNotEmpty
            ? FlSpot(
                0,
                roundDouble(widget.listOfStatDashboards
                    .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 12))
                    .first
                    .incomingOrders))
            : FlSpot(0, StatDashboard.empty().incomingOrders),
        widget.listOfStatDashboards
                .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 11))
                .isNotEmpty
            ? FlSpot(
                1,
                roundDouble(widget.listOfStatDashboards
                    .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 11))
                    .first
                    .incomingOrders))
            : FlSpot(1, StatDashboard.empty().incomingOrders),
        widget.listOfStatDashboards
                .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 10))
                .isNotEmpty
            ? FlSpot(
                2,
                roundDouble(widget.listOfStatDashboards
                    .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 10))
                    .first
                    .incomingOrders))
            : FlSpot(2, StatDashboard.empty().incomingOrders),
        widget.listOfStatDashboards
                .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 9))
                .isNotEmpty
            ? FlSpot(
                3,
                roundDouble(widget.listOfStatDashboards
                    .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 9))
                    .first
                    .incomingOrders))
            : FlSpot(3, StatDashboard.empty().incomingOrders),
        widget.listOfStatDashboards
                .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 8))
                .isNotEmpty
            ? FlSpot(
                4,
                roundDouble(widget.listOfStatDashboards
                    .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 8))
                    .first
                    .incomingOrders))
            : FlSpot(4, StatDashboard.empty().incomingOrders),
        widget.listOfStatDashboards
                .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 7))
                .isNotEmpty
            ? FlSpot(
                5,
                roundDouble(widget.listOfStatDashboards
                    .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 7))
                    .first
                    .incomingOrders))
            : FlSpot(5, StatDashboard.empty().incomingOrders),
        widget.listOfStatDashboards
                .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 6))
                .isNotEmpty
            ? FlSpot(
                6,
                roundDouble(widget.listOfStatDashboards
                    .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 6))
                    .first
                    .incomingOrders))
            : FlSpot(6, StatDashboard.empty().incomingOrders),
        widget.listOfStatDashboards
                .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 5))
                .isNotEmpty
            ? FlSpot(
                7,
                roundDouble(widget.listOfStatDashboards
                    .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 5))
                    .first
                    .incomingOrders))
            : FlSpot(7, StatDashboard.empty().incomingOrders),
        widget.listOfStatDashboards
                .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 4))
                .isNotEmpty
            ? FlSpot(
                8,
                roundDouble(widget.listOfStatDashboards
                    .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 4))
                    .first
                    .incomingOrders))
            : FlSpot(8, StatDashboard.empty().incomingOrders),
        widget.listOfStatDashboards
                .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 3))
                .isNotEmpty
            ? FlSpot(
                9,
                roundDouble(widget.listOfStatDashboards
                    .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 3))
                    .first
                    .incomingOrders))
            : FlSpot(9, StatDashboard.empty().incomingOrders),
        widget.listOfStatDashboards
                .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 2))
                .isNotEmpty
            ? FlSpot(
                10,
                roundDouble(widget.listOfStatDashboards
                    .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 2))
                    .first
                    .incomingOrders))
            : FlSpot(10, StatDashboard.empty().incomingOrders),
        widget.listOfStatDashboards
                .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 1))
                .isNotEmpty
            ? FlSpot(
                11,
                roundDouble(widget.listOfStatDashboards
                    .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 1))
                    .first
                    .incomingOrders))
            : FlSpot(11, StatDashboard.empty().incomingOrders),
        widget.listOfStatDashboards
                .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month))
                .isNotEmpty
            ? FlSpot(
                12,
                roundDouble(widget.listOfStatDashboards
                    .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month))
                    .first
                    .incomingOrders))
            : FlSpot(12, StatDashboard.empty().incomingOrders),
      ];
  //? #################################################################################################################################
  List<FlSpot> listOfFlSpotSalesVolumes(DateTime now) => [
        widget.listOfStatDashboards
                .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 12))
                .isNotEmpty
            ? FlSpot(
                0,
                roundDouble(widget.listOfStatDashboards
                    .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 12))
                    .first
                    .salesVolume))
            : FlSpot(0, StatDashboard.empty().salesVolume),
        widget.listOfStatDashboards
                .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 11))
                .isNotEmpty
            ? FlSpot(
                1,
                roundDouble(widget.listOfStatDashboards
                    .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 11))
                    .first
                    .salesVolume))
            : FlSpot(1, StatDashboard.empty().salesVolume),
        widget.listOfStatDashboards
                .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 10))
                .isNotEmpty
            ? FlSpot(
                2,
                roundDouble(widget.listOfStatDashboards
                    .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 10))
                    .first
                    .salesVolume))
            : FlSpot(2, StatDashboard.empty().salesVolume),
        widget.listOfStatDashboards
                .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 9))
                .isNotEmpty
            ? FlSpot(
                3,
                roundDouble(widget.listOfStatDashboards
                    .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 9))
                    .first
                    .salesVolume))
            : FlSpot(3, StatDashboard.empty().salesVolume),
        widget.listOfStatDashboards
                .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 8))
                .isNotEmpty
            ? FlSpot(
                4,
                roundDouble(widget.listOfStatDashboards
                    .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 8))
                    .first
                    .salesVolume))
            : FlSpot(4, StatDashboard.empty().salesVolume),
        widget.listOfStatDashboards
                .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 7))
                .isNotEmpty
            ? FlSpot(
                5,
                roundDouble(widget.listOfStatDashboards
                    .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 7))
                    .first
                    .salesVolume))
            : FlSpot(5, StatDashboard.empty().salesVolume),
        widget.listOfStatDashboards
                .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 6))
                .isNotEmpty
            ? FlSpot(
                6,
                roundDouble(widget.listOfStatDashboards
                    .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 6))
                    .first
                    .salesVolume))
            : FlSpot(6, StatDashboard.empty().salesVolume),
        widget.listOfStatDashboards
                .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 5))
                .isNotEmpty
            ? FlSpot(
                7,
                roundDouble(widget.listOfStatDashboards
                    .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 5))
                    .first
                    .salesVolume))
            : FlSpot(7, StatDashboard.empty().salesVolume),
        widget.listOfStatDashboards
                .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 4))
                .isNotEmpty
            ? FlSpot(
                8,
                roundDouble(widget.listOfStatDashboards
                    .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 4))
                    .first
                    .salesVolume))
            : FlSpot(8, StatDashboard.empty().salesVolume),
        widget.listOfStatDashboards
                .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 3))
                .isNotEmpty
            ? FlSpot(
                9,
                roundDouble(widget.listOfStatDashboards
                    .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 3))
                    .first
                    .salesVolume))
            : FlSpot(9, StatDashboard.empty().salesVolume),
        widget.listOfStatDashboards
                .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 2))
                .isNotEmpty
            ? FlSpot(
                10,
                roundDouble(widget.listOfStatDashboards
                    .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 2))
                    .first
                    .salesVolume))
            : FlSpot(10, StatDashboard.empty().salesVolume),
        widget.listOfStatDashboards
                .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 1))
                .isNotEmpty
            ? FlSpot(
                11,
                roundDouble(widget.listOfStatDashboards
                    .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month - 1))
                    .first
                    .salesVolume))
            : FlSpot(11, StatDashboard.empty().salesVolume),
        widget.listOfStatDashboards
                .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month))
                .isNotEmpty
            ? FlSpot(
                12,
                roundDouble(widget.listOfStatDashboards
                    .where((element) => DateTime(element.dateTime.year, element.dateTime.month) == DateTime(now.year, now.month))
                    .first
                    .salesVolume))
            : FlSpot(12, StatDashboard.empty().salesVolume),
      ];
}
