import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../3_domain/entities/statistic/stat_brand.dart';
import '../../../constants.dart';
import '../../core/core.dart';

class SalesByBrandChart extends StatefulWidget {
  final List<StatBrand>? listOfSalesByBrand;
  final bool isLoadingProductSalesByBrand;
  final bool isFailureOnProductSalesByBrand;

  const SalesByBrandChart({
    super.key,
    required this.listOfSalesByBrand,
    required this.isLoadingProductSalesByBrand,
    required this.isFailureOnProductSalesByBrand,
  });

  @override
  State<StatefulWidget> createState() => SalesByBrandChartState();
}

class SalesByBrandChartState extends State<SalesByBrandChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final isTablet = ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET);

    if (widget.isLoadingProductSalesByBrand) {
      return const Center(child: MyCircularProgressIndicator());
    } else if (widget.isFailureOnProductSalesByBrand) {
      return const Center(child: Text('Beim Laden der Daten ist ein Fehler aufgetreten!'));
    } else if (widget.listOfSalesByBrand!.isEmpty) {
      return const Center(child: Text('Für den ausgewählten Zeitraum sind keine Daten in der Datenbank enthalten.'));
    } else if (isTablet) {
      return Row(
        children: [
          Expanded(
            child: SizedBox(
              height: screenHeight / 3,
              child: SingleChildScrollView(
                child: _buildSalesByBrandTable(widget.listOfSalesByBrand!, screenWidth, _touchedIndex),
              ),
            ),
          ),
          SizedBox(
            width: 220,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                        _touchedIndex = -1;
                        return;
                      }
                      _touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                startDegreeOffset: 180,
                borderData: FlBorderData(show: false),
                sectionsSpace: 1,
                centerSpaceRadius: 20,
                sections: showingSections(),
              ),
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _buildSalesByBrandTable(widget.listOfSalesByBrand!, screenWidth, _touchedIndex),
              ),
            ),
          ),
          SizedBox(
            width: 220,
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                          _touchedIndex = -1;
                          return;
                        }
                        _touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  startDegreeOffset: 180,
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 1,
                  centerSpaceRadius: 20,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  List<PieChartSectionData> showingSections() {
    return widget.listOfSalesByBrand!.asMap().entries.map((entry) {
      final index = entry.key;
      final brand = entry.value;
      final isTouched = index == _touchedIndex;
      final double radius = isTouched ? 80 : 70;

      return PieChartSectionData(
        color: getRandomColor(index),
        value: brand.netSales,
        title: brand.totalSalesPercent > 5.99 ? '${brand.totalSalesPercent.toMyCurrencyStringToShow(0)}%' : '',
        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        radius: radius,
        titlePositionPercentageOffset: 0.55,
        borderSide: isTouched ? const BorderSide(color: Colors.white, width: 6) : BorderSide(color: Colors.white.withOpacity(0)),
      );
    }).toList();
  }
}

Widget _buildSalesByBrandTable(List<StatBrand> list, double screenWidth, int touchedIndex) {
  List<Widget> headers = [
    const _ColumnItem(text: 'Hersteller', padding: EdgeInsets.only(top: 4, left: 55, right: 10)),
    const _ColumnItem(text: 'Verkauf Netto', textAlign: TextAlign.right),
    const _ColumnItem(text: 'Gewinn Netto', textAlign: TextAlign.right),
    const _ColumnItem(text: 'Stückzahl', textAlign: TextAlign.right),
    const _ColumnItem(text: 'Gewinn in %', textAlign: TextAlign.right),
    const _ColumnItem(text: 'Anteil Umsatz in %', textAlign: TextAlign.right),
    const _ColumnItem(text: 'Anteil Gewinn in %', textAlign: TextAlign.right),
  ];

  List<TableRow> rows = [
    TableRow(decoration: BoxDecoration(color: Colors.grey[200]), children: headers.map((widget) => Container(child: widget)).toList()),
  ];

  int rowIndex = 0;

  for (final brand in list) {
    BoxDecoration? rowDecoration;
    if (rowIndex % 2 == 1) rowDecoration = const BoxDecoration(color: CustomColors.ultraLightBlue);
    if (rowIndex == touchedIndex) rowDecoration = BoxDecoration(color: getRandomColor(rowIndex, opacity: 0.2));

    // Datenzeile hinzufügen
    rows.add(TableRow(
      decoration: rowDecoration,
      children: [
        _RowItem(text: brand.brandName, isTouched: rowIndex == touchedIndex, color: getRandomColor(rowIndex), index: rowIndex + 1),
        _RowItem(text: '${brand.netSales.toMyCurrencyStringToShow()} €', textAlign: TextAlign.right),
        _RowItem(text: '${brand.profit.toMyCurrencyStringToShow()} €', textAlign: TextAlign.right),
        _RowItem(text: '${brand.quantity.toString()} Stk.', textAlign: TextAlign.right),
        _RowItem(text: '${brand.profitPercent.toMyCurrencyStringToShow()} %', textAlign: TextAlign.right),
        _RowItem(text: '${brand.totalSalesPercent.toMyCurrencyStringToShow()} %', textAlign: TextAlign.right),
        _RowItem(text: '${brand.totalProfitPercent.toMyCurrencyStringToShow()} %', textAlign: TextAlign.right),
      ],
    ));

    // Trennlinie als Zeilendekoration hinzufügen
    rows.add(TableRow(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      children: List.generate(headers.length, (index) => const SizedBox.shrink()),
    ));

    rowIndex++;
  }

  return Table(
    children: rows,
    columnWidths: Map.fromIterable(
      List.generate(headers.length, (index) => index),
      value: (index) => const IntrinsicColumnWidth(),
    ),
  );
}

class _ColumnItem extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry? padding;
  final TextAlign? textAlign;

  const _ColumnItem({required this.text, this.padding = const EdgeInsets.only(top: 4, left: 10, right: 10), this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: padding!, child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: textAlign));
  }
}

class _RowItem extends StatelessWidget {
  final String text;
  final bool? isTouched;
  final TextAlign? textAlign;
  final Color? color;
  final int index;

  const _RowItem({
    required this.text,
    this.isTouched = false,
    this.textAlign,
    this.color,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.only(top: 4, left: 10, right: 10);
    if (color == null) return Padding(padding: padding, child: Text(text, textAlign: textAlign));

    return Padding(
      padding: padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (index != 0) SizedBox(width: 20, child: Text(index.toString())),
          Container(width: 16, height: 16, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
          Gaps.w8,
          Text(text, textAlign: textAlign, style: isTouched! ? TextStyles.defaultBold.copyWith(color: color) : null),
        ],
      ),
    );
  }
}
