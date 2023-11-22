import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/3_domain/entities/receipt/receipt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/firebase/appointment/appointment_bloc.dart';
import '../../../2_application/firebase/main_settings/main_settings_bloc.dart';
import '../../../2_application/firebase/receipt_detail/receipt_detail_bloc.dart';
import '../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../injection.dart';
import '../../../routes/router.gr.dart';
import '../../core/functions/my_scaffold_messanger.dart';
import 'appointment_detail_page.dart';

enum ReceiptCreateOrEdit { create, edit }

@RoutePage()
class AppointmentDetailScreen extends StatelessWidget {
  final AppointmentBloc appointmentBloc;
  final List<Marketplace> listOfMarketplaces;
  final ReceiptCreateOrEdit receiptCreateOrEdit;

  const AppointmentDetailScreen({super.key, required this.appointmentBloc, required this.listOfMarketplaces, required this.receiptCreateOrEdit});

  @override
  Widget build(BuildContext context) {
    final receiptDetailBloc = sl<ReceiptDetailBloc>();
    if (receiptCreateOrEdit == ReceiptCreateOrEdit.create) {
      receiptDetailBloc.add(SetListOfReceiptProductssReceiptDetailEvent(
        receipt: appointmentBloc.state.receipt!,
        listOfTaxRules: context.read<MainSettingsBloc>().state.mainSettings!.taxes,
      ));
    }

    return BlocProvider(
      create: (context) => receiptDetailBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<AppointmentBloc, AppointmentState>(
            bloc: appointmentBloc,
            listenWhen: (p, c) => p.fosReceiptOnObserveOption != c.fosReceiptOnObserveOption,
            listener: (context, state) {
              state.fosReceiptOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => myScaffoldMessenger(context, failure, null, null, null),
                  (appointment) => receiptDetailBloc.add(SetReceiptReceiptDetailEvent(
                    receipt: appointment,
                    listOfTaxRules: context.read<MainSettingsBloc>().state.mainSettings!.taxes,
                  )),
                ),
              );
            },
          ),
          BlocListener<AppointmentBloc, AppointmentState>(
            bloc: appointmentBloc,
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
          BlocListener<AppointmentBloc, AppointmentState>(
            bloc: appointmentBloc,
            listenWhen: (p, c) => p.fosReceiptOnCreateOption != c.fosReceiptOnCreateOption,
            listener: (context, state) {
              state.fosReceiptOnCreateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => myScaffoldMessenger(context, failure, null, null, null),
                  (receipt) => myScaffoldMessenger(context, null, null, 'Dokument erfolgreich erstellt', null),
                ),
              );
            },
          ),
          BlocListener<AppointmentBloc, AppointmentState>(
            bloc: appointmentBloc,
            listenWhen: (p, c) => p.fosReceiptOnDeleteOption != c.fosReceiptOnDeleteOption,
            listener: (context, state) {
              state.fosReceiptOnDeleteOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) {
                    myScaffoldMessenger(context, failure, null, null, null);
                  },
                  (unit) {
                    myScaffoldMessenger(context, null, null, 'Autrag / Aufträge erfolgreich gelöscht', null);
                    context.router.popUntilRouteWithName(AppointmentsOverviewRoute.name);
                  },
                ),
              );
            },
          ),
        ],
        child: BlocBuilder<AppointmentBloc, AppointmentState>(
          bloc: appointmentBloc,
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
            if ((state.firebaseFailure != null && state.isAnyFailure) || (receiptCreateOrEdit == ReceiptCreateOrEdit.edit && state.receipt == null)) {
              return Scaffold(appBar: appBar, body: const Center(child: Text('Ein Fehler ist aufgetreten')));
            }
            return AppointmentDetailPage(
              appointmentBloc: appointmentBloc,
              receiptDetailBloc: receiptDetailBloc,
              listOfMarketplaces: listOfMarketplaces,
              receiptCreateOrEdit: receiptCreateOrEdit,
            );
          },
        ),
      ),
    );
  }
}
