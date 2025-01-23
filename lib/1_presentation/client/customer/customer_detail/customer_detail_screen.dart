import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/database/customer_detail/customer_detail_bloc.dart';
import '../../../../injection.dart';
import '../../../core/core.dart';
import 'customer_detail_page.dart';

enum CustomerCreateOrEdit { create, edit }

@RoutePage()
class CustomerDetailScreen extends StatefulWidget {
  final String? customerId;

  const CustomerDetailScreen({super.key, @PathParam('customerId') required this.customerId});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> with AutomaticKeepAliveClientMixin {
  final customerDetailBloc = sl<CustomerDetailBloc>();

  @override
  void initState() {
    super.initState();

    if (widget.customerId == null) {
      customerDetailBloc.add(CustomerDetailSetEmptyCustomerEvent());
    } else {
      customerDetailBloc.add(CustomerDetailGetCustomerEvent(customerId: widget.customerId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final appBar = AppBar(title: const Text('Kunde'));

    return BlocProvider.value(
      value: customerDetailBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<CustomerDetailBloc, CustomerDetailState>(
            listenWhen: (p, c) => p.fosCustomerDetailOnCreateOption != c.fosCustomerDetailOnCreateOption,
            listener: (context, state) {
              state.fosCustomerDetailOnCreateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (createdCustomer) {
                    context.router.popUntilRouteWithName(CustomersOverviewRoute.name);
                    customerDetailBloc.add(CustomerDetailGetCustomerEvent(customerId: createdCustomer.id));
                    context.router.push(CustomerDetailRoute(customerId: createdCustomer.id));
                  },
                ),
              );
            },
          ),
          BlocListener<CustomerDetailBloc, CustomerDetailState>(
            listenWhen: (p, c) => p.fosCustomerDetailOnUpdateOption != c.fosCustomerDetailOnUpdateOption,
            listener: (context, state) {
              state.fosCustomerDetailOnUpdateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (updatedCustomer) => myScaffoldMessenger(context, null, null, 'Kunde wurde erfolgreich aktualisiert', null),
                ),
              );
            },
          ),
        ],
        child: BlocBuilder<CustomerDetailBloc, CustomerDetailState>(
          builder: (context, state) {
            if (state.isLoadingCustomerDetailOnObserve) return Scaffold(appBar: appBar, body: const Center(child: CircularProgressIndicator()));
            if (state.databaseFailure != null) return Scaffold(appBar: appBar, body: const Center(child: Text('Ein Fehler ist aufgetreten')));
            if (state.customer == null) return Scaffold(appBar: appBar, body: const Center(child: CircularProgressIndicator()));

            return CustomerDetailPage(
              customer: state.customer!,
              customerDetailBloc: customerDetailBloc,
              customerCreateOrEdit: widget.customerId == null ? CustomerCreateOrEdit.create : CustomerCreateOrEdit.edit,
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
