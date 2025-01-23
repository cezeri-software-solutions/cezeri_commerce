import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/3_domain/entities/receipt/receipt.dart';
import 'package:cezeri_commerce/3_domain/entities/receipt/receipt_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:printing/printing.dart';

import '/2_application/database/receipt_detail/receipt_detail_bloc.dart';
import '/2_application/database/receipt_detail_products/receipt_detail_products_bloc.dart';
import '/injection.dart';
import '/routes/router.gr.dart';
import '../../core/core.dart';
import 'receipt_detail_page.dart';

enum ReceiptCreateOrEdit { create, edit }

@RoutePage()
class ReceiptDetailScreen extends StatefulWidget {
  final String? receiptId;
  final Receipt? newEmptyReceipt;
  final ReceiptType receiptTyp;

  const ReceiptDetailScreen({super.key, @PathParam('receiptId') required this.receiptId, required this.newEmptyReceipt, required this.receiptTyp});

  @override
  State<ReceiptDetailScreen> createState() => _ReceiptDetailScreenState();
}

class _ReceiptDetailScreenState extends State<ReceiptDetailScreen> with AutomaticKeepAliveClientMixin {
  late final ReceiptDetailBloc receiptDetailBloc;
  late final ReceiptDetailProductsBloc receiptDetailProductsBloc;

  @override
  void initState() {
    super.initState();
    receiptDetailBloc = sl<ReceiptDetailBloc>();
    receiptDetailProductsBloc = sl<ReceiptDetailProductsBloc>();

    if (widget.receiptId == null && widget.newEmptyReceipt != null) {
      receiptDetailBloc.add(ReceiptDetailSetEmptyReceiptEvent(newEmptyReceipt: widget.newEmptyReceipt!));
    }
    if (widget.receiptId != null && widget.newEmptyReceipt == null) {
      receiptDetailBloc.add(ReceiptDetailGetReceiptEvent(receiptId: widget.receiptId!, receiptType: widget.receiptTyp));
    }
  }

  @override
  void dispose() {
    receiptDetailBloc.close();
    receiptDetailProductsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: receiptDetailBloc,
        ),
        BlocProvider.value(
          value: receiptDetailProductsBloc,
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          if (widget.receiptId == null && widget.newEmptyReceipt != null)
            BlocListener<ReceiptDetailBloc, ReceiptDetailState>(
              bloc: receiptDetailBloc,
              listenWhen: (p, c) => p.triggerListenerAfterSetEmptyReceipt != c.triggerListenerAfterSetEmptyReceipt,
              listener: (context, state) {
                receiptDetailProductsBloc.add(SetReceiptReceiptDetailEvent(receipt: state.receipt!, listOfTaxRules: state.mainSettings!.taxes));

                receiptDetailProductsBloc.add(SetListOfReceiptProductssReceiptDetailEvent(
                  receipt: widget.newEmptyReceipt!.copyWith(listOfReceiptProduct: [ReceiptProduct.empty()]),
                  listOfTaxRules: state.mainSettings!.taxes,
                ));
              },
            ),
          BlocListener<ReceiptDetailBloc, ReceiptDetailState>(
            bloc: receiptDetailBloc,
            listenWhen: (p, c) => p.fosReceiptOnObserveOption != c.fosReceiptOnObserveOption,
            listener: (context, state) {
              state.fosReceiptOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (appointment) => receiptDetailProductsBloc.add(
                    SetReceiptReceiptDetailEvent(
                      receipt: appointment,
                      listOfTaxRules: state.mainSettings!.taxes,
                    ),
                  ),
                ),
              );
            },
          ),
          BlocListener<ReceiptDetailBloc, ReceiptDetailState>(
            bloc: receiptDetailBloc,
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
          BlocListener<ReceiptDetailBloc, ReceiptDetailState>(
            bloc: receiptDetailBloc,
            listenWhen: (p, c) => p.fosReceiptOnCreateOption != c.fosReceiptOnCreateOption,
            listener: (context, state) {
              state.fosReceiptOnCreateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (receipt) {
                    myScaffoldMessenger(context, null, null, 'Dokument erfolgreich erstellt', null);
                    context.router.maybePop();
                    receiptDetailBloc.add(ReceiptDetailGetReceiptEvent(receiptId: receipt.id, receiptType: widget.receiptTyp));
                    context.router.push(ReceiptDetailRoute(receiptId: receipt.id, newEmptyReceipt: null, receiptTyp: widget.receiptTyp));
                  },
                ),
              );
            },
          ),
          BlocListener<ReceiptDetailBloc, ReceiptDetailState>(
            bloc: receiptDetailBloc,
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
          BlocListener<ReceiptDetailBloc, ReceiptDetailState>(
            bloc: receiptDetailBloc,
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
        child: BlocBuilder<ReceiptDetailBloc, ReceiptDetailState>(
          bloc: receiptDetailBloc,
          builder: (context, state) {
            final appBar = AppBar(title: const Text('Dokument'));

            if (state.isLoadingReceiptOnObserve) return Scaffold(appBar: appBar, body: const Center(child: CircularProgressIndicator()));
            if (state.databaseFailure != null || (widget.receiptId != null && state.receipt == null)) {
              return Scaffold(appBar: appBar, body: const Center(child: Text('Ein Fehler ist aufgetreten')));
            }
            if (!state.isLoadingReceiptOnObserve && state.receipt == null && state.databaseFailure == null) {
              return Scaffold(appBar: appBar, body: const Center(child: CircularProgressIndicator()));
            }

            return ReceiptDetailPage(
              receiptDetailBloc: receiptDetailBloc,
              receiptDetailProductsBloc: receiptDetailProductsBloc,
              listOfMarketplaces: state.listOfMarketplaces!,
              receiptCreateOrEdit: widget.receiptId == null ? ReceiptCreateOrEdit.create : ReceiptCreateOrEdit.edit,
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
