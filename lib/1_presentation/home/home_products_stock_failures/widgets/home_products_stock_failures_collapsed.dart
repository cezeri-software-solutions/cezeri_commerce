import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/database/home/home_product/home_product_bloc.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';

class HomeProductsStockFailuresCollapsed extends StatelessWidget {
  final HomeProductBloc homeProductBloc;

  const HomeProductsStockFailuresCollapsed({super.key, required this.homeProductBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeProductBloc, HomeProductState>(
      builder: (context, state) {
        return Column(
          children: [
            const Divider(),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (state.listOfProductStockDifferences == null)
                          const Text('Artikel Bestandsfehler:', style: TextStyles.h2Bold)
                        else
                          Text.rich(TextSpan(children: [
                            const TextSpan(text: 'Artikel Bestandsfehler:', style: TextStyles.h2Bold),
                            const TextSpan(text: ' ', style: TextStyles.h2Bold),
                            TextSpan(text: '(${state.listOfProductStockDifferences!.length})', style: TextStyles.h2),
                          ])),
                        Gaps.w16,
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => homeProductBloc.add(GetHomeProductStockDifferencesEvent()),
                          icon: const Icon(Icons.refresh),
                        ),
                        MyAnimatedIconButtonArrow(
                          boolValue: state.isExpandedProductsStockDiff,
                          onPressed: () => homeProductBloc.add(
                            OnHomeProductIsExpandedStockDifferencesChangedEvent(value: !state.isExpandedProductsStockDiff),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
