import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/database/reorder_detail/reorder_detail_bloc.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';


class ReorderDetailProductsTotalCard extends StatelessWidget {
  final ReorderDetailBloc reorderDetailBloc;

  const ReorderDetailProductsTotalCard({super.key, required this.reorderDetailBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReorderDetailBloc, ReorderDetailState>(
      bloc: reorderDetailBloc,
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
                          controller: state.discountPercentController,
                          suffix: const Text('%'),
                          onChanged: (value) => reorderDetailBloc.add(OnReorderDetailControllerChangedEvent()),
                        ),
                      ],
                    ),
                  ],
                ),
                Gaps.h8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Rabatt in ${state.reorder!.currency}'),
                    Row(
                      children: [
                        const Icon(Icons.remove),
                        MyTextFormFieldSmallDouble(
                          maxWidth: 100,
                          controller: state.discountAmountGrossController,
                          suffix: Text(state.reorder!.currency),
                          onChanged: (value) => reorderDetailBloc.add(OnReorderDetailControllerChangedEvent()),
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
                          suffix: Text(state.reorder!.currency),
                          onChanged: (value) => reorderDetailBloc.add(OnReorderDetailControllerChangedEvent()),
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
                          controller: state.shippingPriceGrossController,
                          suffix: Text(state.reorder!.currency),
                          onChanged: (value) => reorderDetailBloc.add(OnReorderDetailControllerChangedEvent()),
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
                    Text('${state.reorder!.productsTotalNet.toMyCurrencyStringToShow()} ${state.reorder!.currency}', style: TextStyles.defaultBold),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Zwischensumme Brutto'),
                    Text('${state.reorder!.productsTotalGross.toMyCurrencyStringToShow()} ${state.reorder!.currency}', style: TextStyles.defaultBold),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('% Rabatt'),
                    Text('${state.reorder!.discountPercentAmountGross.toMyCurrencyStringToShow()} ${state.reorder!.currency}',
                        style: TextStyles.defaultBold),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${state.reorder!.currency} Rabatt'),
                    Text('${state.reorder!.discountTotalGross.toMyCurrencyStringToShow()} ${state.reorder!.currency}', style: TextStyles.defaultBold),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Zuschlag'),
                    Text('${state.reorder!.additionalAmountGross.toMyCurrencyStringToShow()} ${state.reorder!.currency}',
                        style: TextStyles.defaultBold),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Versandkosten'),
                    Text('${state.reorder!.shippingPriceNet.toMyCurrencyStringToShow()} ${state.reorder!.currency}', style: TextStyles.defaultBold),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Gesamtbetrag Netto'),
                    Text('${state.reorder!.totalPriceNet.toMyCurrencyStringToShow()} ${state.reorder!.currency}', style: TextStyles.defaultBold),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Umsatzsteuer ${state.reorder!.tax.taxRate}%'),
                    Text('${state.reorder!.totalPriceTax.toMyCurrencyStringToShow()} ${state.reorder!.currency}', style: TextStyles.defaultBold),
                  ],
                ),
                const Divider(thickness: 3, height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Gesamtbetrag Brutto', style: TextStyles.defaultBold),
                    Text('${state.reorder!.totalPriceGross.toMyCurrencyStringToShow()} ${state.reorder!.currency}', style: TextStyles.defaultBold),
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
