import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../2_application/firebase/customer/customer_bloc.dart';
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
              ],
            ),
          ),
        );
      },
    );
  }
}
