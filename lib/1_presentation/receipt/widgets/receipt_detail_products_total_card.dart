import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/database/receipt_detail/receipt_detail_bloc.dart';
import '../../../2_application/database/receipt_detail_products/receipt_detail_products_bloc.dart';
import '../../../constants.dart';
import '../../core/core.dart';

class ReceiptDetailProductsTotalCard extends StatelessWidget {
  final ReceiptDetailBloc receiptDetailBloc;
  final ReceiptDetailProductsBloc receiptDetailProductsBloc;

  const ReceiptDetailProductsTotalCard({super.key, required this.receiptDetailBloc, required this.receiptDetailProductsBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceiptDetailProductsBloc, ReceiptDetailProductsState>(
      bloc: receiptDetailProductsBloc,
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
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
                          onChanged: (value) => receiptDetailProductsBloc.add(SetTotalDiscountPercentControllerEvent(value: value.toMyDouble())),
                          onTapOutside: (_) => receiptDetailProductsBloc.add(SetControllerOnTapOutsideReceiptDetailEvent()),
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
                          onChanged: (value) => receiptDetailProductsBloc.add(SetTotalDiscountAmountGrossControllerEvent(value: value.toMyDouble())),
                          onTapOutside: (_) => receiptDetailProductsBloc.add(SetControllerOnTapOutsideReceiptDetailEvent()),
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
                          onChanged: (value) => receiptDetailProductsBloc.add(SetAdditionalAmountGrossControllerEvent(value: value.toMyDouble())),
                          onTapOutside: (_) => receiptDetailProductsBloc.add(SetControllerOnTapOutsideReceiptDetailEvent()),
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
                          onChanged: (value) => receiptDetailProductsBloc.add(SetShippingAmountGrossControllerEvent(value: value.toMyDouble())),
                          onTapOutside: (_) => receiptDetailProductsBloc.add(SetControllerOnTapOutsideReceiptDetailEvent()),
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
