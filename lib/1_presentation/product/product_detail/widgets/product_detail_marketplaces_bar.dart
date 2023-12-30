import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../../2_application/firebase/marketplace_product/marketplace_product_bloc.dart';
import '../../../../2_application/firebase/product_detail/product_detail_bloc.dart';
import '../../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../../3_domain/entities/product/marketplace_product_presta.dart';
import '../../../../3_domain/entities/product/product_marketplace.dart';
import '../../../../constants.dart';
import '../../../../injection.dart';
import '../../../core/widgets/my_outlined_button.dart';
import 'product_marketplace/edit_marketplace_product_presta.dart';

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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              Gaps.h10,
              const Text('Marktplätze', style: TextStyles.h2Bold),
              Gaps.h8,
              SizedBox(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.product!.productMarketplaces.length,
                  itemBuilder: (context, index) {
                    final pm = state.product!.productMarketplaces[index];
                    final marketplaceProduct = pm.marketplaceProduct as MarketplaceProductPresta;
                    return Row(
                      children: [
                        InkWell(
                          onTap: () {
                            marketplaceProductBloc.add(SetMarketplaceProductStatesToInitialEvent());
                            marketplaceProductBloc.add(SetMarketplaceProductEvent(productMarketplace: pm));
                            showEditProductInMarketplace(context, productDetailBloc, marketplaceProductBloc, pm);
                          },
                          child: SizedBox(
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
                                    child: Text(pm.nameMarketplace, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    height: 5.0,
                                    decoration: BoxDecoration(
                                      color: marketplaceProduct.active == '1' ? Colors.green : Colors.grey,
                                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8.0), bottomRight: Radius.circular(8.0)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Gaps.w16,
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Future<void> showEditProductInMarketplace(
  BuildContext context,
  ProductDetailBloc productDetailBloc,
  MarketplaceProductBloc marketplaceProductBloc,
  ProductMarketplace productMarketplace,
) async {
  final pageIndexNotifier = ValueNotifier(0);

  void onPopFromSecondToFirstPage() {
    marketplaceProductBloc.add(SetListOfCategoriesPrestaToOriginalEvent());
    pageIndexNotifier.value = 0;
  }

  final leading = IconButton(
    padding: const EdgeInsets.only(left: 24),
    icon: const Icon(Icons.arrow_back),
    onPressed: () => onPopFromSecondToFirstPage(),
  );

  final trailing = IconButton(
    padding: const EdgeInsets.only(right: 24),
    icon: const Icon(Icons.close),
    onPressed: () => context.router.pop(),
  );

  WoltModalSheet.show(
    context: context,
    useSafeArea: false,
    pageIndexNotifier: pageIndexNotifier,
    onModalDismissedWithBarrierTap: () {
      context.router.pop().then((value) {
        pageIndexNotifier.value = 0;
      });
    },
    onModalDismissedWithDrag: () {
      context.router.pop().then((value) {
        pageIndexNotifier.value = 0;
      });
    },
    pageListBuilder: (woltContext) {
      return [
        WoltModalSheetPage(
          hasTopBarLayer: true,
          isTopBarLayerAlwaysVisible: true,
          topBarTitle: Text(productMarketplace.nameMarketplace, style: TextStyles.h3Bold),
          trailingNavBarWidget: trailing,
          child: switch (productMarketplace.marketplaceProduct!.marketplaceType) {
            MarketplaceType.prestashop => EditMarketplaceProductPresta(
                productDetailBloc: productDetailBloc,
                marketplaceProductBloc: marketplaceProductBloc,
                productMarketplace: productMarketplace,
                marketplaceProductPresta: productMarketplace.marketplaceProduct as MarketplaceProductPresta,
                setPage: () => pageIndexNotifier.value = 1,
              ),
            MarketplaceType.shop => throw Error,
          },
        ),
        WoltModalSheetPage(
          hasTopBarLayer: true,
          isTopBarLayerAlwaysVisible: true,
          topBarTitle: const Text('Kategorien', style: TextStyles.h3Bold),
          leadingNavBarWidget: leading,
          trailingNavBarWidget: trailing,
          child: EditMarketplaceProductPrestaCategories(marketplaceProductBloc: marketplaceProductBloc),
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
