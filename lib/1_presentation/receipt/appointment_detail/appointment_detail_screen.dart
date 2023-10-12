import 'package:auto_route/auto_route.dart';
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

    return BlocProvider(
      create: (context) => receiptDetailBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<AppointmentBloc, AppointmentState>(
            bloc: appointmentBloc,
            listenWhen: (p, c) => p.fosAppointmentOnObserveOption != c.fosAppointmentOnObserveOption,
            listener: (context, state) {
              state.fosAppointmentOnObserveOption.fold(
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
            listenWhen: (p, c) => p.fosAppointmentOnUpdateOption != c.fosAppointmentOnUpdateOption,
            listener: (context, state) {
              state.fosAppointmentOnUpdateOption.fold(
                () => null,
                (a) => a.fold(
                  (prestaFailure) => null,
                  (unit) {
                    myScaffoldMessenger(context, null, null, 'Dokument erfolgreich aktualisiert', null);
                  },
                ),
              );
            },
          ),
          BlocListener<AppointmentBloc, AppointmentState>(
            bloc: appointmentBloc,
            listenWhen: (p, c) => p.fosAppointmentOnDeleteOption != c.fosAppointmentOnDeleteOption,
            listener: (context, state) {
              state.fosAppointmentOnDeleteOption.fold(
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
            final appBar = AppBar(title: const Text('Auftrag'));

            if (state.isLoadingAppointmentOnObserve) return Scaffold(appBar: appBar, body: const Center(child: CircularProgressIndicator()));
            if ((state.firebaseFailure != null && state.isAnyFailure) ||
                (receiptCreateOrEdit == ReceiptCreateOrEdit.edit && state.appointment == null)) {
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
