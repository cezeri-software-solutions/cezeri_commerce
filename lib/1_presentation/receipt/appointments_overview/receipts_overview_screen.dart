import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/app_drawer.dart';
import 'package:cezeri_commerce/1_presentation/core/extensions/string_to_int.dart';
import 'package:cezeri_commerce/1_presentation/core/widgets/my_dropdown_button_form_field.dart';
import 'package:cezeri_commerce/3_domain/entities/receipt/receipt_product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/firebase/appointment/appointment_bloc.dart';
import '../../../2_application/firebase/customer/customer_bloc.dart';
import '../../../2_application/firebase/marketplace/marketplace_bloc.dart';
import '../../../3_domain/entities/address.dart';
import '../../../3_domain/entities/customer/customer.dart';
import '../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../3_domain/entities/receipt/receipt_customer.dart';
import '../../../constants.dart';
import '../../../injection.dart';
import '../../../routes/router.gr.dart';
import '../../core/functions/dialogs.dart';
import '../../core/functions/my_scaffold_messanger.dart';
import '../../core/widgets/my_circular_progress_indicator.dart';
import '../../core/widgets/my_form_field_small.dart';
import '../../core/widgets/my_modal_scrollable.dart';
import '../../core/widgets/my_outlined_button.dart';
import '../appointment_detail/appointment_detail_screen.dart';
import 'receipts_overview_page.dart';

class ReceiptsOverviewScreen extends StatelessWidget {
  final ReceiptTyp receiptTyp;

  const ReceiptsOverviewScreen({super.key, required this.receiptTyp});

