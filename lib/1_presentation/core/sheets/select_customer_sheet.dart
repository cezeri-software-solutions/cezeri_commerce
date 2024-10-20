import 'dart:async';
import 'dart:math';

import 'package:cezeri_commerce/1_presentation/core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../2_application/database/customer/customer_bloc.dart';
import '../../../3_domain/entities/customer/customer.dart';
import '../../../constants.dart';
import '../../../injection.dart';

Future<Customer?> showSelectCustomerSheet(BuildContext context) async {
  final completer = Completer<Customer?>();
  final customerBloc = sl<CustomerBloc>()..add(GetCustomersPerPageEvent(calcCount: true, currentPage: 1));

  WoltModalSheet.show<void>(
    context: context,
    useSafeArea: false,
    showDragHandle: false,
    pageListBuilder: (BuildContext context) {
      return [
        WoltModalSheetPage(
          hasTopBarLayer: true,
          isTopBarLayerAlwaysVisible: true,
          forceMaxHeight: true,
          topBarTitle: const Text('Kunde auswählen', style: TextStyles.h2Bold),
          stickyActionBar: BlocProvider.value(
            value: customerBloc,
            child: BlocBuilder<CustomerBloc, CustomerState>(
              builder: (context, state) {
                return PagesPaginationBar(
                  currentPage: state.currentPage,
                  totalPages: (state.totalQuantity / state.perPageQuantity).ceil(),
                  itemsPerPage: state.perPageQuantity,
                  totalItems: state.totalQuantity,
                  onPageChanged: (newPage) => customerBloc.add(GetCustomersPerPageEvent(calcCount: false, currentPage: newPage)),
                  onItemsPerPageChanged: (newValue) => customerBloc.add(CustomerItemsPerPageChangedEvent(value: newValue)),
                );
              },
            ),
          ),
          child: BlocProvider.value(
            value: customerBloc,
            child: _SelectCustomerSheet(
              onCustomerSelected: (customer) {
                Navigator.of(context).pop();
                completer.complete(customer);
              },
            ),
          ),
        ),
      ];
    },
  );

  return completer.future;
}

class _SelectCustomerSheet extends StatelessWidget {
  final void Function(Customer) onCustomerSelected;

  const _SelectCustomerSheet({required this.onCustomerSelected});

  @override
  Widget build(BuildContext context) {
    final customerBloc = BlocProvider.of<CustomerBloc>(context);

    return BlocBuilder<CustomerBloc, CustomerState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(bottom: max(MediaQuery.paddingOf(context).bottom, 16)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: CupertinoSearchTextField(
                  controller: state.customerSearchController,
                  onChanged: (value) => customerBloc.add(GetCustomersPerPageEvent(calcCount: true, currentPage: 1)),
                  onSuffixTap: () => customerBloc.add(CustomerSearchFieldClearedEvent()),
                ),
              ),
              _CustomerItems(onCustomerSelected: onCustomerSelected),
            ],
          ),
        );
      },
    );
  }
}

class _CustomerItems extends StatelessWidget {
  final void Function(Customer) onCustomerSelected;

  const _CustomerItems({required this.onCustomerSelected});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final height = screenHeight - 300;

    return BlocBuilder<CustomerBloc, CustomerState>(
      builder: (context, state) {
        final onLoadingWidget = SizedBox(height: height, child: const Center(child: MyCircularProgressIndicator()));
        final onErrorWidget = SizedBox(height: height, child: const Center(child: Text('Ein Fehler ist aufgetreten!')));
        final onEmptyWidget = SizedBox(height: height, child: const Center(child: Text('Es konnten keine Artikel gefunden werden.')));

        if (state.isLoadingCustomersOnObserve) return onLoadingWidget;
        if (state.firebaseFailure != null && state.isAnyFailure) return onErrorWidget;
        if (state.listOfAllCustomers == null) return onLoadingWidget;
        if (state.listOfAllCustomers!.isEmpty) return onEmptyWidget;

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: state.listOfAllCustomers!.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final customer = state.listOfAllCustomers![index];

            return ListTile(
              dense: true,
              title: Text('${customer.customerNumber} / ${customer.name}', style: TextStyles.defaultt),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (customer.company != null && customer.company!.isNotEmpty) Text(customer.company!),
                  Text(customer.creationDate.toFormattedDayMonthYear()),
                ],
              ),
              isThreeLine: true,
              onTap: () => onCustomerSelected(customer),
            );
          },
        );
      },
    );
  }
}
