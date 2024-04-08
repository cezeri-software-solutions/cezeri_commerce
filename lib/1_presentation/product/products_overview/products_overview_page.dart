import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:cezeri_commerce/1_presentation/core/widgets/my_outlined_button.dart';
import 'package:cezeri_commerce/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../core/functions/dialogs.dart';
import '../../core/functions/mixed_functions.dart';
import '../../core/functions/show_my_product_quick_view.dart';
import '../../core/widgets/my_avatar.dart';
import '/2_application/firebase/product/product_bloc.dart';
import '/3_domain/entities/marketplace/abstract_marketplace.dart';
import '/3_domain/entities/product/product.dart';
import '/3_domain/entities/product/product_presta.dart';
import '/4_infrastructur/repositories/shopify_api/shopify.dart';
import '/routes/router.gr.dart';

final logger = Logger();

class ProductOverviewPage extends StatelessWidget {
  final ProductBloc productBloc;

  const ProductOverviewPage({super.key, required this.productBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state.isLoadingProductsOnObserve) {
          return const Expanded(child: Center(child: CircularProgressIndicator()));
        }

        if (state.firebaseFailure != null && state.isAnyFailure) {
          return const Expanded(child: Center(child: Text('Ein Fehler ist aufgetreten!')));
        }

        if (state.listOfAllProducts == null) {
          return const Expanded(child: Center(child: CircularProgressIndicator()));
        }

        if (state.listOfAllProducts!.isEmpty) {
          return const Expanded(child: Center(child: Text('Es konnten keine Artikel gefunden werden.')));
        }

        double totalWarehouseStockAmount =
            state.listOfAllProducts!.fold(0.0, (previousValue, product) => previousValue + (product.netPrice * product.warehouseStock));
        logger.i(totalWarehouseStockAmount.toMyCurrencyStringToShow());
        double totalWarehouseStockWholesaleAmount =
            state.listOfAllProducts!.fold(0.0, (previousValue, product) => previousValue + (product.wholesalePrice * product.warehouseStock));
        logger.i(totalWarehouseStockWholesaleAmount.toMyCurrencyStringToShow());

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
                        onChanged: (value) => productBloc.add(OnProductIsSelectedAllChangedEvent(isSelected: value!)),
                      ),
                      _ProductContainer(product: curProduct, index: index, productBloc: productBloc),
                      const Divider(),
                    ],
                  );
                }

                return Column(
                  children: [
                    _ProductContainer(product: curProduct, index: index, productBloc: productBloc),
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
  final ProductBloc productBloc;

  const _ProductContainer({required this.product, required this.index, required this.productBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Checkbox.adaptive(
                value: state.selectedProducts.any((e) => e.id == product.id),
                onChanged: (_) => productBloc.add(OnProductSelectedEvent(product: product)),
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
                      onPressed: () async {
                        await context.router.push(ProductDetailRoute(productId: product.id, listOfProducts: state.listOfAllProducts!));
                        productBloc.add(GetProductEvent(id: product.id));
                      },
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
                  TextButton(
                      onPressed: () => product.isSetArticle
                          ? showMyDialogAlert(
                              context: context,
                              title: 'Achtung',
                              content:
                                  'Der Bestand von Set-Artikel wird automatisch über dessen Einzelteile bestimmt und kann nicht manuell abgeändert werden')
                          : showDialog(
                              context: context,
                              builder: (_) => BlocProvider.value(value: productBloc, child: _UpdateProductQuantityDialog(product: product)),
                            ),
                      child: Text(product.availableStock.toString())),
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

enum QuantityUpdateWay { edit, set }

class _UpdateProductQuantityDialog extends StatefulWidget {
  final Product product;

  const _UpdateProductQuantityDialog({required this.product});

  @override
  State<_UpdateProductQuantityDialog> createState() => _UpdateProductQuantityDialogState();
}

class _UpdateProductQuantityDialogState extends State<_UpdateProductQuantityDialog> {
  QuantityUpdateWay _quantityUpdateWay = QuantityUpdateWay.edit;
  int quantity = 0;
  int editedQuantity = 0;
  bool updateOnlyAvailableQuantity = false;

  @override
  void initState() {
    super.initState();
    setState(() => quantity = widget.product.availableStock);
  }

  @override
  Widget build(BuildContext context) {
    int newQuantity = quantity + editedQuantity;
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return Dialog(
          child: SizedBox(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.product.articleNumber, style: TextStyles.defaultBold),
                  Text(widget.product.name, maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                  Gaps.h16,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox.adaptive(
                        value: updateOnlyAvailableQuantity,
                        onChanged: (value) => setState(() => updateOnlyAvailableQuantity = value!),
                      ),
                      const Text('Nur verfügbaren Bestand aktualisieren?'),
                    ],
                  ),
                  Gaps.h16,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FilterChip(
                        label: const Text('Menge + / -'),
                        labelStyle: const TextStyle(color: Colors.black),
                        selected: _quantityUpdateWay == QuantityUpdateWay.edit ? true : false,
                        selectedColor: CustomColors.chipSelectedColor,
                        backgroundColor: CustomColors.chipBackgroundColor,
                        onSelected: (bool isSelected) => isSelected ? setState(() => _quantityUpdateWay = QuantityUpdateWay.edit) : null,
                      ),
                      FilterChip(
                        label: const Text('Bestand ändern'),
                        labelStyle: const TextStyle(color: Colors.black),
                        selected: _quantityUpdateWay == QuantityUpdateWay.set ? true : false,
                        selectedColor: CustomColors.chipSelectedColor,
                        backgroundColor: CustomColors.chipBackgroundColor,
                        onSelected: (bool isSelected) => isSelected ? setState(() => _quantityUpdateWay = QuantityUpdateWay.set) : null,
                      ),
                    ],
                  ),
                  Gaps.h32,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(onPressed: () => setState(() => editedQuantity--), icon: const Icon(Icons.remove, color: Colors.red, size: 40)),
                      Text(editedQuantity.toString(), style: TextStyles.h1),
                      IconButton(onPressed: () => setState(() => editedQuantity++), icon: const Icon(Icons.add, color: Colors.green, size: 40)),
                    ],
                  ),
                  Gaps.h32,
                  const Text('Neuer Bestand:', style: TextStyles.h2),
                  Gaps.h16,
                  Text(newQuantity.toString(), style: TextStyles.h1),
                  Gaps.h32,
                  MyOutlinedButton(
                    buttonText: 'Speichern',
                    onPressed: state.isLoadingProductOnUpdateQuantity
                        ? () {}
                        : () => context.read<ProductBloc>().add(UpdateQuantityOfProductEvent(
                              product: widget.product,
                              newQuantity: newQuantity,
                              updateOnlyAvailableQuantity: updateOnlyAvailableQuantity,
                            )),
                    buttonBackgroundColor: Colors.green,
                    isLoading: state.isLoadingProductOnUpdateQuantity,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
