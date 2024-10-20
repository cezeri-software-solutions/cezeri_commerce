import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../2_application/database/incoming_invoice_detail/incoming_invoice_detail_bloc.dart';
import '../../../3_domain/entities/reorder/supplier.dart';
import '../../../constants.dart';
import '../../../injection.dart';
import '../../../routes/router.gr.dart';
import '../../core/core.dart';
import 'incoming_invoice_detail_page.dart';

enum IncomingInvoiceAddEditType { create, copy, edit }

@RoutePage()
class IncomingInvoiceDetailScreen extends StatefulWidget {
  final IncomingInvoiceAddEditType type;
  final Supplier? supplier;
  final String? incomingInvoiceId;

  const IncomingInvoiceDetailScreen({super.key, required this.type, required this.supplier, required this.incomingInvoiceId});

  @override
  State<IncomingInvoiceDetailScreen> createState() => _IncomingInvoiceDetailScreenState();
}

class _IncomingInvoiceDetailScreenState extends State<IncomingInvoiceDetailScreen> with AutomaticKeepAliveClientMixin {
  late final IncomingInvoiceDetailBloc incomingInvoiceDetailBloc;

  @override
  void initState() {
    super.initState();
    incomingInvoiceDetailBloc = sl<IncomingInvoiceDetailBloc>();
    incomingInvoiceDetailBloc.add(SetIncomingInvoiceEvent(type: widget.type, supplier: widget.supplier, incomingInvoiceId: widget.incomingInvoiceId));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    log('Übergebene Type: ${widget.type}');

    return BlocProvider.value(
      value: incomingInvoiceDetailBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<IncomingInvoiceDetailBloc, IncomingInvoiceDetailState>(
            listenWhen: (p, c) => p.fosInvoiceOnObserveOption != c.fosInvoiceOnObserveOption,
            listener: (context, state) {
              state.fosInvoiceOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (_) => myScaffoldMessenger(context, null, null, 'Eingangsrechnung erfolgreich geladen', null),
                ),
              );
            },
          ),
          BlocListener<IncomingInvoiceDetailBloc, IncomingInvoiceDetailState>(
            listenWhen: (p, c) => p.fosInvoiceOnCreateOption != c.fosInvoiceOnCreateOption,
            listener: (context, state) {
              state.fosInvoiceOnCreateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (invoice) {
                    myScaffoldMessenger(context, null, null, 'Eingangsrechnung erfolgreich erstellt', null);
                    Navigator.of(context).pop();
                    context.router.push(IncomingInvoiceDetailRoute(
                      type: IncomingInvoiceAddEditType.edit,
                      supplier: null,
                      incomingInvoiceId: invoice.id,
                    ));
                  },
                ),
              );
            },
          ),
        ],
        child: BlocBuilder<IncomingInvoiceDetailBloc, IncomingInvoiceDetailState>(
          builder: (context, state) {
            final appBar = AppBar(title: const Text('Eingangsrechnung'));

            if (state.isLoadingInvoiceOnObserve) return Scaffold(appBar: appBar, body: const Center(child: CircularProgressIndicator()));
            if (state.abstractFailure != null) return Scaffold(appBar: appBar, body: const Center(child: Text('Ein Fehler ist aufgetreten')));
            if (state.invoice == null) return Scaffold(appBar: appBar, body: const Center(child: CircularProgressIndicator()));

            return Scaffold(
              backgroundColor: Colors.grey[50],
              appBar: AppBar(
                title: Text(
                    state.invoice!.incomingInvoiceNumberAsString.isNotEmpty ? state.invoice!.incomingInvoiceNumberAsString : 'Neue Eingangsrechnung'),
                actions: _getActions(context, incomingInvoiceDetailBloc, state, widget.incomingInvoiceId),
              ),
              body: IncomingInvoiceDetailPage(incomingInvoiceDetailBloc: incomingInvoiceDetailBloc),
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

List<Widget>? _getActions(
  BuildContext context,
  IncomingInvoiceDetailBloc incomingInvoiceDetailBloc,
  IncomingInvoiceDetailState state,
  String? incomingInvoiceId,
) {
  log(state.type.toString());
  // void onSafePressed() {
  //   if (productId != null) {
  //     productDetailBloc.add(UpdateProductEvent());
  //   } else {
  //     // TODO: Handle create new product
  //   }
  // }

  return [
    // if (productId != null)
    //   IconButton(
    //     onPressed: () => incomingInvoiceDetailBloc.add(GetProductEvent(id: state.product!.id)),
    //     icon: const Icon(Icons.refresh, size: 30),
    //   ),
    ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET)
        ? MyOutlinedButton(
            buttonText: 'Speichern',
            onPressed: () => state.type == IncomingInvoiceAddEditType.create || state.type == IncomingInvoiceAddEditType.copy
                ? incomingInvoiceDetailBloc.add(CreateIncomingInvoiceEvent())
                : showMyDialogNotImplemented(
                    context: context,
                    content: 'Das Bearbeiten von Eingangsrechnungen ist nicht implementiert',
                  ), //incomingInvoiceDetailBloc.add(UpdateIncomingInvoiceEvent()),
            isLoading: state.isLoadingInvoiceOnCreate || state.isLoadingInvoiceOnUpdate,
            buttonBackgroundColor: Colors.green,
          )
        : MyIconButton(
            onPressed: () => state.type == IncomingInvoiceAddEditType.create || state.type == IncomingInvoiceAddEditType.copy
                ? incomingInvoiceDetailBloc.add(CreateIncomingInvoiceEvent())
                : showMyDialogNotImplemented(
                    context: context,
                    content: 'Das Bearbeiten von Eingangsrechnungen ist nicht implementiert',
                  ), //incomingInvoiceDetailBloc.add(UpdateIncomingInvoiceEvent()),
            isLoading: state.isLoadingInvoiceOnCreate || state.isLoadingInvoiceOnUpdate,
            icon: const Icon(Icons.save, color: Colors.green),
            // isLoading: state.isLoadingProductOnUpdate,
          ),
    if (ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET)) Gaps.w24,
  ];
}
