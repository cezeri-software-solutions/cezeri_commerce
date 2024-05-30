import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/database/customer/customer_bloc.dart';
import '../../../../3_domain/entities/customer/customer.dart';
import '../../../../3_domain/enums/enums.dart';
import '../../../../constants.dart';
import '../../../core/widgets/my_outlined_button.dart';
import 'customer_detail_screen.dart';
import 'widgets/customer_address_card.dart';
import 'widgets/customer_master_card.dart';

class CustomerDetailPage extends StatelessWidget {
  final Customer? customer;
  final CustomerBloc customerBloc;
  final CustomerCreateOrEdit customerCreateOrEdit;

  const CustomerDetailPage({super.key, this.customer, required this.customerBloc, required this.customerCreateOrEdit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerBloc, CustomerState>(
      bloc: customerBloc,
      builder: (context, state) {
        final screenWidth = MediaQuery.sizeOf(context).width;
        final responsiveness = screenWidth > 700 ? Responsiveness.isTablet : Responsiveness.isMobil;

        final appBar = AppBar(
          title: const Text('Kunde'),
          centerTitle: responsiveness == Responsiveness.isTablet ? true : false,
          actions: [
            if (customerCreateOrEdit == CustomerCreateOrEdit.edit)
              IconButton(
                onPressed: () => customerBloc.add(GetCustomerEvent(customer: state.customer!)),
                icon: const Icon(Icons.refresh, size: 30),
              ),
            responsiveness == Responsiveness.isTablet ? Gaps.w32 : Gaps.w8,
            MyOutlinedButton(
              buttonText: 'Speichern',
              onPressed: () {
                if (customerCreateOrEdit == CustomerCreateOrEdit.edit) {
                  customerBloc.add(UpdateCustomerEvent());
                } else {
                  customerBloc.add(CreateCustomerEvent());
                }
              },
              isLoading: state.isLoadingCustomerOnUpdate,
              buttonBackgroundColor: Colors.green,
            ),
            responsiveness == Responsiveness.isTablet ? Gaps.w32 : Gaps.w8,
          ],
        );

        return Scaffold(
          appBar: appBar,
          body: SafeArea(
            child: responsiveness == Responsiveness.isTablet
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CustomerMasterCard(customerBloc: customerBloc),
                              ),
                              Gaps.w8,
                              Expanded(
                                child: CustomerAddressCard(customer: state.customer!, customerBloc: customerBloc),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListView(
                      children: [
                        CustomerMasterCard(customerBloc: customerBloc),
                        CustomerAddressCard(customer: state.customer!, customerBloc: customerBloc),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
