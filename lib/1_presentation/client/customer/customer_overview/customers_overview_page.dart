import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/3_domain/entities/address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../2_application/database/customer/customer_bloc.dart';
import '../../../../3_domain/entities/customer/customer.dart';
import '../../../../constants.dart';
import '../../../../routes/router.gr.dart';
import '../../../core/core.dart';

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
          return const Expanded(child: Center(child: Text('Ein Fehler beim Laden der Kunden ist aufgetreten!')));
        }
        if (state.listOfAllCustomers == null || state.listOfFilteredCustomers == null) {
          return const Expanded(child: Center(child: CircularProgressIndicator()));
        }
        if (state.listOfAllCustomers == null || state.listOfFilteredCustomers == null) {
          return const Expanded(child: Center(child: Text('Du hast noch keine Kunden angelegt oder importiert!')));
        }

        return Expanded(
          child: Scrollbar(
            child: ListView.separated(
              itemCount: state.listOfFilteredCustomers!.length,
              separatorBuilder: (context, index) => const Divider(indent: 45, endIndent: 20),
              itemBuilder: (context, index) {
                return _CustomerContainer(customer: state.listOfFilteredCustomers![index], index: index, customerBloc: customerBloc);
              },
            ),
          ),
        );
      },
    );
  }
}

class _CustomerContainer extends StatelessWidget {
  final Customer customer;
  final int index;
  final CustomerBloc customerBloc;

  const _CustomerContainer({required this.customer, required this.index, required this.customerBloc});

  @override
  Widget build(BuildContext context) {
    Address? invoiceAddress = customer.listOfAddress.where((e) => e.addressType == AddressType.invoice && e.isDefault).firstOrNull;
    invoiceAddress ??= Address.empty();
    Address? deliveryAddress = customer.listOfAddress.where((e) => e.addressType == AddressType.delivery && e.isDefault).firstOrNull;
    deliveryAddress ??= Address.empty();

    return BlocBuilder<CustomerBloc, CustomerState>(
      bloc: customerBloc,
      builder: (context, state) {
        return Column(
          children: [
            if(index == 0) Gaps.h10,
            Row(
              children: [
                Checkbox.adaptive(
                  value: state.selectedCustomers.any((e) => e.id == customer.id),
                  onChanged: (_) => customerBloc.add(OnCustomerSelectedEvent(customer: customer)),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => context.router.push(CustomerDetailRoute(customerId: customer.id)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(customer.customerNumber.toString()),
                        if (invoiceAddress!.companyName != '') Text(invoiceAddress.companyName),
                        Text(customer.name),
                        Text(DateFormat('dd.MM.yyy', 'de').format(customer.creationDate)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(invoiceAddress.street),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: invoiceAddress.postcode),
                            const TextSpan(text: ' '),
                            TextSpan(text: invoiceAddress.city),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text(invoiceAddress.country.name),
                          Gaps.w8,
                          MyCountryFlag(country: invoiceAddress.country, size: 12),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
