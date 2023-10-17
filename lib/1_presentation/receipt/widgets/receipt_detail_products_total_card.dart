import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/firebase/appointment/appointment_bloc.dart';
import '../../../2_application/firebase/receipt_detail/receipt_detail_bloc.dart';
import '../../../constants.dart';
import '../../core/widgets/my_text_form_field_small_double.dart';

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
                //DropdownButton(items: const [], onChanged: (_) {}),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Rabatt in %'),
                    Row(
                      children: [
                        const Icon(Icons.remove),
                        MyTextFormFieldSmallDouble(
                          maxWidth: 100,
                          controller: state.discountPercentageController,
                          suffix: const Text('%'),
                          onChanged: (value) => receiptDetailBloc.add(SetTotalDiscountPercentControllerEvent(value: value.toMyDouble())),
                          onTapOutside: (_) => receiptDetailBloc.add(SetControllerOnTapOutsideReceiptDetailEvent()),
                        ),
                      ],
                    ),
                  ],
                ),
                Gaps.h8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Rabatt in ${state.receipt.currency}'),
                    Row(
                      children: [
                        const Icon(Icons.remove),
                        MyTextFormFieldSmallDouble(
                          maxWidth: 100,
                          controller: state.discountAmountGrossController,
                          suffix: Text(state.receipt.currency),
                          onChanged: (value) => receiptDetailBloc.add(SetTotalDiscountAmountGrossControllerEvent(value: value.toMyDouble())),
                          onTapOutside: (_) => receiptDetailBloc.add(SetControllerOnTapOutsideReceiptDetailEvent()),
                        ),
                      ],
                    ),
                  ],
                ),
                Gaps.h8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Zuschlag'),
                    Row(
                      children: [
                        const Icon(Icons.add),
                        MyTextFormFieldSmallDouble(
                          maxWidth: 100,
                          controller: state.additionalAmountGrossController,
                          suffix: Text(state.receipt.currency),
                          onChanged: (value) => receiptDetailBloc.add(SetAdditionalAmountGrossControllerEvent(value: value.toMyDouble())),
                          onTapOutside: (_) => receiptDetailBloc.add(SetControllerOnTapOutsideReceiptDetailEvent()),
                        ),
                      ],
                    ),
                  ],
                ),
                Gaps.h8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Versandkosten'),
                    Row(
                      children: [
                        const Icon(Icons.add),
                        MyTextFormFieldSmallDouble(
                          maxWidth: 100,
                          controller: state.shippingAmountGrossController,
                          suffix: Text(state.receipt.currency),
                          onChanged: (value) => receiptDetailBloc.add(SetShippingAmountGrossControllerEvent(value: value.toMyDouble())),
                          onTapOutside: (_) => receiptDetailBloc.add(SetControllerOnTapOutsideReceiptDetailEvent()),
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(thickness: 3, height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Zwischensumme Netto'),
                    Text('${state.productsTotalNet.toMyCurrencyStringToShow()} ${state.receipt.currency}', style: TextStyles.defaultBold),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Zwischensumme Brutto'),
                    Text('${state.productsTotalGross.toMyCurrencyStringToShow()} ${state.receipt.currency}', style: TextStyles.defaultBold),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Pos. % Rabatt'),
                    Text('${state.posDiscountPercentAmount.toMyCurrencyStringToShow()} ${state.receipt.currency}', style: TextStyles.defaultBold),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('% Rabatt'),
                    Text('${state.discountPercentageAmountGross.toMyCurrencyStringToShow()} ${state.receipt.currency}',
                        style: TextStyles.defaultBold),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${state.receipt.currency} Rabatt'),
                    Text('${state.receipt.discountGross.toMyCurrencyStringToShow()} ${state.receipt.currency}', style: TextStyles.defaultBold),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Zuschlag'),
                    Text('${state.receipt.additionalAmountGross.toMyCurrencyStringToShow()} ${state.receipt.currency}',
                        style: TextStyles.defaultBold),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Versandkosten'),
                    Text('${state.receipt.totalShippingGross.toMyCurrencyStringToShow()} ${state.receipt.currency}', style: TextStyles.defaultBold),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Gesamtbetrag Netto'),
                    Text('${state.receipt.totalNet.toMyCurrencyStringToShow()} ${state.receipt.currency}', style: TextStyles.defaultBold),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Umsatzsteuer ${state.receipt.tax.taxRate}%'),
                    Text('${state.receipt.totalTax.toMyCurrencyStringToShow()} ${state.receipt.currency}', style: TextStyles.defaultBold),
                  ],
                ),
                const Divider(thickness: 3, height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Gesamtbetrag Brutto', style: TextStyles.defaultBold),
                    Text('${state.totalGross.toMyCurrencyStringToShow()} ${state.receipt.currency}', style: TextStyles.defaultBold),
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
