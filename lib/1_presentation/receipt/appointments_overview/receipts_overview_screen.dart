import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/app_drawer.dart';
import 'package:cezeri_commerce/3_domain/entities/receipt/receipt_product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/firebase/appointment/appointment_bloc.dart';
import '../../../2_application/firebase/customer/customer_bloc.dart';
import '../../../2_application/firebase/marketplace/marketplace_bloc.dart';
import '../../../3_domain/entities/address.dart';
import '../../../3_domain/entities/customer/customer.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../3_domain/entities/receipt/receipt_customer.dart';
import '../../../constants.dart';
import '../../../injection.dart';
import '../../../routes/router.gr.dart';
import '../../core/functions/my_scaffold_messanger.dart';
import '../../core/widgets/my_delete_dialog.dart';
import '../../core/widgets/my_info_dialog.dart';
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
                    ReceiptTyp.offer => 'Angebote',
                    ReceiptTyp.appointment => 'Aufträge',
                    ReceiptTyp.deliveryNote => 'Lieferscheine',
                    ReceiptTyp.invoice => 'Rechnungen',
                    ReceiptTyp.credit => 'Rechnungen',
                  },
                ),
                actions: [
                  Tooltip(
                    message: 'Senden',
                    child: IconButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (_) => BlocProvider.value(
                          value: appointmentBloc,
                          child: _GenerateDialog(listOfReceipts: state.selectedReceipts, appointmentBloc: appointmentBloc),
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
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add, color: Colors.green),
                  ),
                  IconButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => state.selectedReceipts.isEmpty
                          ? MyInfoDialog(
                              title: 'Achtung!',
                              content: 'Bitte wähle mindestens ${switch (receiptTyp) {
                                ReceiptTyp.offer => 'ein Angebot',
                                ReceiptTyp.appointment => 'einen Auftrag',
                                ReceiptTyp.deliveryNote => 'einen Lieferschein',
                                ReceiptTyp.invoice => 'eine Rechnungen',
                                ReceiptTyp.credit => 'eine Rechnungen',
                              }} aus.')
                          : MyDeleteDialog(
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
                    ),
                    icon: state.isLoadingReceiptOnDelete
                        ? const CircularProgressIndicator(color: Colors.red)
                        : const Icon(Icons.delete, color: Colors.red),
                  ),
                  if (receiptTyp == ReceiptTyp.appointment)
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
                          tabs: const [Tab(text: 'Offen'), Tab(text: 'Alle')],
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
                  ReceiptsOverviewPage(appointmentBloc: appointmentBloc, marketplaceBloc: marketplaceBloc),
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
}

class _GenerateDialog extends StatefulWidget {
  final AppointmentBloc appointmentBloc;
  final List<Receipt> listOfReceipts;

  const _GenerateDialog({required this.appointmentBloc, required this.listOfReceipts});

  @override
  State<_GenerateDialog> createState() => __GenerateDialogState();
}

class __GenerateDialogState extends State<_GenerateDialog> {
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

class _SelectCustomerDialog extends StatefulWidget {
  final AppointmentBloc appointmentBloc;
  final CustomerBloc customerBloc;
  final MarketplaceBloc marketplaceBloc;

  const _SelectCustomerDialog({required this.appointmentBloc, required this.customerBloc, required this.marketplaceBloc});

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
                              );
                              widget.appointmentBloc.add(SetAppointmentEvent(appointment: newAppointment));
                              context.router.push(
                                AppointmentDetailRoute(
                                  appointmentBloc: widget.appointmentBloc,
                                  listOfMarketplaces: widget.marketplaceBloc.state.listOfMarketplace!,
                                  receiptCreateOrEdit: ReceiptCreateOrEdit.create,
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
