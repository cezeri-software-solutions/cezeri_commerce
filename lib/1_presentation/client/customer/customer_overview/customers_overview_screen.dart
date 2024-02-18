import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/app_drawer.dart';
import 'package:cezeri_commerce/1_presentation/core/widgets/my_circular_progress_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/firebase/customer/customer_bloc.dart';
import '../../../../injection.dart';
import '../../../../routes/router.gr.dart';
import '../../../core/functions/dialogs.dart';
import '../../../core/functions/my_scaffold_messanger.dart';
import '../../../core/renderer/failure_renderer.dart';
import '../customer_detail/customer_detail_screen.dart';
import 'customers_overview_page.dart';

@RoutePage()
class CustomersOverviewScreen extends StatefulWidget {
  const CustomersOverviewScreen({super.key});

  @override
  State<CustomersOverviewScreen> createState() => _CustomersOverviewScreenState();
}

class _CustomersOverviewScreenState extends State<CustomersOverviewScreen> with AutomaticKeepAliveClientMixin {
  final customerBloc = sl<CustomerBloc>()..add(GetAllCustomersEvent());

  final searchController = TextEditingController();

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
                  (listOfProducts) => myScaffoldMessenger(context, null, null, 'Kunden wurden erfolgreich geladen', null),
                ),
              );
            },
          ),
          BlocListener<CustomerBloc, CustomerState>(
            listenWhen: (p, c) => p.fosCustomerOnDeleteOption != c.fosCustomerOnDeleteOption,
            listener: (context, state) {
              state.fosCustomerOnDeleteOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (customer) => myScaffoldMessenger(context, null, null, 'Ausgewählte Kunden erfolgreich gelöscht', null),
                ),
              );
            },
          ),
          BlocListener<CustomerBloc, CustomerState>(
            listenWhen: (p, c) => p.fosCustomerMainSettingsOnObserveOption != c.fosCustomerMainSettingsOnObserveOption,
            listener: (context, state) {
              state.fosCustomerMainSettingsOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (customer) =>
                      context.router.push(CustomerDetailRoute(customerBloc: customerBloc, customerCreateOrEdit: CustomerCreateOrEdit.create)),
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
                    onPressed: () => customerBloc.add(SetEmptyCustomerOnCreateNewCustomerEvent()),
                    icon: state.isLoadingCustomerMainSettingsOnObserve
                        ? const MyCircularProgressIndicator()
                        : const Icon(Icons.add, color: Colors.green),
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
                        ? const CircularProgressIndicator(color: Colors.red)
                        : const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: CupertinoSearchTextField(
                      controller: searchController,
                      onChanged: (value) => context.read<CustomerBloc>().add(SetSearchFieldTextEvent(searchText: value)),
                      onSubmitted: (value) => context.read<CustomerBloc>().add(OnSearchFieldSubmittedEvent()),
                      onSuffixTap: () {
                        searchController.clear();
                        context.read<CustomerBloc>().add(SetSearchFieldTextEvent(searchText: ''));
                        context.read<CustomerBloc>().add(OnSearchFieldSubmittedEvent());
                      },
                    ),
                  ),
                  CustomersOverviewPage(customerBloc: customerBloc),
                ],
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
