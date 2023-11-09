import 'package:cezeri_commerce/1_presentation/core/widgets/my_dropdown_button_small.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../2_application/firebase/customer/customer_bloc.dart';
import '../../../../../3_domain/entities/customer/customer.dart';
import '../../../../../constants.dart';
import '../../../../core/widgets/my_form_field_small.dart';

class CustomerMasterCard extends StatelessWidget {
  final CustomerBloc customerBloc;

  const CustomerMasterCard({super.key, required this.customerBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerBloc, CustomerState>(
      bloc: customerBloc,
      builder: (context, state) {
        final invoiceTypeValue = switch (state.customer!.customerInvoiceType) {
          CustomerInvoiceType.standardInvoice => 'Stand- Einzelrechnung',
          CustomerInvoiceType.collectiveInvoice => 'Sammelrechnung',
        };

        final invoiceTypeItems = ['Stand- Einzelrechnung', 'Sammelrechnung'];

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Kunde', style: TextStyles.h3BoldPrimary),
                const Divider(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: MyTextFormFieldSmall(
                        readOnly: true,
                        labelText: 'Kundennummer',
                        hintText: state.customer!.customerNumber.toString(),
                      ),
                    ),
                    Gaps.w8,
                    Expanded(
                      child: MyTextFormFieldSmall(
                        labelText: 'Firmenname',
                        controller: state.companyNameController,
                      ),
                    ),
                  ],
                ),
                Gaps.h4,
                Row(
                  children: [
                    Expanded(
                      child: MyTextFormFieldSmall(
                        labelText: 'Vorname',
                        controller: state.firstNameController,
                      ),
                    ),
                    Gaps.w8,
                    Expanded(
                      child: MyTextFormFieldSmall(
                        labelText: 'Nachname',
                        controller: state.lastNameController,
                      ),
                    ),
                  ],
                ),
                Gaps.h4,
                MyTextFormFieldSmall(
                  labelText: 'E-Mail',
                  controller: state.emailController,
                ),
                Gaps.h4,
                Row(
                  children: [
                    Expanded(
                      child: MyTextFormFieldSmall(
                        labelText: 'Telefonnummer',
                        controller: state.phoneController,
                      ),
                    ),
                    Gaps.w8,
                    Expanded(
                      child: MyTextFormFieldSmall(
                        labelText: 'Telefonnummer Mobil',
                        controller: state.phoneMobileController,
                      ),
                    ),
                  ],
                ),
                Gaps.h4,
                Row(
                  children: [
                    Expanded(
                      child: MyTextFormFieldSmall(
                        labelText: 'UID-Nummer',
                        controller: state.uidNumberController,
                      ),
                    ),
                    Gaps.w8,
                    Expanded(
                      child: MyTextFormFieldSmall(
                        labelText: 'Steuernummer',
                        controller: state.taxNumberController,
                      ),
                    ),
                  ],
                ),
                Gaps.h4,
                MyDropdownButtonSmall(
                  value: invoiceTypeValue,
                  onChanged: (type) => customerBloc.add(OnCustomerInvoiceTypeChangedEvent(
                    customerInvoiceType: switch (type!) {
                      'Stand- Einzelrechnung' => CustomerInvoiceType.standardInvoice,
                      'Sammelrechnung' => CustomerInvoiceType.collectiveInvoice,
                      _ => throw Error,
                    },
                  )),
                  items: invoiceTypeItems,
                ),
                Gaps.h4,
              ],
            ),
          ),
        );
      },
    );
  }
}
