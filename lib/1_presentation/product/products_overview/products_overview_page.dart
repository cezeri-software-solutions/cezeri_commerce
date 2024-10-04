import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '/3_domain/entities/marketplace/abstract_marketplace.dart';
import '/3_domain/entities/product/product.dart';
import '/3_domain/entities/product/product_presta.dart';
import '/4_infrastructur/repositories/shopify_api/shopify.dart';
import '/routes/router.gr.dart';
import '../../../2_application/database/product/product_bloc.dart';
import '../../core/core.dart';
import '../widgets/product_profit_text.dart';
import 'widgets/update_product_quantity_dialog.dart';

class ProductOverviewPage extends StatelessWidget {
  final ProductBloc productBloc;

  const ProductOverviewPage({super.key, required this.productBloc});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state.isLoadingProductsOnObserve) return const Expanded(child: Center(child: CircularProgressIndicator()));

        if (state.firebaseFailure != null && state.isAnyFailure) return const Expanded(child: Center(child: Text('Ein Fehler ist aufgetreten!')));

        if (state.listOfAllProducts == null) return const Expanded(child: Center(child: CircularProgressIndicator()));

        if (state.listOfAllProducts!.isEmpty) return const Expanded(child: Center(child: Text('Es konnten keine Artikel gefunden werden.')));

        double totalWarehouseStockAmount =
            state.listOfAllProducts!.fold(0.0, (previousValue, product) => previousValue + (product.netPrice * product.warehouseStock));
        logger.i(totalWarehouseStockAmount.toMyCurrencyStringToShow());
        double totalWarehouseStockWholesaleAmount =
            state.listOfAllProducts!.fold(0.0, (previousValue, product) => previousValue + (product.wholesalePrice * product.warehouseStock));
        logger.i(totalWarehouseStockWholesaleAmount.toMyCurrencyStringToShow());

        return Expanded(
          child: Scrollbar(
            child: ListView.separated(
              itemCount: state.listOfFilteredProducts!.length,
              separatorBuilder: (context, index) => const Divider(indent: 45, endIndent: 20),
              itemBuilder: (context, index) {
                if (ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET)) {
                  return _ProductContainer(product: state.listOfFilteredProducts![index], index: index, productBloc: productBloc);
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: (screenWidth + 640) - 390,
                    child: _ProductContainer(product: state.listOfFilteredProducts![index], index: index, productBloc: productBloc),
                  ),
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
  final ProductBloc productBloc;

  const _ProductContainer({required this.product, required this.index, required this.productBloc});

  @override
  Widget build(BuildContext context) {
    final isTabletOrLarger = ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET);

    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox.adaptive(
                  value: state.selectedProducts.any((e) => e.id == product.id),
                  onChanged: (_) => productBloc.add(OnProductSelectedEvent(product: product)),
                ),
                SizedBox(
                  width: isTabletOrLarger ? RWPP.picture : RWMBPP.picture,
                  child: MyAvatar(
                    name: product.name,
                    imageUrl: product.listOfProductImages.isNotEmpty ? product.listOfProductImages.where((e) => e.isDefault).first.fileUrl : null,
                    radius: isTabletOrLarger ? 35 : 30,
                    fontSize: isTabletOrLarger ? 25 : 20,
                    fit: BoxFit.scaleDown,
                    shape: BoxShape.rectangle,
                    onTap: product.listOfProductImages.isNotEmpty
                        ? () => context.router.push(MyFullscreenImageRoute(
                            imagePaths: product.listOfProductImages.map((e) => e.fileUrl).toList(), initialIndex: 0, isNetworkImage: true))
                        : null,
                  ),
                ),
                isTabletOrLarger ? Gaps.w16 : Gaps.w8,
                _ProductInfoBar(productBloc: productBloc, product: product),
                Gaps.w16,
                if (isTabletOrLarger) _PricesBar(product: product) else _StockBar(productBloc: productBloc, product: product),
                isTabletOrLarger ? Gaps.w16 : Gaps.w8,
                if (isTabletOrLarger) _StockBar(productBloc: productBloc, product: product) else _PricesBar(product: product),
                Gaps.w16,
                _MarketplacesBar(product: product),
              ],
            ),
            if (product.specificPrice != null) ...[
              Padding(
                padding: const EdgeInsets.only(left: 60, right: 16),
                child: Badge(
                  label: const Text('SALE'),
                  backgroundColor: Colors.red.withOpacity(0.8),
                ),
              )
            ],
          ],
        );
      },
    );
  }
}