  @override
  Widget build(BuildContext context) {
    final appointmentBloc = sl<AppointmentBloc>()..add(GetReceiptsEvent(tabValue: 0, receiptTyp: receiptTyp));
    final marketplaceBloc = sl<MarketplaceBloc>()..add(GetAllMarketplacesEvent());
    final customerBloc = sl<CustomerBloc>();

    final searchController = TextEditingController();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AppointmentBloc>(
          create: (context) => appointmentBloc,
        ),
        BlocProvider<MarketplaceBloc>(
          create: (context) => marketplaceBloc,
        ),
        BlocProvider<CustomerBloc>(
          create: (context) => customerBloc,
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AppointmentBloc, AppointmentState>(
            listenWhen: (p, c) => p.fosReceiptsOnObserveOption != c.fosReceiptsOnObserveOption,
            listener: (context, state) {
              state.fosReceiptsOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => myScaffoldMessenger(context, failure, null, null, null),
                  (listOfAppointments) => null,
                ),
              );
            },
          ),
          BlocListener<AppointmentBloc, AppointmentState>(
            listenWhen: (p, c) => p.fosAppointmentOnObserveFromMarketplacesOption != c.fosAppointmentOnObserveFromMarketplacesOption,
            listener: (context, state) {
              state.fosAppointmentOnObserveFromMarketplacesOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) {
                    context.router.popTop();
                    myScaffoldMessenger(context, null, null, null, 'Beim Laden der Bestellung ist etwas schief gegangen');
                  },
                  (unit) {
                    context.router.popTop();
                    myScaffoldMessenger(context, null, null, 'Auftrag erfolgreich aus den Marktplätzen geladen', null);
                  },
                ),
              );
            },
          ),
          BlocListener<AppointmentBloc, AppointmentState>(
            listenWhen: (p, c) => p.fosAppointmentsOnObserveFromMarketplacesOption != c.fosAppointmentsOnObserveFromMarketplacesOption,
            listener: (context, state) {
              state.fosAppointmentsOnObserveFromMarketplacesOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) {
                    context.router.popTop();
                    myScaffoldMessenger(context, null, null, null, 'Beim Laden von mindestens einer Bestellung ist etwas schief gegangen');
                  },
                  (unit) {
                    context.router.popTop();
                    myScaffoldMessenger(context, null, null, 'Aufträge erfolgreich aus den Marktplätzen geladen', null);
                  },
                ),
              );
            },
          ),
          BlocListener<AppointmentBloc, AppointmentState>(
            listenWhen: (p, c) => p.fosReceiptOnDeleteOption != c.fosReceiptOnDeleteOption,
            listener: (context, state) {
              state.fosReceiptOnDeleteOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) {
                    myScaffoldMessenger(context, failure, null, null, null);
                    context.router.popUntilRouteWithName(switch (receiptTyp) {
                      ReceiptTyp.offer => OffersOverviewRoute.name,
                      ReceiptTyp.appointment => OffersOverviewRoute.name,
                      ReceiptTyp.deliveryNote => OffersOverviewRoute.name,
                      ReceiptTyp.invoice || ReceiptTyp.credit => OffersOverviewRoute.name,
                    });
                  },
                  (unit) {
                    myScaffoldMessenger(context, null, null, _textOnSuccessfulDelete(receiptTyp), null);
                    context.router.popUntilRouteWithName(AppointmentsOverviewRoute.name);
                  },
                ),
              );
            },
          ),
          BlocListener<AppointmentBloc, AppointmentState>(
            listenWhen: (p, c) => p.fosReceiptOnGenerateOption != c.fosReceiptOnGenerateOption,
            listener: (context, state) {
              state.fosReceiptOnGenerateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) {
                    myScaffoldMessenger(context, failure, null, null, null);
                    context.router.popTop();
                  },
                  (unit) {
                    myScaffoldMessenger(context, null, null, 'Dokument wurde erfolgreich generiert', null);
                    context.router.popTop();
                  },
                ),
              );
            },
          ),
          BlocListener<AppointmentBloc, AppointmentState>(
            listenWhen: (p, c) => p.fosReceiptsOnGenerateOption != c.fosReceiptsOnGenerateOption,
            listener: (context, state) {
              state.fosReceiptsOnGenerateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) {
                    myScaffoldMessenger(context, failure, null, null, null);
                    context.router.popTop();
                  },
                  (unit) {
                    myScaffoldMessenger(context, null, null, 'Dokumente wurden erfolgreich generiert', null);
                    context.router.popTop();
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
                title: Text(
                  switch (receiptTyp) {
                    ReceiptTyp.offer => state.listOfFilteredReceipts != null ? 'Angebote (${state.listOfFilteredReceipts!.length})' : 'Angebote',
                    ReceiptTyp.appointment =>
                      state.listOfFilteredReceipts != null ? 'Aufträge (${state.listOfFilteredReceipts!.length})' : 'Aufträge',
                    ReceiptTyp.deliveryNote =>
                      state.listOfFilteredReceipts != null ? 'Lieferscheine (${state.listOfFilteredReceipts!.length})' : 'Lieferscheine',
                    ReceiptTyp.invoice ||
                    ReceiptTyp.credit =>
                      state.listOfFilteredReceipts != null ? 'Rechnungen (${state.listOfFilteredReceipts!.length})' : 'Rechnungen',
                  },
                ),
                actions: [
                  IconButton(onPressed: () => appointmentBloc.add(SendEmailToCustomerReceiptEvent()), icon: const Icon(Icons.mail)),
                  Tooltip(
                    message: 'Senden',
                    child: IconButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => BlocProvider.value(
                          value: appointmentBloc,
                          child: switch (receiptTyp) {
                            ReceiptTyp.offer => _GenerateFromOfferNewAppointmentDialog(
                                listOfReceipts: state.selectedReceipts,
                                appointmentBloc: appointmentBloc,
                              ),
                            ReceiptTyp.appointment => _GenerateFromAppointmentDialog(
                                listOfReceipts: state.selectedReceipts,
                                appointmentBloc: appointmentBloc,
                              ),
                            ReceiptTyp.deliveryNote => state.selectedReceipts.isEmpty ||
                                    !state.selectedReceipts.every((e) => e.receiptCustomer.id == state.selectedReceipts.first.id)
                                ? _ReceiptsAlertDialog(
                                    title: 'Achtug',
                                    content: _getErrorMessageOnGenerateFromDeliveryNotesNewInvoice(state.selectedReceipts),
                                  )
                                : _GenerateFromDeliveryNotesNewInvoiceDialog(
                                    appointmentBloc: appointmentBloc,
                                    listOfReceipts: state.selectedReceipts,
                                  ),
                            ReceiptTyp.invoice => state.selectedReceipts.length > 1
                                ? const _ReceiptsAlertDialog(
                                    title: 'Achtug',
                                    content: 'Du darfst maximal eine Rechnung auswählen, zum generieren einer Gutschrift',
                                  )
                                : _GenerateFromInvoiceNewCreditDialog(listOfReceipts: state.selectedReceipts, appointmentBloc: appointmentBloc),
                            _ => const Dialog(),
                          },
                        ),
                      ),
                      icon: const Icon(Icons.send, color: CustomColors.primaryColor),
                    ),
                  ),
                  IconButton(
                      onPressed: () => context.read<AppointmentBloc>().add(GetReceiptsEvent(tabValue: state.tabValue, receiptTyp: receiptTyp)),
                      icon: const Icon(Icons.refresh)),
                  IconButton(
                    onPressed: () {
                      customerBloc.add(GetAllCustomersEvenet());
                      showDialog(
                        context: context,
                        builder: (_) => BlocProvider.value(
                          value: customerBloc,
                          child: _SelectCustomerDialog(
                            appointmentBloc: appointmentBloc,
                            customerBloc: customerBloc,
                            marketplaceBloc: marketplaceBloc,
                            receiptTyp: receiptTyp,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add, color: Colors.green),
                  ),
                  IconButton(
                    onPressed: state.selectedReceipts.isEmpty
                        ? () => showMyDialogAlert(
                            context: context,
                            title: 'Achtung!',
                            content: 'Bitte wähle mindestens ${switch (receiptTyp) {
                              ReceiptTyp.offer => 'ein Angebot',
                              ReceiptTyp.appointment => 'einen Auftrag',
                              ReceiptTyp.deliveryNote => 'einen Lieferschein',
                              ReceiptTyp.invoice => 'eine Rechnungen',
                              ReceiptTyp.credit => 'eine Rechnungen',
                            }} aus.')
                        : () => showMyDialogDelete(
                              context: context,
                              content: 'Bist du sicher, dass du alle ausgewählten ${switch (receiptTyp) {
                                ReceiptTyp.offer => 'Angebote',
                                ReceiptTyp.appointment => 'Aufträge',
                                ReceiptTyp.deliveryNote => 'Lieferscheine',
                                ReceiptTyp.invoice => 'Rechnungen',
                                ReceiptTyp.credit => 'Rechnungen',
                              }} unwiederruflich löschen willst?',
                              onConfirm: () {
                                context.read<AppointmentBloc>().add(
                                      DeleteSelectedReceiptsEvent(selectedReceipts: state.selectedReceipts),
                                    );
                                context.router.pop();
                              },
                            ),
                    icon: state.isLoadingReceiptOnDelete
                        ? const MyCircularProgressIndicator(color: Colors.red)
                        : const Icon(Icons.delete, color: Colors.red),
                  ),
                  if (receiptTyp == ReceiptTyp.appointment) ...[
                    if (marketplaceBloc.state.listOfMarketplace != null && marketplaceBloc.state.listOfMarketplace!.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (_) => _SelectToLoadAppointmentFromMarketplaceSheet(
                              appointmentBloc: appointmentBloc,
                              listOfMarketplaces: marketplaceBloc.state.listOfMarketplace!,
                            ),
                          );
                        },
                        icon: state.isLoadingAppointmentsFromPrestaOnObserve ? const MyCircularProgressIndicator() : const Icon(Icons.downloading),
                      ),
                    IconButton(
                      onPressed: () {
                        context.read<AppointmentBloc>().add(GetNewAppointmentsFromPrestaEvent());
                        showDialog(
                          context: context,
                          builder: (context) => BlocProvider.value(
                            value: appointmentBloc,
                            child: _MyLoadingDialogOnLoadingAppointments(appointmentBloc: appointmentBloc),
                          ),
                        );
                      },
                      icon: state.isLoadingAppointmentsFromPrestaOnObserve ? const MyCircularProgressIndicator() : const Icon(Icons.download),
                    ),
                  ],
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
                  switch (receiptTyp) {
                    ReceiptTyp.offer => DefaultTabController(
                        length: 2,
                        child: TabBar(
                          tabs: const [Tab(text: 'Offen'), Tab(text: 'Alle')],
                          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                          unselectedLabelStyle: const TextStyle(),
                          onTap: (value) => appointmentBloc.add(GetReceiptsEvent(tabValue: value, receiptTyp: receiptTyp)),
                        ),
                      ),
                    ReceiptTyp.appointment => DefaultTabController(
                        length: 2,
                        child: TabBar(
                          tabs: const [Tab(text: 'Offen'), Tab(text: 'Alle')],
                          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                          unselectedLabelStyle: const TextStyle(),
                          onTap: (value) => appointmentBloc.add(GetReceiptsEvent(tabValue: value, receiptTyp: receiptTyp)),
                        ),
                      ),
                    ReceiptTyp.deliveryNote => DefaultTabController(
                        length: 2,
                        child: TabBar(
                          tabs: const [Tab(text: 'Ohne Rechnung'), Tab(text: 'Alle')],
                          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                          unselectedLabelStyle: const TextStyle(),
                          onTap: (value) => appointmentBloc.add(GetReceiptsEvent(tabValue: value, receiptTyp: receiptTyp)),
                        ),
                      ),
                    ReceiptTyp.invoice => DefaultTabController(
                        length: 2,
                        child: TabBar(
                          tabs: const [Tab(text: 'Nicht vollst. bezahlt'), Tab(text: 'Alle')],
                          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                          unselectedLabelStyle: const TextStyle(),
                          onTap: (value) => appointmentBloc.add(GetReceiptsEvent(tabValue: value, receiptTyp: receiptTyp)),
                        ),
                      ),
                    ReceiptTyp.credit => DefaultTabController(
                        length: 2,
                        child: TabBar(
                          tabs: const [Tab(text: 'Nicht vollst. bezahlt'), Tab(text: 'Alle')],
                          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                          unselectedLabelStyle: const TextStyle(),
                          onTap: (value) => appointmentBloc.add(GetReceiptsEvent(tabValue: value, receiptTyp: receiptTyp)),
                        ),
                      ),
                  },
                  ReceiptsOverviewPage(appointmentBloc: appointmentBloc, marketplaceBloc: marketplaceBloc, receiptTyp: receiptTyp),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _textOnSuccessfulDelete(ReceiptTyp receiptTyp) {
    return switch (receiptTyp) {
      ReceiptTyp.offer => 'Angebot / Angebote erfolgreich gelöscht',
      ReceiptTyp.appointment => 'Autrag / Aufträge erfolgreich gelöscht',
      ReceiptTyp.deliveryNote => 'Lieferschein / Lieferscheine erfolgreich gelöscht',
      ReceiptTyp.invoice => 'Rechnung / Rechnungen erfolgreich gelöscht',
      ReceiptTyp.credit => 'Rechnung / Rechnungen erfolgreich gelöscht',
    };
  }

  String _getErrorMessageOnGenerateFromDeliveryNotesNewInvoice(List<Receipt> selectedReceipts) {
    if (selectedReceipts.isEmpty) return 'Du musst mindestens ein Lieferschein auswählen, zum generieren einer Sammelrechnung';
    if (!selectedReceipts.every((e) => e.receiptCustomer.id == selectedReceipts.first.id)) {
      return 'Alle Lieferscheine die zu einer Sammelrechnung generiert werden sollen, müssen vom selben Kunden sein.';
    }
    return 'Ein Fehler ist aufgetreten';
  }
}

