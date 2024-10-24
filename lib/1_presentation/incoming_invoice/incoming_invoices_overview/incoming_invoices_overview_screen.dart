import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../2_application/database/incoming_invoice/incoming_invoice_bloc.dart';
import '../../../injection.dart';
import '../../../routes/router.gr.dart';
import '../../app_drawer.dart';
import '../../core/core.dart';
import '../incoming_invoice_detail/incoming_invoice_detail_screen.dart';
import 'incoming_invoices_overview_page.dart';
import 'widgets/incoming_invoices_app_bar_title.dart';

@RoutePage()
class IncomingInvoicesOverviewScreen extends StatefulWidget {
  const IncomingInvoicesOverviewScreen({super.key});

  @override
  State<IncomingInvoicesOverviewScreen> createState() => _IncomingInvoicesOverviewScreenState();
}

class _IncomingInvoicesOverviewScreenState extends State<IncomingInvoicesOverviewScreen> with AutomaticKeepAliveClientMixin {
  final incomingInvoiceBloc = sl<IncomingInvoiceBloc>()..add(GetIncomingInvoicesEvent(calcCount: true, currentPage: 1));

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider.value(
      value: incomingInvoiceBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<IncomingInvoiceBloc, IncomingInvoiceState>(
            listenWhen: (p, c) => p.fosInvoicesOnObserveOption != c.fosInvoicesOnObserveOption,
            listener: (context, state) {
              state.fosInvoicesOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (listOfProducts) => null,
                ),
              );
            },
          ),
        ],
        child: BlocBuilder<IncomingInvoiceBloc, IncomingInvoiceState>(
          builder: (context, state) {
            return Scaffold(
              drawer: const AppDrawer(),
              appBar: AppBar(
                  title: IncomingInvoicesAppBarTitle(listOfInvoices: state.listOfInvoices, selectedInvoices: state.selectedInvoices),
                  actions: [
                    IconButton(
                      onPressed: () => incomingInvoiceBloc.add(GetIncomingInvoicesEvent(calcCount: false, currentPage: state.currentPage)),
                      icon: const Icon(Icons.refresh),
                    ),
                    IconButton(
                      onPressed: () async {
                        final supplier = await showSelectSupplierSheet(context);
                        if (supplier != null && context.mounted) {
                          await context.router.push(IncomingInvoiceDetailRoute(
                            type: IncomingInvoiceAddEditType.create,
                            supplier: supplier,
                            incomingInvoiceId: null,
                          ));
                          incomingInvoiceBloc.add(GetIncomingInvoicesEvent(calcCount: true, currentPage: state.currentPage));
                        }
                      },
                      icon: const Icon(Icons.add, color: Colors.green),
                    ),
                  ]),
              body: SafeArea(
                child: Column(
                  children: [
                    if (ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET))
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: CupertinoSearchTextField(
                          controller: state.searchController,
                          onChanged: (value) => incomingInvoiceBloc.add(GetIncomingInvoicesEvent(calcCount: false, currentPage: 1)),
                          onSuffixTap: () => incomingInvoiceBloc.add(OnInvoiceSearchControllerClearedEvent()),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.only(right: 20, bottom: 10, top: 10),
                        child: Row(
                          children: [
                            Checkbox.adaptive(
                              value: state.isAllInvoicesSelected,
                              onChanged: (value) => incomingInvoiceBloc.add(OnSelectAllInvoicesEvent(isSelected: value!)),
                            ),
                            Expanded(
                              child: CupertinoSearchTextField(
                                controller: state.searchController,
                                onChanged: (value) => incomingInvoiceBloc.add(GetIncomingInvoicesEvent(calcCount: false, currentPage: 1)),
                                onSuffixTap: () => incomingInvoiceBloc.add(OnInvoiceSearchControllerClearedEvent()),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const Divider(height: 0),
                    IncomingInvoicesOverviewPage(incomingInvoiceBloc: incomingInvoiceBloc),
                    const Divider(height: 0),
                    PagesPaginationBar(
                      currentPage: state.currentPage,
                      totalPages: (state.totalQuantity / state.perPageQuantity).ceil(),
                      itemsPerPage: state.perPageQuantity,
                      totalItems: state.totalQuantity,
                      onPageChanged: (newPage) => incomingInvoiceBloc.add(GetIncomingInvoicesEvent(calcCount: false, currentPage: newPage)),
                      onItemsPerPageChanged: (newValue) => incomingInvoiceBloc.add(ItemsPerPageChangedEvent(value: newValue)),
                    ),
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
}
