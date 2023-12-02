import 'package:cezeri_commerce/1_presentation/core/widgets/my_dropdown_button_small.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../2_application/firebase/customer/customer_bloc.dart';
import '../../../../../3_domain/entities/customer/customer.dart';
import '../../../../../constants.dart';
import '../../../../core/widgets/my_country_flag.dart';
import '../../../../core/widgets/my_form_field_small.dart';
import 'customer_select_tax_dialog.dart';

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
        print('TAX: ${state.customer!.tax}');

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
                Gaps.h8,
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
                Gaps.h8,
                MyTextFormFieldSmall(
                  labelText: 'E-Mail',
                  controller: state.emailController,
                ),
                Gaps.h8,
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
                Gaps.h8,
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
                Gaps.h16,
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
                Gaps.h16,
                GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => BlocProvider.value(
                      value: customerBloc,
                      child: CustomerSelectTaxDialog(customerBloc: customerBloc),
                    ),
                  ),
                  child: Container(
                    height: 28,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: CustomColors.borderColorLight),
                    ),
                    child: Row(
                      children: [
                        MyCountryFlag(country: state.customer!.tax.country),
                        Gaps.w8,
                        Text(
                          state.customer!.tax.taxName,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
                Gaps.h16,
              ],
            ),
          ),
        );
      },
    );
  }
}
