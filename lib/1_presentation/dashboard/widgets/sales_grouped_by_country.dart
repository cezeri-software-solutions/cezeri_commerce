import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../3_domain/entities/statistic/stat_sales_grouped.dart';
import '../../../constants.dart';
import '../../core/core.dart';

class SalesGroupedByCountry extends StatefulWidget {
  final List<StatSalesGrouped>? listOfSalesVolumeGrouped;
  final bool isLoadingProductSalesByBrand;
  final bool isFailureOnGroups;

  const SalesGroupedByCountry({
    super.key,
    this.listOfSalesVolumeGrouped,
    required this.isLoadingProductSalesByBrand,
    required this.isFailureOnGroups,
  });

  @override
  State<SalesGroupedByCountry> createState() => _SalesGroupedByCountryState();
}

class _SalesGroupedByCountryState extends State<SalesGroupedByCountry> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.screenWidth;

    if (widget.isLoadingProductSalesByBrand) return const Center(child: MyCircularProgressIndicator());
    if (widget.isFailureOnGroups) return const Center(child: Text('Beim Laden der Daten ist ein Fehler aufgetreten!'));
    if (widget.listOfSalesVolumeGrouped!.isEmpty) {
      return const Center(child: Text('Für den ausgewählten Zeitraum sind keine Daten in der Datenbank enthalten.'));
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _buildSalesByBrandTable(widget.listOfSalesVolumeGrouped!, screenWidth, _touchedIndex),
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

  List<PieChartSectionData> showingSections() {
    return widget.listOfSalesVolumeGrouped!.asMap().entries.map((entry) {
      final index = entry.key;
      final statSalesGrouped = entry.value;
      final isTouched = index == _touchedIndex;
      final double radius = isTouched ? 80 : 70;

      return PieChartSectionData(
        color: getColor(index),
        value: statSalesGrouped.netGroupedSum,
        title: statSalesGrouped.netGroupedSumPercent > 5.99 ? '${statSalesGrouped.netGroupedSumPercent.toMyCurrencyStringToShow(0)}%' : '',
        titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        radius: radius,
        titlePositionPercentageOffset: 0.55,
        borderSide: isTouched ? const BorderSide(color: Colors.white, width: 6) : BorderSide(color: Colors.white.withValues(alpha: 0)),
      );
    }).toList();
  }

  Color getColor(int index, {double? opacity = 1.0}) {
    Random random = Random(index);
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      opacity!,
    );
  }
}

Widget _buildSalesByBrandTable(List<StatSalesGrouped> list, double screenWidth, int touchedIndex) {
  List<Widget> headers = [
    const _ColumnItem(text: 'Land', padding: EdgeInsets.only(top: 4, left: 55, right: 10)),
    const _ColumnItem(text: 'Anzahl', textAlign: TextAlign.right),
    const _ColumnItem(text: 'Anzahl in %', textAlign: TextAlign.right),
    const _ColumnItem(text: 'Summe', textAlign: TextAlign.right),
    const _ColumnItem(text: 'Summe in %', textAlign: TextAlign.right),
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
        _RowItem(
            text: brand.name, isTouched: rowIndex == touchedIndex, color: getRandomColor(rowIndex), index: rowIndex + 1, textAlign: TextAlign.right),
        _RowItem(text: brand.count.toString(), textAlign: TextAlign.right),
        _RowItem(text: '${brand.countPercent.toStringAsFixed(2)} %', textAlign: TextAlign.right),
        _RowItem(text: brand.netGroupedSum.toMyCurrencyStringToShow(), textAlign: TextAlign.right),
        _RowItem(text: '${brand.netGroupedSumPercent.toStringAsFixed(2)} %', textAlign: TextAlign.right),
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
