import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../2_application/database/customer/customer_bloc.dart';
import '../../../2_application/database/receipt/receipt_bloc.dart';
import '../../../3_domain/entities/address.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../3_domain/entities/receipt/receipt_customer.dart';
import '../../../3_domain/entities/receipt/receipt_product.dart';
import '../../../constants.dart';
import '../../../injection.dart';
import '../../../routes/router.gr.dart';
import '../functions/address_functions.dart';
import '../widgets/my_circular_progress_indicator.dart';
import '../widgets/pages_pagination_bar.dart';

void showSelectCustomerSheet(BuildContext context, ReceiptBloc receiptBloc, ReceiptType receiptType) {
  WoltModalSheet.show(
    context: context,
    useSafeArea: false,
    showDragHandle: false,
    pageListBuilder: (context) {
      return [
        WoltModalSheetPage(
          hasTopBarLayer: true,
          isTopBarLayerAlwaysVisible: true,
          forceMaxHeight: true,
          topBarTitle: const Text('Kunde auswählen', style: TextStyles.h2Bold),
          child: _SelectCustomerSheet(receiptBloc: receiptBloc, receiptType: receiptType),
        ),
      ];
    },
  );
}

class _SelectCustomerSheet extends StatelessWidget {
  final ReceiptBloc receiptBloc;
  final ReceiptType receiptType;

  const _SelectCustomerSheet({required this.receiptBloc, required this.receiptType});

  @override
  Widget build(BuildContext context) {
    final customerBloc = sl<CustomerBloc>()..add(GetCustomersPerPageEvent(calcCount: true, currentPage: 1));

    return BlocProvider.value(
      value: customerBloc,
      child: BlocBuilder<CustomerBloc, CustomerState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.only(bottom: max(MediaQuery.paddingOf(context).bottom, 16)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: CupertinoSearchTextField(
                    controller: state.customerSearchController,
                    onSubmitted: (value) => customerBloc.add(GetCustomersPerPageEvent(calcCount: true, currentPage: 1)),
                    onSuffixTap: () => customerBloc.add(CustomerSearchFieldClearedEvent()),
                  ),
                ),
                _CustomerItems(customerBloc: customerBloc, receiptBloc: receiptBloc, receiptType: receiptType),
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
          );
        },
      ),
    );
  }
}

class _CustomerItems extends StatelessWidget {
  final CustomerBloc customerBloc;
  final ReceiptBloc receiptBloc;
  final ReceiptType receiptType;

  const _CustomerItems({required this.customerBloc, required this.receiptBloc, required this.receiptType});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final height = screenHeight - 200;

    return BlocBuilder<CustomerBloc, CustomerState>(
      bloc: customerBloc,
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
          itemCount: state.listOfFilteredCustomers!.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final customer = state.listOfFilteredCustomers![index];

            return ListTile(
              title: Text(customer.name, style: TextStyles.defaultt),
              subtitle: customer.company != null && customer.company!.isNotEmpty ? Text(customer.company!) : null,
              onTap: () {
                context.router.maybePop();
                final newAppointment = Receipt.empty().copyWith(
                  customerId: customer.id,
                  receiptCustomer: ReceiptCustomer.fromCustomer(customer),
                  addressInvoice: getDefaultAddress(customer.listOfAddress, AddressType.invoice),
                  addressDelivery: getDefaultAddress(customer.listOfAddress, AddressType.invoice),
                  tax: customer.tax,
                  listOfReceiptProduct: [ReceiptProduct.empty()],
                  receiptTyp: receiptType,
                );
                receiptBloc.add(SetReceiptEvent(appointment: newAppointment));
                context.router.push(ReceiptDetailRoute(receiptId: null, receiptTyp: receiptType));
              },
            );
          },
        );
      },
    );
  }
}
