import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../2_application/database/customer_detail/customer_detail_bloc.dart';
import '../../../../../3_domain/entities/customer/customer.dart';
import '../../../../../constants.dart';
import '../../../../core/core.dart';

class CustomerMasterCard extends StatelessWidget {
  final CustomerDetailBloc customerDetailBloc;

  const CustomerMasterCard({super.key, required this.customerDetailBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerDetailBloc, CustomerDetailState>(
      bloc: customerDetailBloc,
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
                if (state.customer!.customerMarketplace != null) ...[
                  Text('Kundennummer im Marktplatz: ${state.customer!.customerMarketplace!.customerIdMarketplace}'),
                  Gaps.h10,
                ],
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
                        onChanged: (_) => customerDetailBloc.add(CustomerDetailControllerChangedEvent()),
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
                        onChanged: (_) => customerDetailBloc.add(CustomerDetailControllerChangedEvent()),
                      ),
                    ),
                    Gaps.w8,
                    Expanded(
                      child: MyTextFormFieldSmall(
                        labelText: 'Nachname',
                        controller: state.lastNameController,
                        onChanged: (_) => customerDetailBloc.add(CustomerDetailControllerChangedEvent()),
                      ),
                    ),
                  ],
                ),
                Gaps.h8,
                MyTextFormFieldSmall(
                  labelText: 'E-Mail',
                  controller: state.emailController,
                  onChanged: (_) => customerDetailBloc.add(CustomerDetailControllerChangedEvent()),
                ),
                Gaps.h8,
                Row(
                  children: [
                    Expanded(
                      child: MyTextFormFieldSmall(
                        labelText: 'Telefonnummer',
                        controller: state.phoneController,
                        onChanged: (_) => customerDetailBloc.add(CustomerDetailControllerChangedEvent()),
                      ),
                    ),
                    Gaps.w8,
                    Expanded(
                      child: MyTextFormFieldSmall(
                        labelText: 'Telefonnummer Mobil',
                        controller: state.phoneMobileController,
                        onChanged: (_) => customerDetailBloc.add(CustomerDetailControllerChangedEvent()),
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
                        onChanged: (_) => customerDetailBloc.add(CustomerDetailControllerChangedEvent()),
                      ),
                    ),
                    Gaps.w8,
                    Expanded(
                      child: MyTextFormFieldSmall(
                        labelText: 'Steuernummer',
                        controller: state.taxNumberController,
                        onChanged: (_) => customerDetailBloc.add(CustomerDetailControllerChangedEvent()),
                      ),
                    ),
                  ],
                ),
                Gaps.h16,
                MyDropdownButtonSmall(
                  value: invoiceTypeValue,
                  onChanged: (type) => customerDetailBloc.add(CustomerDetailInvoiceTypeChangedEvent(
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
                    builder: (_) => MyDialogTaxes(onChanged: (taxRule) => customerDetailBloc.add(CustomerDetailSetCustomerTaxEvent(tax: taxRule))),
                  ),
                  child: MyButtonSmall(
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
