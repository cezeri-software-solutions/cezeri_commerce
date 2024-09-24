import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/3_domain/entities/product/product_marketplace.dart';
import '/constants.dart';
import '../../../../../2_application/database/marketplace_product/marketplace_product_bloc.dart';
import '../../../../../2_application/database/product_detail/product_detail_bloc.dart';
import '../../../../../4_infrastructur/repositories/shopify_api/shopify.dart';
import '../../../../core/core.dart';

class EditMarketplaceProductShopify extends StatelessWidget {
  final ProductDetailBloc productDetailBloc;
  final MarketplaceProductBloc marketplaceProductBloc;
  final ProductMarketplace productMarketplace;
  final ProductShopify marketplaceProductShopify;
  final VoidCallback setPage;
  final bool isProductSynchronized;

  const EditMarketplaceProductShopify({
    super.key,
    required this.productDetailBloc,
    required this.marketplaceProductBloc,
    required this.productMarketplace,
    required this.marketplaceProductShopify,
    required this.setPage,
    required this.isProductSynchronized,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketplaceProductBloc, MarketplaceProductState>(
      bloc: marketplaceProductBloc,
      builder: (context, state) {
        if (state.marketplaceProductShopify == null) return const Center(child: MyCircularProgressIndicator());

        return Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('ID im Marktplatz:', style: TextStyles.defaultBold),
                  Text(state.marketplaceProductShopify!.id.toString()),
                ],
              ),
              Gaps.h16,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Aktiv:', style: TextStyles.defaultBold),
                  MyChipWithThreeOptions(
                    titleLeft: 'Akiv',
                    titleMiddle: 'Entwurf',
                    titleRight: 'Archiviert',
                    onTapLeft: () => marketplaceProductBloc.add(SetMarketplaceProductIsActiveEvent(value: TappingPlace.left)),
                    onTapMiddle: () => marketplaceProductBloc.add(SetMarketplaceProductIsActiveEvent(value: TappingPlace.middle)),
                    onTapRight: () => marketplaceProductBloc.add(SetMarketplaceProductIsActiveEvent(value: TappingPlace.right)),
                    colorLeft: state.marketplaceProductShopify!.status == ProductShopifyStatus.active
                        ? CustomColors.todoScaleGreenActive
                        : CustomColors.todoScaleGreenDisabled,
                    colorMiddle: state.marketplaceProductShopify!.status == ProductShopifyStatus.draft
                        ? CustomColors.chipSelectedColor
                        : CustomColors.chipBackgroundColor,
                    colorRight: state.marketplaceProductShopify!.status == ProductShopifyStatus.archived
                        ? CustomColors.todoScaleRedActive
                        : CustomColors.todoScaleRedDisabled,
                  ),
                ],
              ),
              Gaps.h16,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Kategorien:', style: TextStyles.defaultBold),
                  state.isLoadingMarketplaceProductCategoriesOnObserve
                      ? const MyCircularProgressIndicator()
                      : IconButton(
                          onPressed: state.listOfCategoriesShopify != null
                              ? () {
                                  marketplaceProductBloc.add(OnSearchControllerClearedEvent());
                                  setPage();
                                }
                              : null,
                          icon: const Icon(Icons.edit, color: CustomColors.primaryColor),
                        )
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.marketplaceProductShopify!.customCollections.length,
                itemBuilder: (context, index) {
                  final category = state.marketplaceProductShopify!.customCollections[index];
                  return Row(
                    children: [
                      Text('${category.id}: '),
                      if (state.listOfCategoriesShopify != null &&
                          state.listOfCategoriesShopify!.where((e) => e.id == category.id).firstOrNull != null)
                        Text(state.listOfCategoriesShopify!.where((e) => e.id == category.id).first.title)
                    ],
                  );
                },
              ),
              Gaps.h42,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => context.router.maybePop(),
                    child: Text('Abbrechen', style: TextStyles.textButtonText.copyWith(color: Colors.red)),
                  ),
                  Gaps.w8,
                  isProductSynchronized
                      ? MyOutlinedButton(
                          buttonText: 'Speichern',
                          buttonBackgroundColor: Colors.green,
                          onPressed: () {
                            productDetailBloc.add(OnUpdateProductMarketplaceEvent(productMarketplace: state.productMarketplace!));
                            context.router.maybePop();
                          },
                        )
                      : MyOutlinedButton(
                          buttonText: 'Anlegen',
                          buttonBackgroundColor: Colors.green,
                          onPressed: () {
                            showMyDialogLoading(context: context, text: 'Artikel wird im Marktplatz angelegt...', canPop: true);
                            productDetailBloc.add(OnCreateProductInMarketplaceEvent(context: context, productMarketplace: state.productMarketplace!));
                          },
                        ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class EditMarketplaceProductShopifyCategories extends StatelessWidget {
  final MarketplaceProductBloc marketplaceProductBloc;

  const EditMarketplaceProductShopifyCategories({super.key, required this.marketplaceProductBloc});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    return BlocBuilder<MarketplaceProductBloc, MarketplaceProductState>(
      bloc: marketplaceProductBloc,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              CupertinoSearchTextField(
                controller: state.searchController,
                onChanged: (_) => marketplaceProductBloc.add(OnSearchControllerChangedEvent()),
                onSuffixTap: () => marketplaceProductBloc.add(OnSearchControllerClearedEvent()),
              ),
              if (state.searchController.text.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.listOfSelectedCategoiesShopify.length,
                  itemBuilder: (context, index) {
                    final category = state.listOfSelectedCategoiesShopify[index];
                    return ListTile(
                      leading: Checkbox.adaptive(
                        value: state.listOfSelectedCategoiesShopify.any((e) => e.id == category.id),
                        onChanged: (value) => marketplaceProductBloc.add(OnCategoriesIsSelectedChangedEvent(
                          index: index,
                          value: value!,
                          id: category.id,
                        )),
                      ),
                      title: Text(category.title),
                    );
                  },
                ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.listOfFilteredCategoriesShopify.length,
                itemBuilder: (context, index) {
                  final category = state.listOfFilteredCategoriesShopify[index];
                  return ListTile(
                    leading: Checkbox.adaptive(
                      value: state.listOfSelectedCategoiesShopify.any((e) => e.id == category.id),
                      onChanged: (value) => marketplaceProductBloc.add(OnCategoriesIsSelectedChangedEvent(
                        index: index,
                        value: value!,
                        id: category.id,
                      )),
                    ),
                    title: Text(category.title),
                  );
                },
              ),
              Container(height: screenHeight / 1.30),
            ],
          ),
        );
      },
    );
  }
}
