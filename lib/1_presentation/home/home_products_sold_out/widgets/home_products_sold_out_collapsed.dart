import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/database/home/home_product/home_product_bloc.dart';
import '../../../../3_domain/enums/enums.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';

class HomeProductsSoldOutCollapsed extends StatelessWidget {
  final HomeProductBloc homeProductBloc;

  const HomeProductsSoldOutCollapsed({super.key, required this.homeProductBloc});

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.screenWidth;
    final responsiveness = screenWidth > 700 ? Responsiveness.isTablet : Responsiveness.isMobil;

    return BlocBuilder<HomeProductBloc, HomeProductState>(
      builder: (context, state) {
        final listOfProducts = switch (state.showProductsBy) {
          ShowProductsBy.soldOut => state.listOfProductsSoldOut,
          ShowProductsBy.underMinimumQuantity => state.listOfProductsUnderMinimumQuantity,
        };

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
                        if (listOfProducts == null)
                          const Text('Artikel-Bestand:', style: TextStyles.h2Bold)
                        else
                          Text.rich(TextSpan(children: [
                            const TextSpan(text: 'Artikel-Bestand:', style: TextStyles.h2Bold),
                            const TextSpan(text: ' ', style: TextStyles.h2Bold),
                            TextSpan(text: '(${listOfProducts.length})', style: TextStyles.h2),
                          ])),
                        if (responsiveness == Responsiveness.isTablet) ...[
                          Gaps.w16,
                          MyChipWithTwoOptions(
                            titleLeft: 'Hersteller',
                            titleRight: 'Lieferant',
                            onTapLeft: () =>
                                homeProductBloc.add(OnHomeProductGroupProductsByChangedEvent(groupProductsBy: GroupProductsBy.manufacturer)),
                            onTapRight: () =>
                                homeProductBloc.add(OnHomeProductGroupProductsByChangedEvent(groupProductsBy: GroupProductsBy.supplier)),
                            colorLeft: state.groupProductsBy == GroupProductsBy.manufacturer
                                ? CustomColors.chipSelectedColor
                                : CustomColors.chipBackgroundColor,
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
                            colorLeft: state.showProductsBy == ShowProductsBy.soldOut
                                ? CustomColors.backgroundLightGreen
                                : CustomColors.todoScaleGreenDisabled,
                            colorRight: state.showProductsBy == ShowProductsBy.underMinimumQuantity
                                ? CustomColors.backgroundLightGreen
                                : CustomColors.todoScaleGreenDisabled,
                          ),
                        ],
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
                        MyAnimatedIconButtonArrow(
                          boolValue: state.isExpandedProductsSoldOut,
                          onPressed: () => homeProductBloc.add(OnHomeProductIsExpandedSoldOutChangedEvent(value: !state.isExpandedProductsSoldOut)),
                        ),
                      ],
                    ),
                  ],
                ),
                if (responsiveness == Responsiveness.isMobil) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                  Gaps.h8,
                ],
              ],
            ),
          ],
        );
      },
    );
  }
}
