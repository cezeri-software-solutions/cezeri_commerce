import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/firebase/customer/customer_bloc.dart';
import '../../../core/functions/my_scaffold_messanger.dart';
import 'customer_detail_page.dart';

enum CustomerCreateOrEdit { create, edit }

@RoutePage()
class CustomerDetailScreen extends StatelessWidget {
  final CustomerBloc customerBloc;
  final CustomerCreateOrEdit customerCreateOrEdit;

  const CustomerDetailScreen({super.key, required this.customerBloc, required this.customerCreateOrEdit});

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(title: const Text('Kunde'));

    return MultiBlocListener(
      listeners: [
        BlocListener<CustomerBloc, CustomerState>(
          bloc: customerBloc,
          listenWhen: (p, c) => p.fosCustomerOnCreateOption != c.fosCustomerOnCreateOption,
          listener: (context, state) {
            state.fosCustomerOnCreateOption.fold(
              () => null,
              (a) => a.fold(
                (failure) => myScaffoldMessenger(context, failure, null, null, null),
                (createdCustomer) {
                  context.router.popUntilRouteWithName(CustomersOverviewRoute.name);
                  customerBloc.add(GetCustomerEvent(customer: createdCustomer));
                  context.router.push(CustomerDetailRoute(customerBloc: customerBloc, customerCreateOrEdit: CustomerCreateOrEdit.edit));
                },
              ),
            );
          },
        ),
        BlocListener<CustomerBloc, CustomerState>(
          bloc: customerBloc,
          listenWhen: (p, c) => p.fosCustomerOnUpdateOption != c.fosCustomerOnUpdateOption,
          listener: (context, state) {
            state.fosCustomerOnUpdateOption.fold(
              () => null,
              (a) => a.fold(
                (failure) => myScaffoldMessenger(context, failure, null, null, null),
                (updatedCustomer) => myScaffoldMessenger(context, null, null, 'Kunde wurde erfolgreich aktualisiert', null),
              ),
            );
          },
        ),
      ],
      child: BlocBuilder<CustomerBloc, CustomerState>(
        bloc: customerBloc,
        builder: (context, state) {
          if (state.isLoadingCustomerOnObserve) return Scaffold(appBar: appBar, body: const Center(child: CircularProgressIndicator()));
          if ((state.firebaseFailure != null && state.isAnyFailure) ||
              (customerCreateOrEdit == CustomerCreateOrEdit.edit && state.customer == null)) {
            return Scaffold(appBar: appBar, body: const Center(child: Text('Ein Fehler ist aufgetreten')));
          }

          return CustomerDetailPage(customer: state.customer, customerBloc: customerBloc, customerCreateOrEdit: customerCreateOrEdit);
        },
      ),
    );
  }
}
