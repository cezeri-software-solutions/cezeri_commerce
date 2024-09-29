import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/database/product_detail/product_detail_bloc.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';

class SellingCard extends StatelessWidget {
  final ProductDetailBloc productDetailBloc;

  const SellingCard({super.key, required this.productDetailBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      bloc: productDetailBloc,
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Verkauf', style: TextStyles.h3BoldPrimary),
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      child: MyTextFormFieldSmall(
                        labelText: 'VK-Preis Netto',
                        controller: state.netPriceController,
                        onChanged: (value) => productDetailBloc.add(OnProductSalesPriceControllerChangedEvent(isNet: true)),
                      ),
                    ),
                    if (state.product!.isSetArticle && state.product!.listOfProductIdWithQuantity.isNotEmpty)
                      IconButton(
                        onPressed: () => productDetailBloc.add(OnSetProductSalesNetPriceGeneratedEvent()),
                        icon: const Icon(Icons.reply_all_outlined, color: CustomColors.primaryColor),
                      ),
                  ],
                ),
                Gaps.h16,
                MyTextFormFieldSmall(
                  labelText: 'VK-Preis Brutto',
                  controller: state.grossPriceController,
                  onChanged: (_) => productDetailBloc.add(OnProductSalesPriceControllerChangedEvent(isNet: false)),
                ),
                Gaps.h16,
                MyTextFormFieldSmall(
                  labelText: 'UVP',
                  controller: state.recommendedRetailPriceController,
                  onChanged: (_) => productDetailBloc.add(OnProductControllerChangedEvent()),
                ),
                Gaps.h16,
                MyTextFormFieldSmall(
                  labelText: 'Einheitspreis Netto',
                  controller: state.unitPriceController,
                  onChanged: (_) => productDetailBloc.add(OnProductControllerChangedEvent()),
                ),
                Gaps.h8,
                Row(
                  children: [
                    Gaps.w4,
                    GestureDetector(
                      onTap: () {},
                      child: const Badge(label: Text('1:1', style: TextStyles.s12Bold), backgroundColor: CustomColors.chartColorBlue),
                    )
                  ],
                ),
                Gaps.h10,
                MyTextFormFieldSmall(
                  labelText: 'Einheit',
                  hintText: 'z.B. pro 1 L',
                  controller: state.unityController,
                  onChanged: (_) => productDetailBloc.add(OnProductControllerChangedEvent()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