class _GenerateFromOfferNewAppointmentDialog extends StatefulWidget {
  final AppointmentBloc appointmentBloc;
  final List<Receipt> listOfReceipts;

  const _GenerateFromOfferNewAppointmentDialog({required this.appointmentBloc, required this.listOfReceipts});

  @override
  State<_GenerateFromOfferNewAppointmentDialog> createState() => _GenerateFromOfferNewAppointmentDialogState();
}

class _GenerateFromOfferNewAppointmentDialogState extends State<_GenerateFromOfferNewAppointmentDialog> {
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
                  const Text('Generiert Aufträge aus den ausgewählten Angeboten.', style: TextStyles.h3Bold),
                  Gaps.h54,
                  Align(
                    alignment: Alignment.centerRight,
                    child: MyOutlinedButton(
                      buttonText: 'Anlegen',
                      buttonBackgroundColor: Colors.green,
                      isLoading: state.isLoadingReceiptOnGenerate,
                      onPressed: () => widget.appointmentBloc.add(OnGenerateFromOfferNewAppointmentEvent()),
                    ),
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

class _GenerateFromAppointmentDialog extends StatefulWidget {
  final AppointmentBloc appointmentBloc;
  final List<Receipt> listOfReceipts;

  const _GenerateFromAppointmentDialog({super.key, required this.appointmentBloc, required this.listOfReceipts});

  @override
  State<_GenerateFromAppointmentDialog> createState() => __GenerateFromAppointmentDialogState();
}

class __GenerateFromAppointmentDialogState extends State<_GenerateFromAppointmentDialog> {
  bool _generateDeliveryNote = true;
  bool _printDeliveryNote = false;
  bool _generateInvoice = true;
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
                          Switch.adaptive(value: _generateDeliveryNote, onChanged: (value) => setState(() => _generateDeliveryNote = value)),
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
                          Switch.adaptive(value: _generateInvoice, onChanged: (value) => setState(() => _generateInvoice = value)),
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
                    child: MyOutlinedButton(
                      buttonText: 'Anlegen',
                      buttonBackgroundColor: Colors.green,
                      isLoading: state.isLoadingReceiptOnGenerate,
                      onPressed: () => widget.appointmentBloc.add(OnGenerateFromAppointmentEvent(
                        generateDeliveryNote: _generateDeliveryNote,
                        generateInvoice: _generateInvoice,
                      )),
                    ),
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

class _GenerateFromInvoiceNewCreditDialog extends StatefulWidget {
  final AppointmentBloc appointmentBloc;
  final List<Receipt> listOfReceipts;

  const _GenerateFromInvoiceNewCreditDialog({required this.appointmentBloc, required this.listOfReceipts});

  @override
  State<_GenerateFromInvoiceNewCreditDialog> createState() => _GenerateFromInvoiceNewCreditDialogState();
}

class _GenerateFromInvoiceNewCreditDialogState extends State<_GenerateFromInvoiceNewCreditDialog> {
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
                  const Text('Generiert eine Gutschrift aus der ausgewählten Rechnung.', style: TextStyles.h3Bold),
                  Gaps.h54,
                  Align(
                    alignment: Alignment.centerRight,
                    child: MyOutlinedButton(
                      buttonText: 'Anlegen',
                      buttonBackgroundColor: Colors.green,
                      isLoading: state.isLoadingReceiptOnGenerate,
                      onPressed: () => widget.appointmentBloc.add(OnGenerateFromInvoiceNewCreditEvent()),
                    ),
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

class _GenerateFromDeliveryNotesNewInvoiceDialog extends StatefulWidget {
  final AppointmentBloc appointmentBloc;
  final List<Receipt> listOfReceipts;

  const _GenerateFromDeliveryNotesNewInvoiceDialog({required this.appointmentBloc, required this.listOfReceipts});

  @override
  State<_GenerateFromDeliveryNotesNewInvoiceDialog> createState() => _GenerateFromDeliveryNotesNewInvoiceDialogState();
}

class _GenerateFromDeliveryNotesNewInvoiceDialogState extends State<_GenerateFromDeliveryNotesNewInvoiceDialog> {
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
                  const Text('Generiert eine Sammelrechnung aus den ausgewählten Lieferscheinen.', style: TextStyles.h3Bold),
                  Gaps.h54,
                  Align(
                    alignment: Alignment.centerRight,
                    child: MyOutlinedButton(
                      buttonText: 'Anlegen',
                      buttonBackgroundColor: Colors.green,
                      isLoading: state.isLoadingReceiptOnGenerate,
                      onPressed: () => widget.appointmentBloc.add(OnGenerateFromDeliveryNotesNewInvoiceEvent()),
                    ),
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

class _ReceiptsAlertDialog extends StatelessWidget {
  final String title;
  final String content;

  const _ReceiptsAlertDialog({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 400,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: TextStyles.h1),
              Gaps.h16,
              Text(content, style: TextStyles.h3, textAlign: TextAlign.center),
              Gaps.h32,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [MyOutlinedButton(buttonText: 'OK', onPressed: () => context.router.pop())],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectCustomerDialog extends StatefulWidget {
  final AppointmentBloc appointmentBloc;
  final CustomerBloc customerBloc;
  final MarketplaceBloc marketplaceBloc;
  final ReceiptTyp receiptTyp;

  const _SelectCustomerDialog({required this.appointmentBloc, required this.customerBloc, required this.marketplaceBloc, required this.receiptTyp});

  @override
  State<_SelectCustomerDialog> createState() => _SelectCustomerDialogState();
}

class _SelectCustomerDialogState extends State<_SelectCustomerDialog> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    return BlocBuilder<CustomerBloc, CustomerState>(
      bloc: widget.customerBloc,
      builder: (context, state) {
        if (state.listOfAllCustomers == null) widget.customerBloc.add(GetAllCustomersEvenet());

        if (state.firebaseFailure != null && state.isAnyFailure) {
          return Dialog(child: SizedBox(width: 600, height: 1200, child: Center(child: Text(state.firebaseFailure.toString()))));
        }
        if (state.isLoadingCustomersOnObserve || state.listOfAllCustomers == null) {
          return const Dialog(child: SizedBox(width: 600, height: 1200, child: Center(child: CircularProgressIndicator())));
        }

        List<Customer> customerList = state.listOfAllCustomers!;

        if (_controller.text.isNotEmpty) {
          String searchText = _controller.text.toLowerCase();
          customerList = customerList
              .where((e) =>
                  e.name.toLowerCase().contains(searchText) ||
                  e.email.toLowerCase().contains(searchText) ||
                  e.listOfAddress.any((address) => address.companyName.toLowerCase().contains(searchText)))
              .toList();
        }

        return Dialog(
          child: SizedBox(
            height: screenHeight > 1200 ? 1200 : screenHeight,
            width: screenWidth > 600 ? 600 : screenWidth,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CupertinoSearchTextField(
                        controller: _controller,
                        onChanged: (value) => setState(() {}),
                        onSuffixTap: () => setState(() => _controller.clear()),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: customerList.length,
                    itemBuilder: ((context, index) {
                      final customer = customerList[index];
                      return Column(
                        children: [
                          if (index == 0) Gaps.h10,
                          ListTile(
                            title: Text(customer.name, style: TextStyles.defaultt),
                            subtitle: customer.company != null ? Text(customer.company!) : null,
                            onTap: () {
                              _controller.clear();
                              context.router.pop();
                              final newAppointment = Receipt.empty().copyWith(
                                customerId: customer.id,
                                receiptCustomer: ReceiptCustomer.fromCustomer(customer),
                                addressInvoice: customer.listOfAddress.where((e) => e.addressType == AddressType.invoice && e.isDefault).first,
                                addressDelivery: customer.listOfAddress.where((e) => e.addressType == AddressType.delivery && e.isDefault).first,
                                tax: customer.tax,
                                listOfReceiptProduct: [ReceiptProduct.empty()],
                                receiptTyp: widget.receiptTyp,
                              );
                              widget.appointmentBloc.add(SetAppointmentEvent(appointment: newAppointment));
                              context.router.push(
                                AppointmentDetailRoute(
                                  appointmentBloc: widget.appointmentBloc,
                                  listOfMarketplaces: widget.marketplaceBloc.state.listOfMarketplace!,
                                  receiptCreateOrEdit: ReceiptCreateOrEdit.create,
                                  receiptTyp: widget.receiptTyp,
                                ),
                              );
                            },
                          ),
                          const Divider(height: 0),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MyLoadingDialogOnLoadingAppointments extends StatelessWidget {
  final AppointmentBloc appointmentBloc;

  const _MyLoadingDialogOnLoadingAppointments({required this.appointmentBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      bloc: appointmentBloc,
      builder: (context, state) {
        return Dialog(
          child: SizedBox(
            width: 250,
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  Gaps.h24,
                  Text('${state.loadedAppointments} / ${state.numberOfToLoadAppointments}', style: TextStyles.h2Bold),
                  Gaps.h24,
                  Text(state.loadingText, textAlign: TextAlign.center, style: TextStyles.h3),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SelectToLoadAppointmentFromMarketplaceSheet extends StatefulWidget {
  final AppointmentBloc appointmentBloc;
  final List<Marketplace> listOfMarketplaces;

  const _SelectToLoadAppointmentFromMarketplaceSheet({super.key, required this.appointmentBloc, required this.listOfMarketplaces});

  @override
  State<_SelectToLoadAppointmentFromMarketplaceSheet> createState() => _SelectToLoadAppointmentFromMarketplaceSheetState();
}

class _SelectToLoadAppointmentFromMarketplaceSheetState extends State<_SelectToLoadAppointmentFromMarketplaceSheet> {
  List<Marketplace> listOfMarketplaces = [];
  Marketplace selectedMarketplace = Marketplace.empty();
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    listOfMarketplaces = widget.listOfMarketplaces..insert(0, Marketplace.empty());
  }

  @override
  Widget build(BuildContext context) {
    final items = listOfMarketplaces.map((e) => e.name).toList();
    print(selectedMarketplace);

    return MyModalScrollable(
      title: 'Bestellung Laden',
      keyboardDismiss: KeyboardDissmiss.onTab,
      children: [
        Gaps.h24,
        MyDropdownButtonFormField(
          labelText: 'Marktplatz wählen',
          value: selectedMarketplace.name,
          onChanged: (marketplaceName) => setState(() => selectedMarketplace = listOfMarketplaces.where((e) => e.name == marketplaceName!).first),
          items: items,
        ),
        Gaps.h24,
        MyTextFormFieldSmall(
          labelText: 'ID aus Marktplatz',
          controller: _controller,
          keyboardType: TextInputType.number,
        ),
        Gaps.h24,
        MyOutlinedButton(
          buttonText: 'Bestellung Laden',
          onPressed: () {
            context.router.popTop();
            widget.appointmentBloc.add(GetNewAppointmentByIdFromPrestaEvent(id: _controller.text.toMyInt(), marketplace: selectedMarketplace));
            showDialog(
              context: context,
              builder: (context) => BlocProvider.value(
                value: widget.appointmentBloc,
                child: _MyLoadingDialogOnLoadingAppointments(appointmentBloc: widget.appointmentBloc),
              ),
            );
          },
        ),
        Gaps.h42,
      ],
    );
  }
}
