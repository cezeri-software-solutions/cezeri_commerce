import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/database/product_detail/product_detail_bloc.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';
import '../modals/add_edit_specific_price.dart';

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
                        fieldTitle: 'VK-Preis Netto',
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
                  fieldTitle: 'VK-Preis Brutto',
                  controller: state.grossPriceController,
                  onChanged: (_) => productDetailBloc.add(OnProductSalesPriceControllerChangedEvent(isNet: false)),
                ),
                Gaps.h16,
                MyTextFormFieldSmall(
                  fieldTitle: 'UVP',
                  controller: state.recommendedRetailPriceController,
                  onChanged: (_) => productDetailBloc.add(OnProductControllerChangedEvent()),
                ),
                Gaps.h16,
                MyTextFormFieldSmall(
                  fieldTitle: 'Einheitspreis Netto',
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
                  fieldTitle: 'Einheit',
                  hintText: 'z.B. pro 1 L',
                  controller: state.unityController,
                  onChanged: (_) => productDetailBloc.add(OnProductControllerChangedEvent()),
                ),
                Gaps.h8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Rabatt:'),
                    IconButton(
                      onPressed: () {
                        if (state.originalProduct!.specificPrice != null) {
                          print('--- EN EN BEFORE ---');
                          for (final mm in state.originalProduct!.specificPrice!.listOfSpecificPriceMarketplaces) {
                            print('originalMp: ${mm.marketplaceId} - ${mm.specificPriceId}');
                          }
                        }
                        addEditSpecificPrice(context, productDetailBloc, state.product!);
                      },
                      icon: Icon(state.product!.specificPrice == null ? Icons.add : Icons.edit, color: CustomColors.primaryColor),
                    ),
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
