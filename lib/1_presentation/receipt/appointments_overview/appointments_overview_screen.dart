import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/app_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/firebase/appointment/appointment_bloc.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../constants.dart';
import '../../../injection.dart';
import '../../../routes/router.gr.dart';
import '../../core/functions/my_scaffold_messanger.dart';
import '../../core/widgets/my_delete_dialog.dart';
import '../../core/widgets/my_info_dialog.dart';
import '../../core/widgets/my_outlined_button.dart';
import 'appointments_overview_page.dart';

@RoutePage()
class AppointmentsOverviewScreen extends StatelessWidget {
  const AppointmentsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appointmentBloc = sl<AppointmentBloc>()..add(GetAllAppointmentsEvent());

    final searchController = TextEditingController();

    return BlocProvider<AppointmentBloc>(
      create: (context) => appointmentBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<AppointmentBloc, AppointmentState>(
            listenWhen: (p, c) => p.fosAppointmentsOnObserveOption != c.fosAppointmentsOnObserveOption,
            listener: (context, state) {
              state.fosAppointmentsOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => myScaffoldMessenger(context, failure, null, null, null),
                  (listOfAppointments) => null,
                ),
              );
            },
          ),
          BlocListener<AppointmentBloc, AppointmentState>(
            listenWhen: (p, c) => p.fosAppointmentsOnObserveFromPrestaOption != c.fosAppointmentsOnObserveFromPrestaOption,
            listener: (context, state) {
              state.fosAppointmentsOnObserveFromPrestaOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => myScaffoldMessenger(context, failure, null, null, null),
                  (listOfProducts) => myScaffoldMessenger(context, null, null, 'Aufträge erfolgreich aus den Marktplätzen geladen', null),
                ),
              );
            },
          ),
          BlocListener<AppointmentBloc, AppointmentState>(
            listenWhen: (p, c) => p.fosAppointmentOnUpdateOption != c.fosAppointmentOnUpdateOption,
            listener: (context, state) {
              state.fosAppointmentOnUpdateOption.fold(
                () => null,
                (a) => a.fold(
                  (prestaFailure) => context.router.popUntilRouteWithName(AppointmentsOverviewRoute.name),
                  (unit) => context.router.popUntilRouteWithName(AppointmentsOverviewRoute.name),
                ),
              );
            },
          ),
          BlocListener<AppointmentBloc, AppointmentState>(
            listenWhen: (p, c) => p.fosAppointmentOnDeleteOption != c.fosAppointmentOnDeleteOption,
            listener: (context, state) {
              state.fosAppointmentOnDeleteOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) {
                    myScaffoldMessenger(context, failure, null, null, null);
                    context.router.popUntilRouteWithName(AppointmentsOverviewRoute.name);
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
          builder: (context, state) {
            return Scaffold(
              drawer: const AppDrawer(),
              appBar: AppBar(
                title: const Text('Aufträge'),
                actions: [
                  Tooltip(
                    message: 'Senden',
                    child: IconButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => BlocProvider.value(
                          value: appointmentBloc,
                          child: _GenerateDialog(listOfReceipts: state.selectedAppointments),
                        ),
                      ),
                      icon: const Icon(Icons.send, color: CustomColors.primaryColor),
                    ),
                  ),
                  IconButton(onPressed: () => context.read<AppointmentBloc>().add(GetAllAppointmentsEvent()), icon: const Icon(Icons.refresh)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.add, color: Colors.green)),
                  IconButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => state.selectedAppointments.isEmpty
                          ? const MyInfoDialog(title: 'Achtung!', content: 'Bitte wähle mindestens einen Artikel aus.')
                          : MyDeleteDialog(
                              content: 'Bist du sicher, dass du alle ausgewählten Artikel unwiederruflich löschen willst?',
                              onConfirm: () {
                                context
                                    .read<AppointmentBloc>()
                                    .add(DeleteSelectedAppointmentsEvent(selectedAppointments: state.selectedAppointments));
                                context.router.pop();
                              },
                            ),
                    ),
                    icon: state.isLoadingAppointmentOnDelete
                        ? const CircularProgressIndicator(color: Colors.red)
                        : const Icon(Icons.delete, color: Colors.red),
                  ),
                  IconButton(
                    onPressed: () => context.read<AppointmentBloc>().add(GetNewAppointmentsFromPrestaEvent()),
                    icon: state.isLoadingAppointmentsFromPrestaOnObserve ? const CircularProgressIndicator() : const Icon(Icons.download),
                  )
                ],
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: CupertinoSearchTextField(
                      controller: searchController,
                      onChanged: (value) => context.read<AppointmentBloc>().add(SetSearchFieldTextAppointmentsEvent(searchText: value)),
                      onSubmitted: (value) => context.read<AppointmentBloc>().add(OnSearchFieldSubmittedAppointmentsEvent()),
                      onSuffixTap: () {
                        searchController.clear();
                        context.read<AppointmentBloc>().add(SetSearchFieldTextAppointmentsEvent(searchText: ''));
                        context.read<AppointmentBloc>().add(OnSearchFieldSubmittedAppointmentsEvent());
                      },
                    ),
                  ),
                  DefaultTabController(
                    length: 2,
                    child: TabBar(
                      tabs: const [Tab(text: 'Offen'), Tab(text: 'Alle')],
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                      unselectedLabelStyle: const TextStyle(),
                      onTap: (value) => value == 0 ? appointmentBloc.add(GetOpenAppointmentsEvent()) : appointmentBloc.add(GetAllAppointmentsEvent()),
                    ),
                  ),
                  AppointmentsOverviewPage(appointmentBloc: appointmentBloc),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _GenerateDialog extends StatefulWidget {
  final List<Receipt> listOfReceipts;

  const _GenerateDialog({required this.listOfReceipts});

  @override
  State<_GenerateDialog> createState() => __GenerateDialogState();
}

class __GenerateDialogState extends State<_GenerateDialog> {
  bool _createDeliveryNote = true;
  bool _printDeliveryNote = false;
  bool _createInvoice = true;
  bool _printInvoice = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        return Dialog(
          child: SizedBox(
            width: 600,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Versenden', style: TextStyles.h1),
                  const Divider(),
                  Gaps.h24,
                  Text('Ausgewählte Belege: ${widget.listOfReceipts.length}', style: TextStyles.h3BoldPrimary),
                  Gaps.h42,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 150, child: Text('Lieferschein:', style: TextStyles.h3Bold)),
                      Column(
                        children: [
                          const Text('Erstellen'),
                          Switch.adaptive(value: _createDeliveryNote, onChanged: (value) => setState(() => _createDeliveryNote = value)),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Drucken'),
                          Switch.adaptive(value: _printDeliveryNote, onChanged: (value) => setState(() => _printDeliveryNote = value)),
                        ],
                      ),
                    ],
                  ),
                  Gaps.h42,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 150, child: Text('Rechnung:', style: TextStyles.h3Bold)),
                      Column(
                        children: [
                          const Text('Erstellen'),
                          Switch.adaptive(value: _createInvoice, onChanged: (value) => setState(() => _createInvoice = value)),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Drucken'),
                          Switch.adaptive(value: _printInvoice, onChanged: (value) => setState(() => _printInvoice = value)),
                        ],
                      ),
                    ],
                  ),
                  Gaps.h54,
                  Align(
                    alignment: Alignment.centerRight,
                    child: MyOutlinedButton(buttonText: 'Anlegen', buttonBackgroundColor: Colors.green, onPressed: () {}),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
