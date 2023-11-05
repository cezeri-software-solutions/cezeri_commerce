import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/firebase/appointment/appointment_bloc.dart';
import '../../../2_application/firebase/main_settings/main_settings_bloc.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../3_domain/entities/settings/payment_method.dart';
import '../../../constants.dart';
import '../../core/widgets/my_dropdown_button_small.dart';

class ReceiptDetailPaymentMethodCard extends StatelessWidget {
  final AppointmentBloc appointmentBloc;

  const ReceiptDetailPaymentMethodCard({super.key, required this.appointmentBloc});

  @override
  Widget build(BuildContext context) {
    final paymentMethodItems = context.read<MainSettingsBloc>().state.mainSettings!.paymentMethods.toList();
    paymentMethodItems.add(PaymentMethod.empty());

    return BlocBuilder<AppointmentBloc, AppointmentState>(
      bloc: appointmentBloc,
      builder: (context, state) {
        if (!paymentMethodItems.any((e) => e.name == state.receipt!.paymentMethod.name)) {
          paymentMethodItems.add(state.receipt!.paymentMethod);
        }

        final paymentStatusValue = switch (state.receipt!.paymentStatus) {
          PaymentStatus.open => 'Offen',
          PaymentStatus.partiallyPaid => 'Teilweise bezahlt',
          PaymentStatus.paid => 'Komplett bezahlt',
        };

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(alignment: Alignment.center, child: Text('Zahlungsart', style: TextStyles.h3BoldPrimary)),
                const Divider(height: 30),
                MyDropdownButtonSmall(
                  labelText: 'Zahlungsart',
                  value: state.receipt!.paymentMethod.name,
                  onChanged: (name) => appointmentBloc.add(
                    OnAppointmentPaymentMethodChangedEvent(paymentMethod: paymentMethodItems.where((e) => e.name == name).first),
                  ),
                  items: paymentMethodItems.map((e) => e.name).toList(),
                ),
                Gaps.h16,
                MyDropdownButtonSmall(
                  labelText: 'Zahlungsstatus',
                  value: paymentStatusValue,
                  onChanged: (name) => appointmentBloc.add(OnAppointmentPaymentStatusChangedEvent(paymentStatus: name!)),
                  items: const ['Offen', 'Teilweise bezahlt', 'Komplett bezahlt'],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
