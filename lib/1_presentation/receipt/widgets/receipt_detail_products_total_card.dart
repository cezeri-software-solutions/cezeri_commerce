import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/firebase/appointment/appointment_bloc.dart';
import '../../../2_application/firebase/receipt_detail/receipt_detail_bloc.dart';
import '../../../constants.dart';

class ReceiptDetailProductsTotalCard extends StatelessWidget {
  final AppointmentBloc appointmentBloc;
  final ReceiptDetailBloc receiptDetailBloc;

  const ReceiptDetailProductsTotalCard({super.key, required this.appointmentBloc, required this.receiptDetailBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceiptDetailBloc, ReceiptDetailState>(
      bloc: receiptDetailBloc,
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Zwischensumme Netto'),
                    Text('${state.productsTotalNet.toMyCurrency()} ${state.receipt.currency}', style: TextStyles.defaultBold),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Zwischensumme Brutto'),
                    Text('${state.procutsTotalGross.toMyCurrency()} ${state.receipt.currency}', style: TextStyles.defaultBold),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Pos. % Rabatt'),
                    Text('${state.posDiscountPercentAmount.toMyCurrency()} ${state.receipt.currency}', style: TextStyles.defaultBold),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('% Rabatt'),
                    Text('${state.discountPercentageAmountGross.toMyCurrency()} ${state.receipt.currency}', style: TextStyles.defaultBold),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${state.receipt.currency} Rabatt'),
                    Text('${state.discountAmountGross.toMyCurrency()} ${state.receipt.currency}', style: TextStyles.defaultBold),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Versandkosten'),
                    Text('${state.shippingAmountGross.toMyCurrency()} ${state.receipt.currency}', style: TextStyles.defaultBold),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Zuschlag'),
                    Text('${state.additionalAmountGross.toMyCurrency()} ${state.receipt.currency}', style: TextStyles.defaultBold),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Umsatzsteuer ${state.receipt.tax}%'),
                    Text('${state.taxAmount.toMyCurrency()} ${state.receipt.currency}', style: TextStyles.defaultBold),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Gesamtbetrag Brutto', style: TextStyles.defaultBold),
                    Text('${state.totalGross.toMyCurrency()} ${state.receipt.currency}', style: TextStyles.defaultBold),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