Color? getTextButtonColor(Product product) {
  if (!product.isActive) return null;
  if (product.isOutlet && product.warehouseStock <= 0) return Colors.red;
  if (product.isOutlet) return Colors.orange;
  return null;
}

class _ProductInfoBar extends StatelessWidget {
  final ProductBloc productBloc;
  final Product product;

  const _ProductInfoBar({required this.productBloc, required this.product});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text.rich(
                    TextSpan(children: [
                      TextSpan(text: product.articleNumber),
                      if (product.isActive == false) ...[
                        const TextSpan(text: '  '),
                        TextSpan(text: 'Inaktiv', style: TextStyles.defaultBold.copyWith(color: Colors.red)),
                      ],
                    ]),
                    overflow: TextOverflow.ellipsis),
              ),
              Gaps.w8,
              if (product.isSetArticle)
                InkWell(
                  onTap: () => showMySetProductQuickView(context: context, productId: product.id),
                  child: const Icon(Icons.layers, size: 18, color: CustomColors.primaryColor),
                ),
              Gaps.w8,
              if (product.listOfIsPartOfSetIds.isNotEmpty)
                InkWell(
                  onTap: () => showMyPartOfSetProductQuickView(context: context, productId: product.id),
                  child: const Icon(Icons.group_work, size: 18, color: CustomColors.primaryColor),
                ),
            ],
          ),
          TextButton(
            onPressed: () async {
              await context.router.push(ProductDetailRoute(productId: product.id));
              productBloc.add(GetProductEvent(id: product.id));
            },
            onLongPress: () => showMyProductQuickView(context: context, product: product, showStatProduct: true),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: getTextButtonColor(product),
            ),
            child: Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
          Text('EAN: ${product.ean}'),
        ],
      ),
    );
  }
}

class _PricesBar extends StatelessWidget {
  final Product product;

  const _PricesBar({required this.product});

  @override
  Widget build(BuildContext context) {
    final isTabletOrLarger = ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET);

    return SizedBox(
      width: isTabletOrLarger ? RWPP.prices : RWMBPP.prices,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('EK: ${product.wholesalePrice.toMyCurrencyStringToShow()}'),
          Text('VK-Netto: ${product.netPrice.toMyCurrencyStringToShow()}'),
          Text('VK-Brutto: ${product.grossPrice.toMyCurrencyStringToShow()}'),
          ProductProfitText(netPrice: product.netPrice, wholesalePrice: product.wholesalePrice),
        ],
      ),
    );
  }
}

class _StockBar extends StatelessWidget {
  final ProductBloc productBloc;
  final Product product;

  const _StockBar({required this.productBloc, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(product.warehouseStock.toString()),
        TextButton(
          onPressed: () {
            if (product.isSetArticle) {
              showMyDialogAlert(
                context: context,
                title: 'Achtung',
                content: 'Der Bestand von Set-Artikel wird automatisch über dessen Einzelteile bestimmt und kann nicht manuell abgeändert werden',
              );
              return;
            }

            WoltModalSheet.show(
              context: context,
              useSafeArea: false,
              pageListBuilder: (woltContext) {
                return [
                  WoltModalSheetPage(
                    hasTopBarLayer: false,
                    isTopBarLayerAlwaysVisible: false,
                    child: UpdateProductQuantityDialog(productBloc: productBloc, product: product),
                  ),
                ];
              },
            );
          },
          child: Text(product.availableStock.toString()),
        ),
      ],
    );
  }
}

class _MarketplacesBar extends StatelessWidget {
  final Product product;

  const _MarketplacesBar({required this.product});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
    );
  }
}
