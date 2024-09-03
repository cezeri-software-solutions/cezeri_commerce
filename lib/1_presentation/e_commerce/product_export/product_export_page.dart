import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../2_application/marketplace/product_export/bloc/product_export_bloc.dart';
import '../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../3_domain/entities/product/product_presta.dart';
import '../../../4_infrastructur/repositories/shopify_api/shopify.dart';
import '../../../constants.dart';
import '../../../routes/router.gr.dart';
import '../../core/core.dart';

class ProductExportPage extends StatelessWidget {
  final ProductExportBloc productExportBloc;

  const ProductExportPage({super.key, required this.productExportBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductExportBloc, ProductExportState>(
      builder: (context, state) {
        if (state.isLoadingProductsOnObserve) {
          return const Expanded(child: Center(child: CircularProgressIndicator()));
        }

        if (state.firebaseFailure != null) {
          return const Expanded(child: Center(child: Text('Ein Fehler ist aufgetreten!')));
        }

        if (state.listOfAllProducts == null) {
          return const Expanded(child: Center(child: CircularProgressIndicator()));
        }

        if (state.listOfAllProducts!.isEmpty) {
          return const Expanded(child: Center(child: Text('Es konnten keine Artikel gefunden werden.')));
        }

        return Expanded(
          child: Scrollbar(
            child: ListView.builder(
              itemCount: state.listOfFilteredProducts!.length,
              itemBuilder: (context, index) {
                final curProduct = state.listOfFilteredProducts![index];
                if (index == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox.adaptive(
                        value: state.isSelectedAllProducts,
                        onChanged: (value) => productExportBloc.add(OnSelectedAllProductsChangedEvent(isSelected: value!)),
                      ),
                      _ProductContainer(product: curProduct, index: index, productExportBloc: productExportBloc),
                      const Divider(),
                    ],
                  );
                }

                return Column(
                  children: [
                    _ProductContainer(product: curProduct, index: index, productExportBloc: productExportBloc),
                    const Divider(),
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

class _ProductContainer extends StatelessWidget {
  final Product product;
  final int index;
  final ProductExportBloc productExportBloc;

  const _ProductContainer({required this.product, required this.index, required this.productExportBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductExportBloc, ProductExportState>(
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox.adaptive(
                value: state.selectedProducts.any((e) => e.id == product.id),
                onChanged: (_) => productExportBloc.add(OnProductSelectedEvent(selectedProduct: product)),
              ),
              SizedBox(
                width: ResponsiveBreakpoints.of(context).isTablet ? 70 : 60,
                child: MyAvatar(
                  name: product.name,
                  imageUrl: product.listOfProductImages.isNotEmpty ? product.listOfProductImages.where((e) => e.isDefault).first.fileUrl : null,
                  radius: ResponsiveBreakpoints.of(context).isTablet ? 35 : 30,
                  fontSize: ResponsiveBreakpoints.of(context).isTablet ? 25 : 20,
                  shape: BoxShape.rectangle,
                  onTap: product.listOfProductImages.isNotEmpty
                      ? () => context.router.push(MyFullscreenImageRoute(
                          imagePaths: product.listOfProductImages.map((e) => e.fileUrl).toList(), initialIndex: 0, isNetworkImage: true))
                      : null,
                ),
              ),
              ResponsiveBreakpoints.of(context).isTablet ? Gaps.w16 : Gaps.w8,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text.rich(TextSpan(children: [
                          TextSpan(text: product.articleNumber),
                          if (product.isActive == false) ...[
                            const TextSpan(text: '  '),
                            TextSpan(text: 'Inaktiv', style: TextStyles.defaultBold.copyWith(color: Colors.red)),
                          ],
                        ])),
                        Gaps.w8,
                        if (product.isSetArticle)
                          InkWell(
                            onTap: () {
                              final productList =
                                  state.listOfAllProducts!.where((e) => product.listOfProductIdWithQuantity.any((f) => f.productId == e.id)).toList();
                              showMyDialogProducts(context: context, productsList: productList);
                            },
                            child: const Icon(Icons.layers, size: 18, color: CustomColors.primaryColor),
                          ),
                        Gaps.w8,
                        if (product.listOfIsPartOfSetIds.isNotEmpty)
                          InkWell(
                            onTap: () {
                              final productList = state.listOfAllProducts!.where((e) => product.listOfIsPartOfSetIds.contains(e.id)).toList();
                              showMyDialogProducts(context: context, productsList: productList);
                            },
                            child: const Icon(Icons.group_work, size: 18, color: CustomColors.primaryColor),
                          ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      onLongPress: () => showMyProductQuickView(context: context, product: product, showStatProduct: true),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      child: Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis),
                    ),
                    Text('EAN: ${product.ean}'),
                  ],
                ),
              ),
              if (ResponsiveBreakpoints.of(context).isTablet) ...[
                Gaps.w16,
                SizedBox(
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('EK: ${product.wholesalePrice.toMyCurrencyStringToShow()}'),
                      Text('VK-Netto: ${product.netPrice.toMyCurrencyStringToShow()}'),
                      Text('VK-Brutto: ${product.grossPrice.toMyCurrencyStringToShow()}'),
                      Text.rich(TextSpan(children: [
                        TextSpan(
                          text: (product.netPrice - product.wholesalePrice).toMyCurrencyStringToShow(),
                          style: TextStyles.defaultBold.copyWith(color: Colors.green),
                        ),
                        if (product.wholesalePrice != 0 && product.netPrice != 0) ...[
                          const TextSpan(text: ' | ', style: TextStyles.defaultBold),
                          TextSpan(
                            text: ((1 - (product.wholesalePrice / product.netPrice)) * 100).toMyCurrencyStringToShow(),
                            style: TextStyles.defaultBold.copyWith(color: CustomColors.primaryColor),
                          ),
                          TextSpan(text: '%', style: TextStyles.defaultBold.copyWith(color: CustomColors.primaryColor))
                        ],
                      ]))
                    ],
                  ),
                ),
              ],
              ResponsiveBreakpoints.of(context).isTablet ? Gaps.w16 : Gaps.w8,
              Column(
                children: [
                  Text(product.warehouseStock.toString()),
                  TextButton(onPressed: () {}, child: Text(product.availableStock.toString())),
                ],
              ),
              if (ResponsiveBreakpoints.of(context).isTablet) ...[
                Gaps.w16,
                SizedBox(
                  height: 80,
                  width: 100,
                  child: ListView.builder(
                    itemCount: product.productMarketplaces.length,
                    itemBuilder: (context, index) {
                      final productMarketplace = product.productMarketplaces[index];
                      final style = switch (productMarketplace.marketplaceProduct!.marketplaceType) {
                        MarketplaceType.prestashop => (productMarketplace.marketplaceProduct as ProductPresta).active == '0'
                            ? TextStyles.defaultBold.copyWith(color: Colors.red)
                            : TextStyles.defaultBold.copyWith(color: Colors.green),
                        MarketplaceType.shopify => (productMarketplace.marketplaceProduct as ProductShopify).status != ProductShopifyStatus.active
                            ? TextStyles.defaultBold.copyWith(color: Colors.red)
                            : TextStyles.defaultBold.copyWith(color: Colors.green),
                        MarketplaceType.shop => throw Exception('SHOP not implemented'),
                      };
                      return Row(
                        children: [
                          SizedBox(
                            height: 15,
                            width: 15,
                            child: SvgPicture.asset(getMarketplaceLogoAsset(productMarketplace.marketplaceProduct!.marketplaceType)),
                          ),
                          Gaps.w4,
                          Text(productMarketplace.shortNameMarketplace, style: style),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
