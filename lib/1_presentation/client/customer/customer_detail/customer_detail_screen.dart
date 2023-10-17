import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/firebase/customer/customer_bloc.dart';
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

    return BlocBuilder<CustomerBloc, CustomerState>(
      bloc: customerBloc,
      builder: (context, state) {
        if (state.isLoadingCustomerOnObserve) return Scaffold(appBar: appBar, body: const Center(child: CircularProgressIndicator()));
        if ((state.firebaseFailure != null && state.isAnyFailure) || (customerCreateOrEdit == CustomerCreateOrEdit.edit && state.customer == null)) {
          return Scaffold(appBar: appBar, body: const Center(child: Text('Ein Fehler ist aufgetreten')));
        }
        customerBloc.add(SetCustomerControllerEvnet());

        return CustomerDetailPage(customer: state.customer, customerBloc: customerBloc, customerCreateOrEdit: customerCreateOrEdit);
      },
    );
  }
}
