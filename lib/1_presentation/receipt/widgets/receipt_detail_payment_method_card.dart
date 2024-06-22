import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/database/main_settings/main_settings_bloc.dart';
import '../../../2_application/database/receipt_detail/receipt_detail_bloc.dart';
import '../../../3_domain/entities/receipt/receipt.dart';
import '../../../3_domain/entities/settings/payment_method.dart';
import '../../../constants.dart';
import '../../core/core.dart';

class ReceiptDetailPaymentMethodCard extends StatelessWidget {
  final ReceiptDetailBloc receiptDetailBloc;

  const ReceiptDetailPaymentMethodCard({super.key, required this.receiptDetailBloc});

  @override
  Widget build(BuildContext context) {
    final paymentMethodItems = context.read<MainSettingsBloc>().state.mainSettings!.paymentMethods.toList();
    paymentMethodItems.add(PaymentMethod.empty());

    return BlocBuilder<ReceiptDetailBloc, ReceiptDetailState>(
      bloc: receiptDetailBloc,
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
                  onChanged: (name) => receiptDetailBloc.add(
                    ReceiptDetailPaymentMethodChangedEvent(paymentMethod: paymentMethodItems.where((e) => e.name == name).first),
                  ),
                  items: paymentMethodItems.map((e) => e.name).toList(),
                ),
                Gaps.h16,
                MyDropdownButtonSmall(
                  labelText: 'Zahlungsstatus',
                  value: paymentStatusValue,
                  onChanged: (name) => receiptDetailBloc.add(ReceiptDetailPaymentStatusChangedEvent(paymentStatus: name!)),
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
