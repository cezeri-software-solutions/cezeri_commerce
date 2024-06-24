import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../2_application/database/customer_detail/customer_detail_bloc.dart';
import '../../../../3_domain/entities/customer/customer.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';
import 'customer_detail_screen.dart';
import 'widgets/customer_address_card.dart';
import 'widgets/customer_master_card.dart';
import 'widgets/customer_receipt_list.dart';

class CustomerDetailPage extends StatelessWidget {
  final Customer customer;
  final CustomerDetailBloc customerDetailBloc;
  final CustomerCreateOrEdit customerCreateOrEdit;

  const CustomerDetailPage({super.key, required this.customer, required this.customerDetailBloc, required this.customerCreateOrEdit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerDetailBloc, CustomerDetailState>(
      bloc: customerDetailBloc,
      builder: (context, state) {
        final isTabletOrLarger = ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET);

        final appBar = AppBar(
          title: const Text('Kunde'),
          actions: [
            if (customerCreateOrEdit == CustomerCreateOrEdit.edit)
              IconButton(
                onPressed: () => customerDetailBloc.add(CustomerDetailGetCustomerEvent(customerId: state.customer!.id)),
                icon: const Icon(Icons.refresh),
              ),
            isTabletOrLarger
                ? MyOutlinedButton(
                    buttonText: 'Speichern',
                    onPressed: _onSavePressed,
                    isLoading: customerCreateOrEdit == CustomerCreateOrEdit.edit
                        ? state.isLoadingCustomerDetailOnUpdate
                        : state.isLoadingCustomerDetailOnCreate,
                    buttonBackgroundColor: Colors.green,
                  )
                : MyIconButton(
                    onPressed: _onSavePressed,
                    icon: const Icon(Icons.save, color: Colors.green),
                    isLoading: customerCreateOrEdit == CustomerCreateOrEdit.edit
                        ? state.isLoadingCustomerDetailOnUpdate
                        : state.isLoadingCustomerDetailOnCreate,
                  ),
            if (isTabletOrLarger) Gaps.w32,
          ],
        );

        return Scaffold(
          appBar: appBar,
          body: SafeArea(
            child: isTabletOrLarger
                ? Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: CustomerMasterCard(customerDetailBloc: customerDetailBloc)),
                            Gaps.w8,
                            Expanded(child: CustomerAddressCard(customer: state.customer!, customerDetailBloc: customerDetailBloc)),
                          ],
                        ),
                        Gaps.h8,
                        Expanded(child: CustomerReceiptList(customerDetailBloc: customerDetailBloc, state: state)),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          CustomerMasterCard(customerDetailBloc: customerDetailBloc),
                          Gaps.h8,
                          CustomerAddressCard(customer: state.customer!, customerDetailBloc: customerDetailBloc),
                          Gaps.h10,
                          CustomerReceiptList(customerDetailBloc: customerDetailBloc, state: state),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  _onSavePressed() {
    if (customerCreateOrEdit == CustomerCreateOrEdit.edit) {
      customerDetailBloc.add(CustomerDetailUpdateCustomerEvent());
    } else {
      customerDetailBloc.add(CustomerDetailCreateCustomerEvent());
    }
  }
}
