import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/3_domain/entities/receipt/receipt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';

import '../../../2_application/database/main_settings/main_settings_bloc.dart';
import '../../../2_application/database/receipt/receipt_bloc.dart';
import '../../../2_application/database/receipt_detail/receipt_detail_bloc.dart';
import '../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../injection.dart';
import '../../../routes/router.gr.dart';
import '../../core/functions/load_file_from_storage.dart';
import '../../core/functions/my_scaffold_messanger.dart';
import '../../core/renderer/failure_renderer.dart';
import 'receipt_detail_page.dart';

enum ReceiptCreateOrEdit { create, edit }

@RoutePage()
class ReceiptDetailScreen extends StatefulWidget {
  final ReceiptBloc receiptBloc;
  final List<AbstractMarketplace> listOfMarketplaces;
  final ReceiptCreateOrEdit receiptCreateOrEdit;
  final ReceiptTyp receiptTyp;

  const ReceiptDetailScreen({
    super.key,
    required this.receiptBloc,
    required this.listOfMarketplaces,
    required this.receiptCreateOrEdit,
    required this.receiptTyp,
  });

  @override
  State<ReceiptDetailScreen> createState() => _ReceiptDetailScreenState();
}

class _ReceiptDetailScreenState extends State<ReceiptDetailScreen> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    final receiptDetailBloc = sl<ReceiptDetailBloc>();
    if (widget.receiptCreateOrEdit == ReceiptCreateOrEdit.create) {
      receiptDetailBloc.add(SetListOfReceiptProductssReceiptDetailEvent(
        receipt: widget.receiptBloc.state.receipt!,
        listOfTaxRules: context.read<MainSettingsBloc>().state.mainSettings!.taxes,
      ));
    }

    return BlocProvider.value(
      value: receiptDetailBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<ReceiptBloc, ReceiptState>(
            bloc: widget.receiptBloc,
            listenWhen: (p, c) => p.fosReceiptOnObserveOption != c.fosReceiptOnObserveOption,
            listener: (context, state) {
              state.fosReceiptOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (appointment) => receiptDetailBloc.add(SetReceiptReceiptDetailEvent(
                    receipt: appointment,
                    listOfTaxRules: context.read<MainSettingsBloc>().state.mainSettings!.taxes,
                  )),
                ),
              );
            },
          ),
          BlocListener<ReceiptBloc, ReceiptState>(
            bloc: widget.receiptBloc,
            listenWhen: (p, c) => p.fosReceiptOnUpdateOption != c.fosReceiptOnUpdateOption,
            listener: (context, state) {
              state.fosReceiptOnUpdateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => null,
                  (unit) => myScaffoldMessenger(context, null, null, 'Dokument erfolgreich aktualisiert', null),
                ),
              );
            },
          ),
          BlocListener<ReceiptBloc, ReceiptState>(
            bloc: widget.receiptBloc,
            listenWhen: (p, c) => p.fosReceiptOnCreateOption != c.fosReceiptOnCreateOption,
            listener: (context, state) {
              state.fosReceiptOnCreateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (receipt) {
                    myScaffoldMessenger(context, null, null, 'Dokument erfolgreich erstellt', null);
                    context.router.maybePop();
                    widget.receiptBloc.add(GetReceiptEvent(appointment: receipt));
                    context.router.push(
                      ReceiptDetailRoute(
                        receiptBloc: widget.receiptBloc,
                        listOfMarketplaces: widget.listOfMarketplaces,
                        receiptCreateOrEdit: ReceiptCreateOrEdit.edit,
                        receiptTyp: widget.receiptTyp,
                      ),
                    );
                  },
                ),
              );
            },
          ),
          BlocListener<ReceiptBloc, ReceiptState>(
            bloc: widget.receiptBloc,
            listenWhen: (p, c) => p.fosReceiptOnDeleteOption != c.fosReceiptOnDeleteOption,
            listener: (context, state) {
              state.fosReceiptOnDeleteOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (unit) {
                    myScaffoldMessenger(context, null, null, 'Autrag / Aufträge erfolgreich gelöscht', null);
                    context.router.popUntilRouteWithName(AppointmentsOverviewRoute.name);
                  },
                ),
              );
            },
          ),
          BlocListener<ReceiptBloc, ReceiptState>(
            bloc: widget.receiptBloc,
            listenWhen: (p, c) => p.fosParcelLabelOnCreate != c.fosParcelLabelOnCreate,
            listener: (context, state) {
              state.fosParcelLabelOnCreate.fold(
                () => null,
                (a) => a.fold(
                  (failure) {
                    myScaffoldMessenger(context, null, null, null, 'Paketlabel konnte nicht erstellt werden');
                  },
                  (parcelTracking) async {
                    myScaffoldMessenger(context, null, null, 'Paketlabel erfolgreich erstellt', null);
                    if (parcelTracking.pdfString.isNotEmpty) {
                      final pdfBytes = await loadFileFromStorage(parcelTracking.pdfString);
                      if (pdfBytes == null) return;
                      await Printing.layoutPdf(onLayout: (_) => pdfBytes);
                    }
                  },
                ),
              );
            },
          ),
        ],
        child: BlocBuilder<ReceiptBloc, ReceiptState>(
          bloc: widget.receiptBloc,
          builder: (context, state) {
            final appBar = AppBar(
              title: state.receipt == null
                  ? const Text('Dokument:')
                  : switch (state.receipt!.receiptTyp) {
                      ReceiptTyp.offer => const Text('Angebot'),
                      ReceiptTyp.appointment => const Text('Auftrag'),
                      ReceiptTyp.deliveryNote => const Text('Lieferschein'),
                      ReceiptTyp.invoice => const Text('Rechnung'),
                      ReceiptTyp.credit => const Text('Gutschrift'),
                    },
            );

            if (state.isLoadingReceiptOnObserve) return Scaffold(appBar: appBar, body: const Center(child: CircularProgressIndicator()));
            if ((state.firebaseFailure != null && state.isAnyFailure) ||
                (widget.receiptCreateOrEdit == ReceiptCreateOrEdit.edit && state.receipt == null)) {
              return Scaffold(appBar: appBar, body: const Center(child: Text('Ein Fehler ist aufgetreten')));
            }
            return ReceiptDetailPage(
              receiptBloc: widget.receiptBloc,
              receiptDetailBloc: receiptDetailBloc,
              listOfMarketplaces: widget.listOfMarketplaces,
              receiptCreateOrEdit: widget.receiptCreateOrEdit,
              receiptTyp: widget.receiptTyp,
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
