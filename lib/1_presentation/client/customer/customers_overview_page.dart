import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/firebase/customer/customer_bloc.dart';
import '../../../core/firebase_failures.dart';

class CustomersOverviewPage extends StatelessWidget {
  final CustomerBloc customerBloc;

  const CustomersOverviewPage({super.key, required this.customerBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerBloc, CustomerState>(
      builder: (context, state) {
        if (state.isLoadingCustomersOnObserve) {
          return const Expanded(child: Center(child: CircularProgressIndicator()));
        }
        if (state.firebaseFailure != null && state.isAnyFailure) {
          return switch (state.firebaseFailure.runtimeType) {
            EmptyFailure => const Expanded(child: Center(child: Text('Du hast noch keine Kunden angelegt oder importiert!'))),
            (_) => const Expanded(child: Center(child: Text('Ein Fehler beim Laden der Kunden ist aufgetreten!')))
          };
        }
        if (state.listOfAllCustomers == null || state.listOfFilteredCustomers == null) {
          return const Expanded(child: Center(child: CircularProgressIndicator()));
        }

        return Expanded(
          child: ListView.builder(
            itemCount: state.listOfFilteredCustomers!.length,
            itemBuilder: (context, index) {
              final customer = state.listOfFilteredCustomers![index];
              return Column(
                children: [
                  ListTile(
                    title: Text(customer.name),
                    subtitle: Text(customer.email),
                  ),
                  const Divider(),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
