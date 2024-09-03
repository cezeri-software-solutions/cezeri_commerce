import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../../../2_application/database/marketplace_product/marketplace_product_bloc.dart';
import '../../../../../2_application/database/product_detail/product_detail_bloc.dart';
import '../../../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../../../3_domain/entities/product/product_marketplace.dart';
import '../../../../../3_domain/entities/product/product_presta.dart';
import '../../../../../4_infrastructur/repositories/prestashop_api/models/product_raw_presta.dart';
import '../../../../../4_infrastructur/repositories/shopify_api/shopify.dart';
import '../../../../../constants.dart';
import '../../../../../injection.dart';
import '../../../../core/core.dart';
import 'edit_marketplace_product_presta.dart';
import 'edit_marketplace_product_shopify.dart';

class ProductDetailMarketplacesBar extends StatelessWidget {
  final ProductDetailBloc productDetailBloc;

  const ProductDetailMarketplacesBar({super.key, required this.productDetailBloc});

  @override
  Widget build(BuildContext context) {
    final marketplaceProductBloc = sl<MarketplaceProductBloc>();

    return BlocProvider(
      create: (context) => marketplaceProductBloc,
      child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        bloc: productDetailBloc,
        builder: (context, state) {
          if (state.product == null) return const MyCircularProgressIndicator();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(thickness: 5),
              Gaps.h10,
              const Text('Marktplätze', style: TextStyles.h2Bold),
              Gaps.h16,
              Row(
                children: [
                  const Text('Synchronisierte Marktplätze:', style: TextStyles.h3),
                  Gaps.w8,
                  Badge(label: Text(state.product!.productMarketplaces.length.toString()), backgroundColor: CustomColors.primaryColor),
                ],
              ),
              Gaps.h16,
              SizedBox(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.product!.productMarketplaces.length,
                  itemBuilder: (context, index) {
                    final pm = state.product!.productMarketplaces[index];
                    return Row(
                      children: [
                        InkWell(
                          onTap: () {
                            marketplaceProductBloc.add(SetMarketplaceProductStatesToInitialEvent());
                            marketplaceProductBloc.add(SetMarketplaceProductEvent(productMarketplace: pm));
                            showEditProductInMarketplace(context, productDetailBloc, marketplaceProductBloc, pm, true);
                          },
                          child: _MarketplaceCard(
                            marketplaceName: pm.nameMarketplace,
                            logoPath: getMarketplaceLogoAsset(pm.marketplaceProduct!.marketplaceType),
                            isActive: switch (pm.marketplaceProduct!.marketplaceType) {
                              MarketplaceType.prestashop => (pm.marketplaceProduct as ProductPresta).active == '1',
                              MarketplaceType.shopify => (pm.marketplaceProduct as ProductShopify).status == ProductShopifyStatus.active,
                              MarketplaceType.shop => throw Exception('Marktplatz SHOP ist noch nicht implementiert.'),
                            },
                          ),
                        ),
                        Gaps.w16,
                      ],
                    );
                  },
                ),
              ),
              Gaps.h16,
              Row(
                children: [
                  const Text('Nicht synchronisierte Marktplätze:', style: TextStyles.h3),
                  IconButton(
                    onPressed: () => productDetailBloc.add(OnProductGetMarketplacesEvent()),
                    icon: const Icon(Icons.refresh, color: CustomColors.primaryColor),
                  ),
                ],
              ),
              Gaps.h16,
              if (state.listOfNotSynchronizedMarketplaces != null)
                SizedBox(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: state.listOfNotSynchronizedMarketplaces!.length,
                    itemBuilder: (context, index) {
                      final marketplace = state.listOfNotSynchronizedMarketplaces![index];
                      return Row(
                        children: [
                          InkWell(
                            onTap: () {
                              switch (marketplace.marketplaceType) {
                                case MarketplaceType.prestashop:
                                  {
                                    marketplaceProductBloc.add(SetMarketplaceProductStatesToInitialEvent());
                                    final emptyMarketplaceProductPresta = ProductPresta.empty();
                                    final marketplaceProductPresta = emptyMarketplaceProductPresta.copyWith(
                                      associations: Associations(
                                          associationsCategories: [AssociationsCategory(id: '2')],
                                          associationsImages: null,
                                          associationsCombinations: null,
                                          associationsProductOptionValues: null,
                                          associationsProductFeatures: null,
                                          associationsStockAvailables: null,
                                          associationsAccessories: null,
                                          associationsProductBundle: null),
                                    );
                                    final productMarketplace = ProductMarketplace(
                                      idMarketplace: marketplace.id,
                                      nameMarketplace: marketplace.name,
                                      shortNameMarketplace: marketplace.shortName,
                                      marketplaceProduct: marketplaceProductPresta,
                                    );
                                    marketplaceProductBloc.add(SetMarketplaceProductEvent(productMarketplace: productMarketplace));
                                    showEditProductInMarketplace(context, productDetailBloc, marketplaceProductBloc, productMarketplace, false);
                                  }
                                case MarketplaceType.shopify:
                                  {
                                    throw Exception('SHOPIFY not implemented');
                                  }
                                case MarketplaceType.shop:
                                  {
                                    throw Exception('SHOP not implemented');
                                  }
                              }
                            },
                            child: _MarketplaceCard(
                              marketplaceName: marketplace.name,
                              logoPath: getMarketplaceLogoAsset(marketplace.marketplaceType),
                              isActive: false,
                            ),
                          ),
                          Gaps.w16,
                        ],
                      );
                    },
                  ),
                ),
              Gaps.h16,
            ],
          );
        },
      ),
    );
  }
}

