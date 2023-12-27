import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/firebase/home/home_product/home_product_bloc.dart';
import '../../../../constants.dart';
import '../../../core/widgets/my_chip_two_options.dart';

class HomeProductCollapsed extends StatelessWidget {
  final HomeProductBloc homeProductBloc;

  const HomeProductCollapsed({super.key, required this.homeProductBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeProductBloc, HomeProductState>(
      builder: (context, state) {
        final listOfProducts = switch (state.showProductsBy) {
          ShowProductsBy.soldOut => state.listOfProductsSoldOut,
          ShowProductsBy.underMinimumQuantity => state.listOfProductsUnderMinimumQuantity,
        };

        return Column(
          children: [
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (listOfProducts == null)
                      const Text('Artikel:', style: TextStyles.h2Bold)
                    else
                      Text('Artikel: (${listOfProducts.length})', style: TextStyles.h2Bold),
                    Gaps.w16,
                    MyChipWithTwoOptions(
                      titleLeft: 'Hersteller',
                      titleRight: 'Lieferant',
                      onTapLeft: () => homeProductBloc.add(OnHomeProductGroupProductsByChangedEvent(groupProductsBy: GroupProductsBy.manufacturer)),
                      onTapRight: () => homeProductBloc.add(OnHomeProductGroupProductsByChangedEvent(groupProductsBy: GroupProductsBy.supplier)),
                      colorLeft:
                          state.groupProductsBy == GroupProductsBy.manufacturer ? CustomColors.chipSelectedColor : CustomColors.chipBackgroundColor,
                      colorRight:
                          state.groupProductsBy == GroupProductsBy.supplier ? CustomColors.chipSelectedColor : CustomColors.chipBackgroundColor,
                    ),
                    Gaps.w16,
                    MyChipWithTwoOptions(
                      titleLeft: 'Ausverkauft',
                      titleRight: 'Mindestbestand',
                      onTapLeft: () => homeProductBloc.add(OnHomeProductShowProductsByChangedEvent(showProductsBy: ShowProductsBy.soldOut)),
                      onTapRight: () =>
                          homeProductBloc.add(OnHomeProductShowProductsByChangedEvent(showProductsBy: ShowProductsBy.underMinimumQuantity)),
                      colorLeft:
                          state.showProductsBy == ShowProductsBy.soldOut ? CustomColors.backgroundLightGreen : CustomColors.todoScaleGreenDisabled,
                      colorRight: state.showProductsBy == ShowProductsBy.underMinimumQuantity
                          ? CustomColors.backgroundLightGreen
                          : CustomColors.todoScaleGreenDisabled,
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => switch (state.showProductsBy) {
                        ShowProductsBy.soldOut => homeProductBloc.add(GetHomeProductSoldOutProductsEvent()),
                        ShowProductsBy.underMinimumQuantity => homeProductBloc.add(GetHomeProductUnderMinimumQuantityProductsEvent()),
                      },
                      icon: const Icon(Icons.refresh),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => homeProductBloc.add(OnHomeProductIsExpandedProductsChangedEvent()),
                      icon: switch (state.isExpandedProducts) {
                        true => const Icon(Icons.arrow_drop_down_circle, size: 30, color: CustomColors.primaryColor),
                        false => Transform.rotate(
                            angle: -pi / 2,
                            child: const Icon(Icons.arrow_drop_down_circle, size: 30, color: Colors.grey, grade: 25),
                          ),
                      },
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
