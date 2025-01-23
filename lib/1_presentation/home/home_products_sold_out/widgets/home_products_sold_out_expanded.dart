import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/database/home/home_product/home_product_bloc.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';
import '../functions/get_reordered_quantity.dart';
import 'grouped_list_of_supplier_by_manufacturer.dart';
import 'home_product_name_widget.dart';

class HomeProductsSoldOutExpanded extends StatelessWidget {
  final HomeProductBloc homeProductBloc;

  const HomeProductsSoldOutExpanded({super.key, required this.homeProductBloc});

  @override
  Widget build(BuildContext context) {
    final dividerColor = Theme.of(context).dividerColor;
    final screenWidth = context.screenWidth;
    final screenHeight = context.screenHeight;
    final expandedHeight = screenHeight / 3;

    return BlocBuilder<HomeProductBloc, HomeProductState>(
      builder: (context, state) {
        if (state.isLoadingHomeProductsOnObserve || state.isLoadingHomeReordersOnObserve) {
          return MyAnimatedExpansionContainer(
              isExpanded: state.isExpandedProductsSoldOut,
              child: SizedBox(height: expandedHeight, child: const Center(child: MyCircularProgressIndicator())));
        } else if (state.firebaseFailure != null && state.isAnyFailure) {
          return MyAnimatedExpansionContainer(
              isExpanded: state.isExpandedProductsSoldOut,
              child: SizedBox(height: expandedHeight, child: const Center(child: Text('Beim Laden der Daten ist ein Fehler aufgetreten'))));
        } else if (state.showProductsBy == ShowProductsBy.soldOut && state.listOfProductsSoldOut == null || state.listOfReorders == null) {
          return MyAnimatedExpansionContainer(
              isExpanded: state.isExpandedProductsSoldOut,
              child: SizedBox(height: expandedHeight, child: const Center(child: MyCircularProgressIndicator())));
        } else if (state.showProductsBy == ShowProductsBy.underMinimumQuantity && state.listOfProductsUnderMinimumQuantity == null ||
            state.listOfReorders == null) {
          return MyAnimatedExpansionContainer(
              isExpanded: state.isExpandedProductsSoldOut,
              child: SizedBox(height: expandedHeight, child: const Center(child: MyCircularProgressIndicator())));
        }

        return MyAnimatedExpansionContainer(
          isExpanded: state.isExpandedProductsSoldOut,
          child: SizedBox(
            height: expandedHeight,
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
                      width: screenWidth < 400 ? screenWidth : 400,
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
                                      GroupProductsBy.supplier => Expanded(
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(text: group.supplier, style: TextStyles.h3Bold),
                                                const TextSpan(text: ' '),
                                                TextSpan(text: '(${group.listOfProducts.length})', style: TextStyles.h3),
                                              ],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                    },
                                    if (state.groupProductsBy == GroupProductsBy.supplier)
                                      InkWell(
                                        onTap: () async => _showDateRangePicker(context, homeProductBloc, group.supplier),
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
                                      final reorderedQuantity = getReorderedQuantity(product, state.listOfReorders);

                                      return HomeProductNameWidget(product: product, index: index2, reorderedQuantity: reorderedQuantity);
                                    },
                                  )
                                : GroupedListOfSupplierByManufacturer(listOfProducts: group.listOfProducts, listOfReorders: state.listOfReorders),
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

  Future<void> _showDateRangePicker(BuildContext context, HomeProductBloc homeProductBloc, String supplierName) async {
    final now = DateTime.now();

    final newDateRange = await showDateRangePicker(context: context, firstDate: DateTime(now.year - 1), lastDate: now);

    if (context.mounted && newDateRange != null) {
      showDialog(context: context, builder: (context) => _CreateReorderDialog(supplierName: supplierName, dateRange: newDateRange));
    }
  }
}

class _CreateReorderDialog extends StatelessWidget {
  final String supplierName;
  final DateTimeRange dateRange;

  const _CreateReorderDialog({required this.supplierName, required this.dateRange});

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.screenWidth;
    return Dialog(
      child: SizedBox(
        width: screenWidth > 700 ? 1000 : screenWidth,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(padding: EdgeInsets.all(8), child: Text('Nachbestellung nach:', style: TextStyles.h2Bold)),
            ListTile(
              leading: SizedBox(width: 80, child: RecommendedReorderQuantity(title: 'VE:', quantity: 0, color: CustomColors.ultraLightGreen)),
              title: Text('Verpackungseinheit'),
            ),
            ListTile(
              leading: SizedBox(width: 80, child: RecommendedReorderQuantity(title: 'EBM/RE:', quantity: 0, color: CustomColors.ultraLightYellow)),
              title: Text('Empfohlene Bestellmenge nach erstelleten Rechnungen'),
            ),
            ListTile(
              leading: SizedBox(width: 80, child: RecommendedReorderQuantity(title: 'EBM/AE:', quantity: 0, color: CustomColors.ultraLightOrange2)),
              title: Text('Empfohlene Bestellmenge nach Auftragseingang'),
            ),
            ListTile(
              leading: SizedBox(width: 80, child: RecommendedReorderQuantity(title: 'EBM/VE:', quantity: 0, color: CustomColors.ultraLightRed)),
              title: Text('Empfohlene Bestellmenge nach Verpackungseinheit'),
            ),
          ],
        ),
      ),
    );
  }
}