class _MarketplaceCard extends StatelessWidget {
  final String marketplaceName;
  final String logoPath;
  final bool isActive;

  const _MarketplaceCard({required this.marketplaceName, required this.logoPath, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      width: 200,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(marketplaceName, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              height: 40,
              width: 40,
              child: SvgPicture.asset(logoPath),
            ),
            Container(
              height: 5.0,
              decoration: BoxDecoration(
                color: isActive ? Colors.green : Colors.grey,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showEditProductInMarketplace(
  BuildContext context,
  ProductDetailBloc productDetailBloc,
  MarketplaceProductBloc marketplaceProductBloc,
  ProductMarketplace productMarketplace,
  bool isProductSynchronized,
) async {
  final pageIndexNotifier = ValueNotifier(0);

  void onPopFromSecondToFirstPage() {
    marketplaceProductBloc.add(SetListOfCategoriesPrestaToOriginalEvent());
    pageIndexNotifier.value = 0;
  }

  void onRemoveMarketplaceFromProduct() {
    showMyDialogDelete(
      context: context,
      content: 'Bist du sicher, dass du den Marktplatz ${productMarketplace.nameMarketplace} von diesem Artikel löschen willst?',
      onConfirm: () {
        productDetailBloc.add(DeleteMarketplaceFromProductEvent(marketplaceId: productMarketplace.idMarketplace));
        context.router.popUntilRouteWithName(ProductDetailRoute.name);
      },
    );
  }

  final leadingPage1 = IconButton(
    padding: const EdgeInsets.only(left: 24),
    icon: const Icon(Icons.delete, color: Colors.red),
    onPressed: onRemoveMarketplaceFromProduct,
  );

  final leadingPage2 = IconButton(
    padding: const EdgeInsets.only(left: 24),
    icon: const Icon(Icons.arrow_back),
    onPressed: onPopFromSecondToFirstPage,
  );

  final trailing = IconButton(
    padding: const EdgeInsets.only(right: 24),
    icon: const Icon(Icons.close),
    onPressed: () => context.router.maybePop(),
  );

  WoltModalSheet.show(
    context: context,
    useSafeArea: false,
    pageIndexNotifier: pageIndexNotifier,
    onModalDismissedWithBarrierTap: () => context.router.maybePop().then((value) => pageIndexNotifier.value = 0),
    onModalDismissedWithDrag: () => context.router.maybePop().then((value) => pageIndexNotifier.value = 0),
    pageListBuilder: (woltContext) {
      return [
        WoltModalSheetPage(
          hasTopBarLayer: true,
          isTopBarLayerAlwaysVisible: true,
          topBarTitle: Text(productMarketplace.nameMarketplace, style: TextStyles.h3Bold),
          leadingNavBarWidget: leadingPage1,
          trailingNavBarWidget: trailing,
          child: switch (productMarketplace.marketplaceProduct!.marketplaceType) {
            MarketplaceType.prestashop => EditMarketplaceProductPresta(
                productDetailBloc: productDetailBloc,
                marketplaceProductBloc: marketplaceProductBloc,
                productMarketplace: productMarketplace,
                marketplaceProductPresta: productMarketplace.marketplaceProduct as ProductPresta,
                setPage: () => pageIndexNotifier.value = 1,
                isProductSynchronized: isProductSynchronized,
              ),
            MarketplaceType.shopify => EditMarketplaceProductShopify(
                productDetailBloc: productDetailBloc,
                marketplaceProductBloc: marketplaceProductBloc,
                productMarketplace: productMarketplace,
                marketplaceProductShopify: productMarketplace.marketplaceProduct as ProductShopify,
                setPage: () => pageIndexNotifier.value = 1,
                isProductSynchronized: isProductSynchronized,
              ),
            MarketplaceType.shop => throw Exception('SHOP not implemented'),
          },
        ),
        WoltModalSheetPage(
          hasTopBarLayer: true,
          isTopBarLayerAlwaysVisible: true,
          topBarTitle: const Text('Kategorien', style: TextStyles.h3Bold),
          leadingNavBarWidget: leadingPage2,
          trailingNavBarWidget: trailing,
          child: switch (productMarketplace.marketplaceProduct!.marketplaceType) {
            MarketplaceType.prestashop => EditMarketplaceProductPrestaCategories(marketplaceProductBloc: marketplaceProductBloc),
            MarketplaceType.shopify => EditMarketplaceProductShopifyCategories(marketplaceProductBloc: marketplaceProductBloc),
            MarketplaceType.shop => throw Exception('Ladengeschäft kann keine Kategorien haben.'),
          },
          stickyActionBar: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => onPopFromSecondToFirstPage(),
                child: Text('Abbrechen', style: TextStyles.textButtonText.copyWith(color: Colors.red)),
              ),
              Gaps.w8,
              MyOutlinedButton(
                buttonText: 'Übernehmen',
                buttonBackgroundColor: Colors.green,
                onPressed: () {
                  marketplaceProductBloc.add(OnSetUpdatedCategoriesEvent());
                  pageIndexNotifier.value = 0;
                },
              ),
              Gaps.w8,
            ],
          ),
        ),
      ];
    },
  );
}
