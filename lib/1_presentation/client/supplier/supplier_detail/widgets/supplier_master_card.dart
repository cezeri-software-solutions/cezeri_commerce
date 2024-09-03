import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../2_application/database/supplier/supplier_bloc.dart';
import '../../../../../constants.dart';
import '../../../../core/core.dart';

class SupplierMasterCard extends StatelessWidget {
  final SupplierBloc supplierBloc;

  const SupplierMasterCard({super.key, required this.supplierBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SupplierBloc, SupplierState>(
      bloc: supplierBloc,
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Lieferant', style: TextStyles.h3BoldPrimary),
                const Divider(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: MyTextFormFieldSmall(
                        readOnly: true,
                        labelText: 'Lieferantennummer',
                        hintText: state.supplier!.supplierNumber.toString(),
                      ),
                    ),
                    Gaps.w8,
                    Expanded(
                      child: MyTextFormFieldSmall(
                        labelText: 'Firmenname',
                        controller: state.companyNameController,
                        onChanged: (_) => supplierBloc.add(OnSupplierControllerChangedEvent()),
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
                        onChanged: (_) => supplierBloc.add(OnSupplierControllerChangedEvent()),
                      ),
                    ),
                    Gaps.w8,
                    Expanded(
                      child: MyTextFormFieldSmall(
                        labelText: 'Nachname',
                        controller: state.lastNameController,
                        onChanged: (_) => supplierBloc.add(OnSupplierControllerChangedEvent()),
                      ),
                    ),
                  ],
                ),
                Gaps.h8,
                Row(
                  children: [
                    Expanded(
                      child: MyTextFormFieldSmall(
                        labelText: 'E-Mail',
                        controller: state.emailController,
                        onChanged: (_) => supplierBloc.add(OnSupplierControllerChangedEvent()),
                      ),
                    ),
                    Gaps.w8,
                    Expanded(
                      child: MyTextFormFieldSmall(
                        labelText: 'Homepage',
                        controller: state.homepageController,
                        onChanged: (_) => supplierBloc.add(OnSupplierControllerChangedEvent()),
                      ),
                    ),
                  ],
                ),
                Gaps.h8,
                Row(
                  children: [
                    Expanded(
                      child: MyTextFormFieldSmall(
                        labelText: 'Telefonnummer',
                        controller: state.phoneController,
                        onChanged: (_) => supplierBloc.add(OnSupplierControllerChangedEvent()),
                      ),
                    ),
                    Gaps.w8,
                    Expanded(
                      child: MyTextFormFieldSmall(
                        labelText: 'Telefonnummer Mobil',
                        controller: state.phoneMobileController,
                        onChanged: (_) => supplierBloc.add(OnSupplierControllerChangedEvent()),
                      ),
                    ),
                  ],
                ),
                Gaps.h16,
                GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => MyDialogTaxes(onChanged: (taxRule) => supplierBloc.add(SetSupplierTaxEvent(tax: taxRule))),
                  ),
                  child: MyButtonSmall(
                    child: Row(
                      children: [
                        MyCountryFlag(country: state.supplier!.tax.country),
                        Gaps.w8,
                        Text(
                          state.supplier!.tax.taxName,
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
