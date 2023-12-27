import 'package:cezeri_commerce/1_presentation/core/widgets/my_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/2_application/firebase/product/product_bloc.dart';
import '/constants.dart';
import 'product_bart_chart_items_sold.dart';
import 'product_line_chart_sales_volume.dart';

class ProductChartCard extends StatelessWidget {
  final ProductBloc productBloc;

  const ProductChartCard({super.key, required this.productBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      bloc: productBloc,
      builder: (context, state) {
        if (state.isLoadingStatProductsOnObserve) return const _LoadingOrFailureCard(widget: MyCircularProgressIndicator());
        if (state.firebaseFailureChart != null) return const _LoadingOrFailureCard(widget: Text('Ein Fehler ist aufgetreten'));
        if (state.listOfStatProducts == null) return const _LoadingOrFailureCard(widget: MyCircularProgressIndicator());

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Auswertung', style: TextStyles.h3BoldPrimary),
                const Divider(height: 30),
                AspectRatio(
                  aspectRatio: 2.8,
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Gaps.h54,
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16, left: 6),
                              child: state.isShowingSalesVolumeOnChart ? ProductLineChartSalesVolume(statProducts: state.listOfStatProducts!) : ProductBartChartItemsSold(statProducts: state.listOfStatProducts!),
                              
                            ),
                          ),
                          Gaps.h10,
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.refresh, color: CustomColors.primaryColor),
                            onPressed: () => productBloc.add(OnProductChangeChartModeEvent()),
                          ),
                          Text(state.isShowingSalesVolumeOnChart ? 'Umsatz Netto' : 'Anzahl Verkäufe', style: TextStyles.defaultBold),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LoadingOrFailureCard extends StatelessWidget {
  final Widget widget;

  const _LoadingOrFailureCard({required this.widget});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Statistik', style: TextStyles.h3BoldPrimary),
            const Divider(height: 30),
            SizedBox(height: 200, child: Center(child: widget))
          ],
        ),
      ),
    );
  }
}
