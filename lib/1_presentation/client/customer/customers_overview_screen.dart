import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/app_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/firebase/customer/customer_bloc.dart';
import '../../../injection.dart';
import '../../core/functions/my_scaffold_messanger.dart';
import '../../core/widgets/my_delete_dialog.dart';
import '../../core/widgets/my_info_dialog.dart';
import 'customers_overview_page.dart';

@RoutePage()
class CustomersOverviewScreen extends StatelessWidget {
  const CustomersOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final customerBloc = sl<CustomerBloc>()..add(GetAllCustomersEvenet());

    final searchController = TextEditingController();

    return BlocProvider(
      create: (context) => customerBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<CustomerBloc, CustomerState>(
            listenWhen: (p, c) => p.fosCustomersOnObserveOption != c.fosCustomersOnObserveOption,
            listener: (context, state) {
              state.fosCustomersOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => myScaffoldMessenger(context, failure, null, null, null),
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
                  (failure) => myScaffoldMessenger(context, failure, null, null, null),
                  (customer) => myScaffoldMessenger(context, null, null, 'Ausgewählte Kunden erfolgreich gelöscht', null),
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
                  IconButton(onPressed: () => context.read<CustomerBloc>().add(GetAllCustomersEvenet()), icon: const Icon(Icons.refresh)),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.add, color: Colors.green)),
                  IconButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => state.selecetedCustomers.isEmpty
                          ? const MyInfoDialog(title: 'Achtung!', content: 'Bitte wähle mindestens einen Artikel aus.')
                          : MyDeleteDialog(
                              content: 'Bist du sicher, dass du alle ausgewählten Artikel unwiederruflich löschen willst?',
                              onConfirm: () {
                                context.read<CustomerBloc>().add(DeleteSelectedCustomersEvent(selectedCustomers: state.selecetedCustomers));
                                context.router.pop();
                              },
                            ),
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
}
