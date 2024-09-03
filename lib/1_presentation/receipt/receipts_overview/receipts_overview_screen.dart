import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/app_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/3_domain/entities/marketplace/abstract_marketplace.dart';
import '/3_domain/entities/receipt/receipt.dart';
import '/injection.dart';
import '../../../2_application/database/receipt/receipt_bloc.dart';
import '../../core/core.dart';
import '../functions/pop_until_receipts_overview.dart';
import '../sheets/receipts_overview_filter.dart';
import '../widgets/receipts_overview_options_sheet.dart';
import 'receipts_overview_page.dart';

class ReceiptsOverviewScreen extends StatefulWidget {
  final ReceiptType receiptType;

  const ReceiptsOverviewScreen({super.key, required this.receiptType});

  @override
  State<ReceiptsOverviewScreen> createState() => _ReceiptsOverviewScreenState();
}

class _ReceiptsOverviewScreenState extends State<ReceiptsOverviewScreen> with AutomaticKeepAliveClientMixin {
  final receiptBloc = sl<ReceiptBloc>();

  @override
  void initState() {
    super.initState();

    receiptBloc.add(GetReceiptsPerPageEvent(
      isFirstLoad: true,
      calcCount: true,
      currentPage: 1,
      tabValue: 0,
      receiptType: widget.receiptType,
    ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider.value(
      value: receiptBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<ReceiptBloc, ReceiptState>(
            listenWhen: (p, c) => p.fosReceiptsOnObserveOption != c.fosReceiptsOnObserveOption,
            listener: (context, state) {
              state.fosReceiptsOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (listOfAppointments) => null,
                ),
              );
            },
          ),
          BlocListener<ReceiptBloc, ReceiptState>(
            listenWhen: (p, c) => p.fosAppointmentOnObserveFromMarketplacesOption != c.fosAppointmentOnObserveFromMarketplacesOption,
            listener: (context, state) {
              state.fosAppointmentOnObserveFromMarketplacesOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) async {
                    context.router.maybePopTop();
                    await failureRenderer(context, [failure]);
                    if (context.mounted) myScaffoldMessenger(context, null, null, null, 'Beim Laden der Bestellung ist etwas schief gegangen');
                  },
                  (unit) {
                    context.router.maybePopTop();
                    myScaffoldMessenger(context, null, null, 'Auftrag erfolgreich aus den Marktplätzen geladen', null);
                  },
                ),
              );
            },
          ),
          BlocListener<ReceiptBloc, ReceiptState>(
            listenWhen: (p, c) => p.fosAppointmentsOnObserveFromMarketplacesOption != c.fosAppointmentsOnObserveFromMarketplacesOption,
            listener: (context, state) {
              state.fosAppointmentsOnObserveFromMarketplacesOption.fold(
                () => null,
                (a) => a.fold(
                  (failures) async {
                    context.router.maybePopTop();
                    await failureRenderer(context, failures);
                    if (context.mounted) {
                      myScaffoldMessenger(context, null, null, null, 'Beim Laden von mindestens einer Bestellung ist etwas schief gegangen');
                    }
                  },
                  (unit) {
                    context.router.maybePopTop();
                    receiptBloc.add(
                      GetReceiptsPerPageEvent(isFirstLoad: false, calcCount: true, currentPage: 1, tabValue: 0, receiptType: widget.receiptType),
                    );
                    myScaffoldMessenger(context, null, null, 'Aufträge erfolgreich aus den Marktplätzen geladen', null);
                  },
                ),
              );
            },
          ),
          BlocListener<ReceiptBloc, ReceiptState>(
            listenWhen: (p, c) => p.fosReceiptOnDeleteOption != c.fosReceiptOnDeleteOption,
            listener: (context, state) {
              state.fosReceiptOnDeleteOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) {
                    failureRenderer(context, [failure]);
                    popUntilBase(context, widget.receiptType);
                  },
                  (unit) {
                    myScaffoldMessenger(context, null, null, _textOnSuccessfulDelete(widget.receiptType), null);
                    popUntilBase(context, widget.receiptType);
                  },
                ),
              );
            },
          ),
          BlocListener<ReceiptBloc, ReceiptState>(
            listenWhen: (p, c) => p.fosReceiptOnGenerateOption != c.fosReceiptOnGenerateOption,
            listener: (context, state) {
              state.fosReceiptOnGenerateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) {
                    (failure) => failureRenderer(context, [failure]);
                    context.router.maybePopTop();
                  },
                  (unit) {
                    myScaffoldMessenger(context, null, null, 'Dokument wurde erfolgreich generiert', null);
                    context.router.maybePopTop();
                  },
                ),
              );
            },
          ),
          BlocListener<ReceiptBloc, ReceiptState>(
            listenWhen: (p, c) => p.fosReceiptsOnGenerateOption != c.fosReceiptsOnGenerateOption,
            listener: (context, state) {
              state.fosReceiptsOnGenerateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) {
                    (failure) => failureRenderer(context, [failure]);
                    popUntilBase(context, widget.receiptType);
                  },
                  (unit) {
                    myScaffoldMessenger(context, null, null, 'Dokument/e wurden erfolgreich generiert', null);
                    popUntilBase(context, widget.receiptType);
                  },
                ),
              );
            },
          ),
        ],
        child: BlocBuilder<ReceiptBloc, ReceiptState>(
          builder: (context, state) {
            print(state.currentPage);
            return Scaffold(
              drawer: const AppDrawer(),
              appBar: AppBar(
                title: Text(
                  switch (widget.receiptType) {
                    ReceiptType.offer => state.listOfFilteredReceipts != null ? 'Angebote (${state.listOfFilteredReceipts!.length})' : 'Angebote',
                    ReceiptType.appointment =>
                      state.listOfFilteredReceipts != null ? 'Aufträge (${state.listOfFilteredReceipts!.length})' : 'Aufträge',
                    ReceiptType.deliveryNote =>
                      state.listOfFilteredReceipts != null ? 'Lieferscheine (${state.listOfFilteredReceipts!.length})' : 'Lieferscheine',
                    ReceiptType.invoice ||
                    ReceiptType.credit =>
                      state.listOfFilteredReceipts != null ? 'Rechnungen (${state.listOfFilteredReceipts!.length})' : 'Rechnungen',
                  },
                ),
                actions: [
                  IconButton(
                      onPressed: () => receiptBloc.add(GetReceiptsPerPageEvent(
                            isFirstLoad: false,
                            calcCount: true,
                            currentPage: state.currentPage,
                            tabValue: state.tabValue,
                            receiptType: widget.receiptType,
                          )),
                      icon: const Icon(Icons.refresh)),
                  IconButton(onPressed: () => filterReceiptsOverview(context, receiptBloc), icon: const Icon(Icons.filter_list)),
                  IconButton(
                    onPressed: () => _showMoreOptions(state.selectedReceipts, state.listOfMarketpaces!),
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20, bottom: 10),
                      child: Row(
                        children: [
                          Checkbox.adaptive(
                            value: state.isAllReceiptsSeledcted,
                            onChanged: (value) => receiptBloc.add(OnSelectAllAppointmentsEvent(isSelected: value!)),
                          ),
                          Expanded(
                            child: CupertinoSearchTextField(
                              controller: state.receiptSearchController,
                              onSubmitted: (value) => receiptBloc.add(GetReceiptsPerPageEvent(
                                isFirstLoad: false,
                                calcCount: true,
                                currentPage: 1,
                                tabValue: state.tabValue,
                                receiptType: widget.receiptType,
                              )),
                              onSuffixTap: () => receiptBloc.add(OnSearchFieldClearedEvent()),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _TabBarGenerator(
                      receiptBloc: receiptBloc,
                      receiptType: widget.receiptType,
                      currentPage: state.currentPage,
                      tabValue: state.tabValue,
                    ),
                    ReceiptsOverviewPage(receiptBloc: receiptBloc, receiptTyp: widget.receiptType),
                    if (state.totalQuantity > 0) ...[
                      const Divider(height: 0),
                      PagesPaginationBar(
                        currentPage: state.currentPage,
                        totalPages: (state.totalQuantity / state.perPageQuantity).ceil(),
                        itemsPerPage: state.perPageQuantity,
                        totalItems: state.totalQuantity,
                        onPageChanged: (newPage) => receiptBloc.add(GetReceiptsPerPageEvent(
                          isFirstLoad: false,
                          calcCount: false,
                          currentPage: newPage,
                          tabValue: state.tabValue,
                          receiptType: widget.receiptType,
                        )),
                        onItemsPerPageChanged: (newValue) => receiptBloc.add(ItemsPerPageChangedEvent(value: newValue)),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  String _textOnSuccessfulDelete(ReceiptType receiptTyp) {
    return switch (receiptTyp) {
      ReceiptType.offer => 'Angebot / Angebote erfolgreich gelöscht',
      ReceiptType.appointment => 'Autrag / Aufträge erfolgreich gelöscht',
      ReceiptType.deliveryNote => 'Lieferschein / Lieferscheine erfolgreich gelöscht',
      ReceiptType.invoice || ReceiptType.credit => 'Rechnung / Rechnungen erfolgreich gelöscht',
    };
  }

  void _showMoreOptions(List<Receipt> listOfReceipts, List<AbstractMarketplace> listOfMarketplaces) {
    showReceiptsOverviewOptions(
      context: context,
      receiptBloc: receiptBloc,
      receiptType: widget.receiptType,
      listOfselectedReceipts: listOfReceipts,
      listOfMarketplaces: listOfMarketplaces,
    );
  }
}

class _TabBarGenerator extends StatelessWidget {
  final ReceiptBloc receiptBloc;
  final ReceiptType receiptType;
  final int currentPage;
  final int tabValue;

  const _TabBarGenerator({required this.receiptBloc, required this.receiptType, required this.currentPage, required this.tabValue});

  @override
  Widget build(BuildContext context) {
    return switch (receiptType) {
      ReceiptType.offer => DefaultTabController(
          length: 2,
          child: TabBar(
            tabs: const [Tab(text: 'Offen'), Tab(text: 'Alle')],
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(),
            onTap: (value) => value == tabValue
                ? null
                : receiptBloc.add(GetReceiptsPerPageEvent(
                    isFirstLoad: false,
                    calcCount: true,
                    currentPage: currentPage,
                    tabValue: value,
                    receiptType: receiptType,
                  )),
          ),
        ),
      ReceiptType.appointment => DefaultTabController(
          length: 2,
          child: TabBar(
            tabs: const [Tab(text: 'Offen'), Tab(text: 'Alle')],
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(),
            onTap: (value) => value == tabValue
                ? null
                : receiptBloc.add(GetReceiptsPerPageEvent(
                    isFirstLoad: false,
                    calcCount: true,
                    currentPage: currentPage,
                    tabValue: value,
                    receiptType: receiptType,
                  )),
          ),
        ),
      ReceiptType.deliveryNote => DefaultTabController(
          length: 2,
          child: TabBar(
            tabs: const [Tab(text: 'Ohne Rechnung'), Tab(text: 'Alle')],
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(),
            onTap: (value) => value == tabValue
                ? null
                : receiptBloc.add(GetReceiptsPerPageEvent(
                    isFirstLoad: false,
                    calcCount: true,
                    currentPage: currentPage,
                    tabValue: value,
                    receiptType: receiptType,
                  )),
          ),
        ),
      ReceiptType.invoice || ReceiptType.credit => DefaultTabController(
          length: 2,
          child: TabBar(
            tabs: const [Tab(text: 'Nicht vollst. bezahlt'), Tab(text: 'Alle')],
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(),
            onTap: (value) => value == tabValue
                ? null
                : receiptBloc.add(GetReceiptsPerPageEvent(
                    isFirstLoad: false,
                    calcCount: true,
                    currentPage: currentPage,
                    tabValue: value,
                    receiptType: receiptType,
                  )),
          ),
        ),
    };
  }
}
