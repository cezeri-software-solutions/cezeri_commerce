import 'dart:async';
import 'dart:math';

import 'package:cezeri_commerce/1_presentation/core/core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../3_domain/entities/reorder/reorder.dart';
import '../../../3_domain/repositories/database/reorder_repository.dart';
import '../../../constants.dart';

Future<Reorder?> showSelectReorderBySupplierIdSheet(BuildContext context, String supplierId) async {
  final completer = Completer<Reorder?>();

  WoltModalSheet.show<void>(
    context: context,
    useSafeArea: false,
    showDragHandle: false,
    pageListBuilder: (BuildContext context) {
      return [
        WoltModalSheetPage(
          hasTopBarLayer: true,
          isTopBarLayerAlwaysVisible: true,
          topBarTitle: const Text('Bestellung auswählen', style: TextStyles.h2Bold),
          child: _SelectReorderSheet(
            supplierId: supplierId,
            onSupplierSelected: (supplier) {
              Navigator.of(context).pop();
              completer.complete(supplier);
            },
          ),
        ),
      ];
    },
  );

  return completer.future;
}

class _SelectReorderSheet extends StatefulWidget {
  final String supplierId;
  final void Function(Reorder) onSupplierSelected;

  const _SelectReorderSheet({required this.supplierId, required this.onSupplierSelected});

  @override
  State<_SelectReorderSheet> createState() => __SelectReorderSheetState();
}

class __SelectReorderSheetState extends State<_SelectReorderSheet> {
  List<Reorder>? _listOfReorders;
  bool _isLoadingFailure = false;

  @override
  void initState() {
    super.initState();

    _loadReorders();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingFailure) {
      return Container(
        padding: const EdgeInsets.all(10),
        height: 400,
        child: const Center(child: Text('Fehler beim Laden der Bestellungen', style: TextStyles.h3Bold)),
      );
    }

    if (_listOfReorders == null) return const SizedBox(height: 400, child: Center(child: MyCircularProgressIndicator()));

    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: max(MediaQuery.paddingOf(context).bottom, 16)),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _listOfReorders!.length,
        separatorBuilder: (context, index) => Gaps.h4,
        itemBuilder: (context, index) {
          return _ReorderItem(reorder: _listOfReorders![index], onSupplierSelected: widget.onSupplierSelected);
        },
      ),
    );
  }

  void _loadReorders() async {
    final reorderRepo = GetIt.I.get<ReorderRepository>();

    final fos = await reorderRepo.getListOfReordersBySupplierId(widget.supplierId);
    if (fos.isLeft()) {
      if (mounted) failureRenderer(context, [fos.getLeft()]);
      setState(() => _isLoadingFailure = true);
      return;
    }

    print('supplierId: ${widget.supplierId}');
    print('_listOfReorders.lenght: ${fos.getRight().length}');
    setState(() => _listOfReorders = fos.getRight());
  }
}

class _ReorderItem extends StatelessWidget {
  final Reorder reorder;
  final void Function(Reorder) onSupplierSelected;

  const _ReorderItem({required this.reorder, required this.onSupplierSelected});

  @override
  Widget build(BuildContext context) {
    return MyFormFieldContainer(
      borderRadius: 10,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => onSupplierSelected(reorder),
                child: Text(reorder.reorderNumber.toString()),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Erstellt am', style: TextStyles.infoOnTextFieldSmall),
                  Text(reorder.creationDate.toFormattedDayMonthYear()),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Bestellnummer', style: TextStyles.infoOnTextFieldSmall),
                  Text(reorder.reorderNumberInternal.toString()),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Anzahl Artikel', style: TextStyles.infoOnTextFieldSmall),
                  Text(reorder.listOfReorderProducts.length.toString()),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Status', style: TextStyles.infoOnTextFieldSmall),
                  reorder.reorderStatus.toChip(height: 20, fontSize: 12),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Preis Netto', style: TextStyles.infoOnTextFieldSmall),
                  Text('${reorder.totalPriceNet.toMyCurrencyString()} €'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
