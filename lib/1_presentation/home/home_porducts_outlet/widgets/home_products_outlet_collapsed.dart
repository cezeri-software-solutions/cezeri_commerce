import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/database/home/home_product/home_product_bloc.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';

class HomeProductsOutletCollapsed extends StatelessWidget {
  final HomeProductBloc homeProductBloc;

  const HomeProductsOutletCollapsed({super.key, required this.homeProductBloc});

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
                        if (state.listOfProductsOutlet == null)
                          const Text('Auslaufartikel:', style: TextStyles.h2Bold)
                        else
                          Text.rich(TextSpan(children: [
                            const TextSpan(text: 'Auslaufartikel:', style: TextStyles.h2Bold),
                            const TextSpan(text: ' ', style: TextStyles.h2Bold),
                            TextSpan(text: '(${state.listOfProductsOutlet!.length})', style: TextStyles.h2),
                          ])),
                        Gaps.w16,
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => homeProductBloc.add(GetHomeProductsOutletProductsEvent()),
                          icon: const Icon(Icons.refresh),
                        ),
                        MyAnimatedIconButtonArrow(
                          boolValue: state.isExpandedProductsOutlet,
                          onPressed: () => homeProductBloc.add(OnHomeProductIsExpandedOutletChangedEvent(value: !state.isExpandedProductsOutlet)),
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
