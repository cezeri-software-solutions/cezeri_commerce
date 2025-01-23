import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../2_application/database/reorder/reorder_bloc.dart';
import '../../../3_domain/entities/reorder/reorder.dart';
import '../../../constants.dart';
import '../../../routes/router.gr.dart';
import '../../core/core.dart';
import '../reorder_detail/reorder_detail_screen.dart';

class ReordersOverviewPage extends StatelessWidget {
  final ReorderBloc reorderBloc;

  const ReordersOverviewPage({super.key, required this.reorderBloc});

  @override
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReorderBloc, ReorderState>(
      builder: (context, state) {
        if (state.isLoadingReordersOnObserve) {
          return const Expanded(child: Center(child: CircularProgressIndicator()));
        }
        if (state.firebaseFailure != null && state.isAnyFailure) {
          return const Expanded(child: Center(child: Text('Ein Fehler ist aufgetreten!')));
        }
        if (state.listOfAllReorders == null || state.listOfFilteredReorders == null) {
          return const Expanded(child: Center(child: CircularProgressIndicator()));
        }
        if (state.listOfFilteredReorders!.isEmpty) {
          return const Expanded(child: Center(child: Text('Es sind keine Nachbestellungen vorhanden.')));
        }

        final screenWidth = context.screenWidth;

        Table buildReorderTable(List<Reorder> reorderList) {
          final paddingRight = screenWidth / 18;
          final padding = EdgeInsets.only(top: 7, right: paddingRight);
          const constraints = BoxConstraints(maxHeight: 32);
          final List<Widget> rowChildren = [
            const SizedBox.shrink(),
            const SizedBox.shrink(),
            const SizedBox.shrink(),
            const SizedBox.shrink(),
            const SizedBox.shrink(),
            const SizedBox.shrink(),
            const SizedBox.shrink(),
            const SizedBox.shrink(),
          ];

          List<Widget> headers = [
            ConstrainedBox(
              constraints: constraints,
              child: Checkbox.adaptive(
                value: state.isAllReordersSelected,
                onChanged: (value) => reorderBloc.add(OnSelectAllReordersEvent(isSelected: value!)),
              ),
            ),
            Padding(padding: padding, child: const Text('Lieferant', style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(padding: padding, child: const Text('Bestellnummer', style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(padding: padding, child: const Text('Bestellnr. intern', style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(padding: padding, child: const Text('Dokmentdatum', style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(padding: padding, child: const Text('Nettobetrag', style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(padding: padding, child: const Text('Gesamtbetrag', style: TextStyle(fontWeight: FontWeight.bold))),
            Padding(padding: padding, child: const Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
          ];

          List<TableRow> rows = [
            TableRow(decoration: BoxDecoration(color: Colors.grey[200]), children: headers),
          ];

          rows.add(TableRow(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
            children: rowChildren,
          ));

          int rowIndex = 0;

          for (final reorder in reorderList) {
            BoxDecoration? rowDecoration;
            if (rowIndex % 2 == 1) rowDecoration = const BoxDecoration(color: CustomColors.ultraLightBlue);

            // Datenzeile hinzufügen
            rows.add(TableRow(
              decoration: rowDecoration,
              children: [
                ConstrainedBox(
                  constraints: constraints,
                  child: Checkbox.adaptive(
                    value: state.selectedReorders.any((e) => e.id == reorder.id),
                    onChanged: (value) => reorderBloc.add(OnReorderSelectedEvent(reorder: reorder)),
                  ),
                ),
                Padding(padding: padding, child: Text(reorder.reorderSupplier.company)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 0, right: paddingRight),
                    child: ConstrainedBox(
                      constraints: constraints,
                      child: TextButton(
                        onPressed: () {
                          context.router.push(ReorderDetailRoute(reorderCreateOrEdit: ReorderCreateOrEdit.edit, reorderId: reorder.id));
                        },
                        child: Text(reorder.reorderNumber.toString()),
                      ),
                    ),
                  ),
                ),
                Padding(padding: padding, child: Text(reorder.reorderNumberInternal)),
                Padding(padding: padding, child: Text(DateFormat('dd.MM.yyy', 'de').format(reorder.creationDate))),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(padding: padding, child: Text('${reorder.productsTotalNet.toMyCurrencyStringToShow()} ${reorder.currency}')),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(padding: padding, child: Text('${reorder.totalPriceGross.toMyCurrencyStringToShow()} ${reorder.currency}')),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 4, right: paddingRight),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 24),
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: reorder.reorderStatus.toColor(),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Center(child: Text(reorder.reorderStatus.convert())),
                      ),
                    ),
                  ),
                ),
              ],
            ));

            // Trennlinie als Zeilendekoration hinzufügen
            rows.add(TableRow(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey),
                ),
              ),
              children: rowChildren,
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

        return Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: buildReorderTable(state.listOfFilteredReorders!),
            ),
          ),
        );
      },
    );
  }
}

class _ReorderContainer extends StatelessWidget {
  final Reorder reorder;
  final int index;
  final ReorderBloc reorderBloc;

  const _ReorderContainer({required this.reorder, required this.index, required this.reorderBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReorderBloc, ReorderState>(
      bloc: reorderBloc,
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: Row(
            children: [
              Checkbox.adaptive(
                value: state.selectedReorders.any((e) => e.id == reorder.id),
                onChanged: (_) => reorderBloc.add(OnReorderSelectedEvent(reorder: reorder)),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => context.router.push(ReorderDetailRoute(reorderCreateOrEdit: ReorderCreateOrEdit.edit, reorderId: reorder.id)),
                  child: Text(reorder.reorderNumber.toString()),
                ),
              ),
              Expanded(
                child: Text(reorder.reorderSupplier.name),
              ),
            ],
          ),
        );
      },
    );
  }
}
