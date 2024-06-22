import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/app_drawer.dart';
import 'package:cezeri_commerce/routes/router.gr.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/database/customer/customer_bloc.dart';
import '../../../../injection.dart';
import '../../../core/core.dart';
import 'customers_overview_page.dart';

@RoutePage()
class CustomersOverviewScreen extends StatefulWidget {
  const CustomersOverviewScreen({super.key});

  @override
  State<CustomersOverviewScreen> createState() => _CustomersOverviewScreenState();
}

class _CustomersOverviewScreenState extends State<CustomersOverviewScreen> with AutomaticKeepAliveClientMixin {
  final customerBloc = sl<CustomerBloc>();

  @override
  void initState() {
    super.initState();

    customerBloc.add(GetCustomersPerPageEvent(calcCount: true, currentPage: 1));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider.value(
      value: customerBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<CustomerBloc, CustomerState>(
            listenWhen: (p, c) => p.fosCustomersOnObserveOption != c.fosCustomersOnObserveOption,
            listener: (context, state) {
              state.fosCustomersOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (listOfProducts) => null,
                ),
              );
            },
          ),
          BlocListener<CustomerBloc, CustomerState>(
            listenWhen: (p, c) => p.fosCustomersOnDeleteOption != c.fosCustomersOnDeleteOption,
            listener: (context, state) {
              state.fosCustomersOnDeleteOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, failure),
                  (customer) {
                    customerBloc.add(GetCustomersPerPageEvent(calcCount: true, currentPage: 1));
                    myScaffoldMessenger(context, null, null, 'Ausgewählte Kunden erfolgreich gelöscht', null);
                  },
                ),
              );
            },
          ),
        ],
        child: BlocBuilder<CustomerBloc, CustomerState>(
          builder: (context, state) {
            return Scaffold(
              drawer: const AppDrawer(),
              appBar: AppBar(
                title: const Text('Kunden'),
                actions: [
                  IconButton(onPressed: () => context.read<CustomerBloc>().add(GetAllCustomersEvent()), icon: const Icon(Icons.refresh)),
                  IconButton(
                    onPressed: () => context.router.push(CustomerDetailRoute(customerId: null)),
                    icon: const Icon(Icons.add, color: Colors.green),
                  ),
                  IconButton(
                    onPressed: state.selectedCustomers.isEmpty
                        ? () => showMyDialogAlert(context: context, title: 'Achtung!', content: 'Bitte wähle mindestens einen Kunden aus.')
                        : () => showMyDialogDelete(
                              context: context,
                              content: 'Bist du sicher, dass du alle ausgewählten Kunden unwiederruflich löschen willst?',
                              onConfirm: () {
                                context.read<CustomerBloc>().add(DeleteSelectedCustomersEvent(selectedCustomers: state.selectedCustomers));
                                context.router.pop();
                              },
                            ),
                    icon: state.isLoadingCustomerOnDelete
                        ? const MyCircularProgressIndicator(color: Colors.red)
                        : const Icon(Icons.delete, color: Colors.red),
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
                            value: state.isAllCustomersSelected,
                            onChanged: (value) => customerBloc.add(OnSelectAllCustomersEvent(isSelected: value!)),
                          ),
                          Expanded(
                            child: CupertinoSearchTextField(
                              controller: state.customerSearchController,
                              onSubmitted: (value) => customerBloc.add(GetCustomersPerPageEvent(calcCount: true, currentPage: 1)),
                              onSuffixTap: () => customerBloc.add(CustomerSearchFieldClearedEvent()),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 0),
                    CustomersOverviewPage(customerBloc: customerBloc),
                    if (state.totalQuantity > 0) ...[
                      const Divider(height: 0),
                      PagesPaginationBar(
                        currentPage: state.currentPage,
                        totalPages: (state.totalQuantity / state.perPageQuantity).ceil(),
                        itemsPerPage: state.perPageQuantity,
                        totalItems: state.totalQuantity,
                        onPageChanged: (newPage) => customerBloc.add(GetCustomersPerPageEvent(calcCount: false, currentPage: newPage)),
                        onItemsPerPageChanged: (newValue) => customerBloc.add(CustomerItemsPerPageChangedEvent(value: newValue)),
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
}
