import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/database/reorder_detail/reorder_detail_bloc.dart';
import '../../../../3_domain/entities/product/product.dart';
import '../../../../3_domain/entities/statistic/product_sales_data.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';

class SelectReorderDetailProductDialog extends StatelessWidget {
  final ReorderDetailBloc reorderDetailBloc;
  final double screenHeight;
  final double screenWidth;

  const SelectReorderDetailProductDialog({super.key, required this.reorderDetailBloc, required this.screenHeight, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReorderDetailBloc, ReorderDetailState>(
      bloc: reorderDetailBloc,
      builder: (context, state) {
        if (state.listOfProducts == null) reorderDetailBloc.add(OnReorderDetailGetProductsEvent());

        if (state.firebaseFailure != null && state.isAnyFailure) {
          return Dialog(child: SizedBox(width: 600, height: 1200, child: Center(child: Text(state.firebaseFailure.toString()))));
        }
        if (state.isLoadingOnObserveReorderDetailProducts || state.listOfProducts == null) {
          return const Dialog(child: SizedBox(width: 600, height: 1200, child: Center(child: CircularProgressIndicator())));
        }

        List<Product> productList = state.listOfFilteredProducts!;

        return Dialog(
          child: SizedBox(
            height: screenHeight > 1200 ? 1200 : screenHeight,
            width: screenWidth > 1000 ? 1000 : screenWidth,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: CupertinoSearchTextField(
                              controller: state.productSearchController,
                              onChanged: (value) => reorderDetailBloc.add(OnReorderDetailSetFilteredProductsEvent()),
                              onSuffixTap: () => reorderDetailBloc.add(OnReorderDetailProductSearchTextClearedEvent()),
                            ),
                          ),
                          Gaps.w8,
                          Text(state.reorder!.totalPriceNet.toMyCurrencyStringToShow()),
                        ],
                      ),
                      Gaps.h10,
                      if (state.statProductDateRange != null)
                        Row(
                          children: [
                            const Text('Legende:', style: TextStyles.defaultBold),
                            Gaps.w24,
                            Tooltip(
                              message: 'Verpackungseinheit',
                              child: InkWell(
                                  onLongPress: () {
                                    for (final reProduct in productList) {
                                      final ve = reProduct.packagingUnitOnReorder;
                                      reorderDetailBloc.add(OnReorderDeatilAddProductEvent(product: reProduct, quantity: ve));
                                    }
                                  },
                                  child: const RecommendedReorderQuantity(title: 'VE:', quantity: 0, color: CustomColors.ultraLightGreen)),
                            ),
                            Gaps.w24,
                            Tooltip(
                              message: 'Empfohlene Bestellmenge nach erstelleten Rechnungen',
                              child: InkWell(
                                  onLongPress: () {
                                    for (final reProduct in productList) {
                                      ProductSalesData? salesData =
                                          state.listOfProductSalesData?.where((e) => e.productId == reProduct.id).firstOrNull;
                                      salesData ??= ProductSalesData.empty();
                                      final ebmPerRe = _getRecommendedOrderQuantity(
                                        salesData.totalQuantity,
                                        reProduct.minimumStock,
                                        reProduct.minimumReorderQuantity,
                                        reProduct.warehouseStock,
                                      );
                                      reorderDetailBloc.add(OnReorderDeatilAddProductEvent(product: reProduct, quantity: ebmPerRe));
                                    }
                                  },
                                  child: const RecommendedReorderQuantity(title: 'EBM/RE:', quantity: 0, color: CustomColors.ultraLightYellow)),
                            ),
                            Gaps.w24,
                            Tooltip(
                              message: 'Empfohlene Bestellmenge nach Auftragseingang',
                              child: InkWell(
                                  onLongPress: () {
                                    for (final reProduct in productList) {
                                      ProductSalesData? salesDataInklApp =
                                          state.listOfProductSalesDataInklOpen?.where((e) => e.productId == reProduct.id).firstOrNull;
                                      salesDataInklApp ??= ProductSalesData.empty();
                                      final ebmPerAe = _getRecommendedOrderQuantity(
                                        salesDataInklApp.totalQuantity,
                                        reProduct.minimumStock,
                                        reProduct.minimumReorderQuantity,
                                        reProduct.availableStock,
                                      );
                                      reorderDetailBloc.add(OnReorderDeatilAddProductEvent(product: reProduct, quantity: ebmPerAe));
                                    }
                                  },
                                  child: const RecommendedReorderQuantity(title: 'EBM/AE:', quantity: 0, color: CustomColors.ultraLightOrange2)),
                            ),
                            Gaps.w24,
                            Tooltip(
                              message: 'Empfohlene Bestellmenge nach Rechnungen in Verpackungseinheit',
                              child: InkWell(
                                  onLongPress: () {
                                    for (final reProduct in productList) {
                                      ProductSalesData? salesData =
                                          state.listOfProductSalesData?.where((e) => e.productId == reProduct.id).firstOrNull;
                                      salesData ??= ProductSalesData.empty();
                                      final ebmPerRe = _getRecommendedOrderQuantity(
                                        salesData.totalQuantity,
                                        reProduct.minimumStock,
                                        reProduct.minimumReorderQuantity,
                                        reProduct.warehouseStock,
                                      );
                                      final ebmPerReVe = _getRecommendedOrderQuantityByPackagingUnit(ebmPerRe, reProduct.packagingUnitOnReorder);
                                      reorderDetailBloc.add(OnReorderDeatilAddProductEvent(product: reProduct, quantity: ebmPerReVe));
                                    }
                                  },
                                  child: const RecommendedReorderQuantity(title: 'EBM/RE/VE:', quantity: 0, color: CustomColors.ultraLightRed)),
                            ),
                            Gaps.w24,
                            Tooltip(
                              message: 'Empfohlene Bestellmenge nach Auftagseingang in Verpackungseinheit',
                              child: InkWell(
                                  onLongPress: () {
                                    for (final reProduct in productList) {
                                      ProductSalesData? salesDataInklApp =
                                          state.listOfProductSalesDataInklOpen?.where((e) => e.productId == reProduct.id).firstOrNull;
                                      salesDataInklApp ??= ProductSalesData.empty();
                                      final ebmPerAe = _getRecommendedOrderQuantity(
                                        salesDataInklApp.totalQuantity,
                                        reProduct.minimumStock,
                                        reProduct.minimumReorderQuantity,
                                        reProduct.availableStock,
                                      );
                                      final ebmPerAeVe = _getRecommendedOrderQuantityByPackagingUnit(ebmPerAe, reProduct.packagingUnitOnReorder);
                                      reorderDetailBloc.add(OnReorderDeatilAddProductEvent(product: reProduct, quantity: ebmPerAeVe));
                                    }
                                  },
                                  child: const RecommendedReorderQuantity(title: 'EBM/AE/VE:', quantity: 0, color: CustomColors.ultraLightRed)),
                            ),
                            const Spacer(),
                            Text(state.listOfProducts!.length.toString()),
                          ],
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: productList.length,
                    itemBuilder: ((context, index) {
                      final product = productList[index];
                      ProductSalesData? salesData = state.listOfProductSalesData?.where((e) => e.productId == product.id).firstOrNull;
                      salesData ??= ProductSalesData.empty();
                      ProductSalesData? salesDataInklApp = state.listOfProductSalesDataInklOpen?.where((e) => e.productId == product.id).firstOrNull;
                      salesDataInklApp ??= ProductSalesData.empty();
                      final inListProduct = state.reorder!.listOfReorderProducts.where((e) => e.productId == product.id).firstOrNull;

                      final ve = product.packagingUnitOnReorder;
                      final ebmPerRe = _getRecommendedOrderQuantity(
                        salesData.totalQuantity,
                        product.minimumStock,
                        product.minimumReorderQuantity,
                        product.warehouseStock,
                      );
                      final ebmPerAe = _getRecommendedOrderQuantity(
                        salesDataInklApp.totalQuantity,
                        product.minimumStock,
                        product.minimumReorderQuantity,
                        product.availableStock,
                      );
                      final ebmPerReVe = _getRecommendedOrderQuantityByPackagingUnit(ebmPerRe, product.packagingUnitOnReorder);
                      final ebmPerAeVe = _getRecommendedOrderQuantityByPackagingUnit(ebmPerAe, product.packagingUnitOnReorder);

                      return Column(
                        children: [
                          if (index == 0) Gaps.h10,
                          ListTile(
                            leading: SizedBox(
                              width: 40,
                              child: MyAvatar(
                                name: product.name,
                                imageUrl: product.listOfProductImages.isNotEmpty
                                    ? product.listOfProductImages.where((e) => e.isDefault).first.fileUrl
                                    : null,
                                radius: 20,
                                fontSize: 16,
                              ),
                            ),
                            title: Text('${product.articleNumber} / ${product.name}', style: TextStyles.defaultt),
                            subtitle: state.statProductDateRange != null
                                ? Row(
                                    children: [
                                      InkWell(
                                        onTap: () => showMyProductQuickView(context: context, product: product, showStatProduct: true),
                                        child: Text(
                                          '${salesData.totalQuantity} / ${salesDataInklApp.totalQuantity}',
                                          style: TextStyles.s13Bold,
                                        ),
                                      ),
                                      Gaps.w16,
                                      InkWell(
                                        onTap: () => reorderDetailBloc.add(OnReorderDeatilAddProductEvent(product: product, quantity: ve)),
                                        onLongPress: () {
                                          reorderDetailBloc.add(OnReorderDetailControllerClearedEvent());
                                          context.router.pop();
                                          reorderDetailBloc.add(OnReorderDeatilAddProductEvent(product: product, quantity: ve));
                                        },
                                        child: RecommendedReorderQuantity(
                                          title: 'VE:',
                                          quantity: ve,
                                          color: CustomColors.ultraLightGreen,
                                        ),
                                      ),
                                      Gaps.w16,
                                      InkWell(
                                        onTap: () => reorderDetailBloc.add(OnReorderDeatilAddProductEvent(product: product, quantity: ebmPerRe)),
                                        onLongPress: () {
                                          reorderDetailBloc.add(OnReorderDetailControllerClearedEvent());
                                          context.router.pop();
                                          reorderDetailBloc.add(OnReorderDeatilAddProductEvent(product: product, quantity: ebmPerRe));
                                        },
                                        child: RecommendedReorderQuantity(
                                          title: 'EBM/RE:',
                                          quantity: ebmPerRe,
                                          color: CustomColors.ultraLightYellow,
                                        ),
                                      ),
                                      Gaps.w16,
                                      InkWell(
                                        onTap: () => reorderDetailBloc.add(OnReorderDeatilAddProductEvent(product: product, quantity: ebmPerAe)),
                                        onLongPress: () {
                                          reorderDetailBloc.add(OnReorderDetailControllerClearedEvent());
                                          context.router.pop();
                                          reorderDetailBloc.add(OnReorderDeatilAddProductEvent(product: product, quantity: ebmPerAe));
                                        },
                                        child: RecommendedReorderQuantity(
                                          title: 'EBM/AE:',
                                          quantity: ebmPerAe,
                                          color: CustomColors.ultraLightOrange2,
                                        ),
                                      ),
                                      Gaps.w16,
                                      InkWell(
                                        onTap: () => reorderDetailBloc.add(OnReorderDeatilAddProductEvent(product: product, quantity: ebmPerReVe)),
                                        onLongPress: () {
                                          reorderDetailBloc.add(OnReorderDetailControllerClearedEvent());
                                          context.router.pop();
                                          reorderDetailBloc.add(OnReorderDeatilAddProductEvent(product: product, quantity: ebmPerReVe));
                                        },
                                        child: RecommendedReorderQuantity(
                                          title: 'EBM/RE/VE:',
                                          quantity: ebmPerReVe,
                                          color: CustomColors.ultraLightRed,
                                        ),
                                      ),
                                      Gaps.w16,
                                      InkWell(
                                        onTap: () => reorderDetailBloc.add(OnReorderDeatilAddProductEvent(product: product, quantity: ebmPerAeVe)),
                                        onLongPress: () {
                                          reorderDetailBloc.add(OnReorderDetailControllerClearedEvent());
                                          context.router.pop();
                                          reorderDetailBloc.add(OnReorderDeatilAddProductEvent(product: product, quantity: ebmPerAeVe));
                                        },
                                        child: RecommendedReorderQuantity(
                                          title: 'EBM/AE/VE:',
                                          quantity: ebmPerAeVe,
                                          color: CustomColors.ultraLightRed,
                                        ),
                                      ),
                                      Gaps.w16,
                                      if (inListProduct != null && inListProduct.quantity != 0)
                                        Text(
                                          inListProduct.quantity.toString(),
                                          style: TextStyles.defaultBold.copyWith(color: Colors.green),
                                        ),
                                    ],
                                  )
                                : inListProduct != null && inListProduct.quantity != 0
                                    ? Text(
                                        inListProduct.quantity.toString(),
                                        style: TextStyles.defaultBold.copyWith(color: Colors.green),
                                      )
                                    : null,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                product.availableStock == product.warehouseStock
                                    ? Text('${product.availableStock} / ${product.warehouseStock}', style: TextStyles.h3Bold)
                                    : Text.rich(
                                        TextSpan(
                                          style: TextStyles.h3Bold,
                                          children: [
                                            TextSpan(text: '${product.availableStock}', style: const TextStyle(color: Colors.orange)),
                                            TextSpan(text: ' / ${product.warehouseStock}'),
                                          ],
                                        ),
                                      ),
                                Gaps.w16,
                                InkWell(
                                  onLongPress: () => showDialog(
                                    context: context,
                                    builder: (_) => BlocProvider.value(
                                      value: reorderDetailBloc,
                                      child: _QuantityDialog(
                                        reorderDetailBloc: reorderDetailBloc,
                                        product: product,
                                      ),
                                    ),
                                  ),
                                  onTap: () => reorderDetailBloc.add(OnReorderDeatilAddProductEvent(product: product, quantity: 1)),
                                  child: const Icon(Icons.add, color: Colors.green),
                                ),
                                Gaps.w8,
                                InkWell(
                                  onLongPress: () => showDialog(
                                    context: context,
                                    builder: (_) => BlocProvider.value(
                                      value: reorderDetailBloc,
                                      child: _QuantityDialog(
                                        reorderDetailBloc: reorderDetailBloc,
                                        product: product,
                                      ),
                                    ),
                                  ),
                                  onTap: () => reorderDetailBloc.add(OnReorderDeatilAddProductEvent(product: product, quantity: -1)),
                                  child: const Icon(Icons.remove, color: CustomColors.primaryColor),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 0),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  int _getRecommendedOrderQuantity(int unitsSold, int minimumStock, int minimumReorderQuantity, int quantity) {
    int reorderQuantity = unitsSold - quantity + minimumStock;
    int realReorderQuantity = 0;
    if (reorderQuantity <= 0) {
      realReorderQuantity = 0;
    } else {
      realReorderQuantity = reorderQuantity > minimumReorderQuantity ? reorderQuantity : minimumReorderQuantity;
    }
    return realReorderQuantity > 0 ? realReorderQuantity : 0; // Vermeidung von negativen Werten
  }

  int _getRecommendedOrderQuantityByPackagingUnit(int recommendedQuantity, int packagingUnit) {
    return (recommendedQuantity + packagingUnit - 1) ~/ packagingUnit * packagingUnit;
  }
}

class _QuantityDialog extends StatelessWidget {
  final ReorderDetailBloc reorderDetailBloc;
  final Product product;

  const _QuantityDialog({required this.reorderDetailBloc, required this.product});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final controller = TextEditingController();

    return Dialog(
      child: SizedBox(
        width: screenWidth > 600 ? 600 : screenWidth,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Anzahl', style: TextStyles.h1),
              Gaps.h24,
              Text(product.name),
              Gaps.h8,
              Text(product.articleNumber),
              Gaps.h32,
              MyTextFormFieldSmallDouble(
                maxWidth: 100,
                controller: controller,
                onFieldSubmitted: (value) {
                  context.router.pop();
                  reorderDetailBloc.add(OnReorderDeatilAddProductEvent(product: product, quantity: value.toMyInt()));
                },
              ),
              Gaps.h24,
              MyOutlinedButton(
                buttonText: 'Übernehmen',
                onPressed: () {
                  context.router.pop();
                  reorderDetailBloc.add(OnReorderDeatilAddProductEvent(product: product, quantity: controller.text.toMyInt()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
