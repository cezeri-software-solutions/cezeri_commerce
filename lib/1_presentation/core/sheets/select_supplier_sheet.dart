import 'dart:async';
import 'dart:math';

import 'package:cezeri_commerce/1_presentation/core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../2_application/database/supplier/supplier_bloc.dart';
import '../../../3_domain/entities/reorder/supplier.dart';
import '../../../constants.dart';
import '../../../injection.dart';

Future<Supplier?> showSelectSupplierSheet(BuildContext context) async {
  final completer = Completer<Supplier?>();
  final supplierBloc = sl<SupplierBloc>()..add(GetSuppliersEvenet(calcCount: true, currentPage: 1));

  WoltModalSheet.show<void>(
    context: context,
    useSafeArea: false,
    showDragHandle: false,
    pageListBuilder: (BuildContext context) {
      return [
        WoltModalSheetPage(
          hasTopBarLayer: true,
          isTopBarLayerAlwaysVisible: true,
          forceMaxHeight: true,
          topBarTitle: const Text('Lieferant auswählen', style: TextStyles.h2Bold),
          stickyActionBar: BlocProvider.value(
            value: supplierBloc,
            child: BlocBuilder<SupplierBloc, SupplierState>(
              builder: (context, state) {
                return PagesPaginationBar(
                  currentPage: state.currentPage,
                  totalPages: (state.totalQuantity / state.perPageQuantity).ceil(),
                  itemsPerPage: state.perPageQuantity,
                  totalItems: state.totalQuantity,
                  onPageChanged: (newPage) => supplierBloc.add(GetSuppliersEvenet(calcCount: false, currentPage: newPage)),
                  onItemsPerPageChanged: (newValue) => supplierBloc.add(SupplierItemsPerPageChangedEvent(value: newValue)),
                );
              },
            ),
          ),
          child: BlocProvider.value(
            value: supplierBloc,
            child: _SelectSupplierSheet(
              onSupplierSelected: (supplier) {
                Navigator.of(context).pop();
                completer.complete(supplier);
              },
            ),
          ),
        ),
      ];
    },
  );

  return completer.future;
}

class _SelectSupplierSheet extends StatelessWidget {
  final void Function(Supplier) onSupplierSelected;

  const _SelectSupplierSheet({required this.onSupplierSelected});

  @override
  Widget build(BuildContext context) {
    final supplierBloc = BlocProvider.of<SupplierBloc>(context);

    return BlocBuilder<SupplierBloc, SupplierState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(bottom: max(MediaQuery.paddingOf(context).bottom, 16)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: CupertinoSearchTextField(
                  controller: state.searchController,
                  onChanged: (value) => supplierBloc.add(GetSuppliersEvenet(calcCount: true, currentPage: 1)),
                  onSuffixTap: () => supplierBloc.add(OnSupplierSearchControllerClearedEvent()),
                ),
              ),
              _SupplierItem(onSupplierSelected: onSupplierSelected),
            ],
          ),
        );
      },
    );
  }
}

class _SupplierItem extends StatelessWidget {
  final void Function(Supplier) onSupplierSelected;

  const _SupplierItem({required this.onSupplierSelected});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final height = screenHeight - 300;

    return BlocBuilder<SupplierBloc, SupplierState>(
      builder: (context, state) {
        final onLoadingWidget = SizedBox(height: height, child: const Center(child: MyCircularProgressIndicator()));
        final onErrorWidget = SizedBox(height: height, child: const Center(child: Text('Ein Fehler ist aufgetreten!')));
        final onEmptyWidget = SizedBox(height: height, child: const Center(child: Text('Es konnten keine Artikel gefunden werden.')));

        if (state.isLoadingSuppliersOnObserve) return onLoadingWidget;
        if (state.firebaseFailure != null && state.isAnyFailure) return onErrorWidget;
        if (state.listOfAllSuppliers == null) return onLoadingWidget;
        if (state.listOfAllSuppliers!.isEmpty) return onEmptyWidget;

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: state.listOfAllSuppliers!.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final supplier = state.listOfAllSuppliers![index];

            return ListTile(
              dense: true,
              title: Text('${supplier.supplierNumber} / ${supplier.name}', style: TextStyles.defaultt),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (supplier.company.isNotEmpty) Text(supplier.company),
                  Text(supplier.creationDate.toFormattedDayMonthYear()),
                ],
              ),
              isThreeLine: true,
              onTap: () => onSupplierSelected(supplier),
            );
          },
        );
      },
    );
  }
}
