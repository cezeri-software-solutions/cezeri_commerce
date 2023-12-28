import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/firebase/home/home_product/home_product_bloc.dart';
import '../../../../constants.dart';
import '../../../core/functions/bottom_sheets.dart';
import '../../../core/widgets/my_animated_expansion_container.dart';
import '../../../core/widgets/my_circular_progress_indicator.dart';
import 'grouped_list_of_supplier_by_manufacturer.dart';

class HomeProductExpanded extends StatelessWidget {
  final HomeProductBloc homeProductBloc;

  const HomeProductExpanded({super.key, required this.homeProductBloc});

  @override
  Widget build(BuildContext context) {
    final dividerColor = Theme.of(context).dividerColor;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return BlocBuilder<HomeProductBloc, HomeProductState>(
      builder: (context, state) {
        if (state.isLoadingHomeProductsOnObserve || state.isLoadingHomeReordersOnObserve) {
          return MyAnimatedExpansionContainer(
              isExpanded: state.isExpandedProducts, child: const SizedBox(height: 400, child: Center(child: MyCircularProgressIndicator())));
        } else if (state.firebaseFailure != null && state.isAnyFailure) {
          return MyAnimatedExpansionContainer(
              isExpanded: state.isExpandedProducts,
              child: const SizedBox(height: 400, child: Center(child: Text('Beim Laden der Daten ist ein Fehler aufgetreten'))));
        } else if (state.showProductsBy == ShowProductsBy.soldOut && state.listOfProductsSoldOut == null || state.listOfReorders == null) {
          return MyAnimatedExpansionContainer(
              isExpanded: state.isExpandedProducts, child: const SizedBox(height: 400, child: Center(child: MyCircularProgressIndicator())));
        } else if (state.showProductsBy == ShowProductsBy.underMinimumQuantity && state.listOfProductsUnderMinimumQuantity == null ||
            state.listOfReorders == null) {
          return MyAnimatedExpansionContainer(
              isExpanded: state.isExpandedProducts, child: const SizedBox(height: 400, child: Center(child: MyCircularProgressIndicator())));
        }

        return MyAnimatedExpansionContainer(
          isExpanded: state.isExpandedProducts,
          child: SizedBox(
            height: screenWidth < 400 ? screenWidth : 400,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: state.listOfHomeProducts.length,
              itemBuilder: (context, index) {
                final group = state.listOfHomeProducts[index];

                return Row(
                  children: [
                    if (index != 0 && index != state.listOfHomeProducts.length) ...[
                      Container(
                        decoration: BoxDecoration(border: Border.symmetric(vertical: BorderSide(color: dividerColor, width: 0.7))),
                      ),
                    ],
                    SizedBox(
                      width: 400,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            width: double.infinity,
                            color: CustomColors.ultraLightGrey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Gaps.h8,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    switch (state.groupProductsBy) {
                                      GroupProductsBy.manufacturer => Text.rich(TextSpan(children: [
                                          TextSpan(text: group.manufacturer, style: TextStyles.h3Bold),
                                          const TextSpan(text: ' '),
                                          TextSpan(text: '(${group.listOfProducts.length})', style: TextStyles.h3),
                                        ])),
                                      GroupProductsBy.supplier => Text.rich(TextSpan(children: [
                                          TextSpan(text: group.supplier, style: TextStyles.h3Bold),
                                          const TextSpan(text: ' '),
                                          TextSpan(text: '(${group.listOfProducts.length})', style: TextStyles.h3),
                                        ])),
                                    },
                                    if (state.groupProductsBy == GroupProductsBy.supplier)
                                      InkWell(
                                        onTap: () {},
                                        child: const Icon(Icons.add_shopping_cart_rounded),
                                      ),
                                  ],
                                ),
                                Gaps.h8,
                              ],
                            ),
                          ),
                          Expanded(
                            child: state.groupProductsBy == GroupProductsBy.manufacturer
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: group.listOfProducts.length,
                                    itemBuilder: (context, index2) {
                                      final product = group.listOfProducts[index2];
                                      return InkWell(
                                        onLongPress: () => showMyProductQuickView(context, product),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          color: index2 % 2 == 1 ? CustomColors.ultraLightBlue : Colors.white,
                                          child: Text(product.name),
                                        ),
                                      );
                                    },
                                  )
                                : GroupedListOfSupplierByManufacturer(listOfProducts: group.listOfProducts),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
