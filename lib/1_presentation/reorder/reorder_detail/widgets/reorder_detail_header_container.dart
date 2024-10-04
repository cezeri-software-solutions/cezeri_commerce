import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../2_application/database/reorder_detail/reorder_detail_bloc.dart';
import '../../../../3_domain/entities/reorder/reorder.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';
import '../functions/on_pdf_pressed.dart';

class ReorderDetailHeaderContainer extends StatelessWidget {
  final ReorderDetailBloc reorderDetailBloc;

  const ReorderDetailHeaderContainer({super.key, required this.reorderDetailBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReorderDetailBloc, ReorderDetailState>(
      bloc: reorderDetailBloc,
      builder: (context, state) {
        return MyFormFieldContainer(
          width: double.infinity,
          borderRadius: 6,
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nachbestellung: ${state.reorder!.reorderNumber.toString()}'),
                        Text(state.reorder!.reorderSupplier.company),
                        Text('Vorsteuer: ${state.reorder!.tax.taxRate.toString()} %')
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Text('Dokumentdatum:'),
                        Text(DateFormat('dd.MM.yyy', 'de').format(state.reorder!.creationDate)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Text('Status:'),
                        Container(
                          height: 30,
                          decoration: BoxDecoration(
                            color: switch (state.reorder!.reorderStatus) {
                              ReorderStatus.open => CustomColors.backgroundLightGrey,
                              ReorderStatus.partiallyCompleted => CustomColors.backgroundLightOrange,
                              ReorderStatus.completed => CustomColors.backgroundLightGreen,
                            },
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Center(
                              child: switch (state.reorder!.reorderStatus) {
                                ReorderStatus.open => const Text('Offen'),
                                ReorderStatus.partiallyCompleted => const Text('Teilweise offen'),
                                ReorderStatus.completed => const Text('Geschlossen'),
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: 120,
                      child: MyTextFormFieldSmall(
                        fieldTitle: 'Bestellnummer intern',
                        controller: state.reorderNumberInternalController,
                        onChanged: (_) => reorderDetailBloc.add(OnReorderDetailControllerChangedEvent()),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: state.listOfMarketplaces != null && state.listOfMarketplaces!.isNotEmpty
                                  ? () async => await onPdfPressed(
                                      context: context, reorder: state.reorder!, marketplaces: state.listOfMarketplaces!) //TODO: Shopify
                                  : () => reorderDetailBloc.add(OnReorderDetailGetPdfDataEvent()),
                              icon:
                                  state.isLoadingPdfData ? const MyCircularProgressIndicator() : const Icon(Icons.picture_as_pdf, color: Colors.red),
                            ),
                            Gaps.w16,
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () async => await _showDateRangePicker(context, reorderDetailBloc),
                              icon: const Icon(Icons.date_range, color: CustomColors.primaryColor),
                            ),
                          ],
                        ),
                        state.statProductDateRange != null && state.statProductDateRange != null
                            ? Text(
                                '${DateFormat('dd.MM.yyy', 'de').format(state.statProductDateRange!.start)} - ${DateFormat('dd.MM.yyy', 'de').format(DateTime(state.statProductDateRange!.end.year, state.statProductDateRange!.end.month, state.statProductDateRange!.end.day - 1))}',
                                style: TextStyles.defaultBold,
                              )
                            : const Text(''),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        const Text('Alle Artikel anzeigen'),
                        Switch.adaptive(
                          value: state.getAllProducts,
                          onChanged: (_) => reorderDetailBloc.add(OnReorderDetailSetLoadAllProductsEvent()),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      children: [
                        const Text('Manuell geschlossen'),
                        Switch.adaptive(
                          value: state.reorder!.closedManually,
                          onChanged: (value) => reorderDetailBloc.add(OnReorderDetailClosedManuallyChangeEvent(value: value)),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _showDateRangePicker(BuildContext context, ReorderDetailBloc reorderDetailBloc) async {
    final now = DateTime.now();

    final newDateRange = await showDateRangePicker(context: context, firstDate: DateTime(now.year - 1), lastDate: now);

    if (newDateRange != null) reorderDetailBloc.add(OnReorderDetailSetStatProductFromDateEvent(dateRange: newDateRange));
  }
}
