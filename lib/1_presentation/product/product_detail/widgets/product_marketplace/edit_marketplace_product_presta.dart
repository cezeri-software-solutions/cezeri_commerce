import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/3_domain/entities/product/product_marketplace.dart';
import '/3_domain/entities/product/product_presta.dart';
import '/4_infrastructur/repositories/prestashop_api/models/category_presta.dart';
import '/constants.dart';
import '../../../../../2_application/database/marketplace_product/marketplace_product_bloc.dart';
import '../../../../../2_application/database/product_detail/product_detail_bloc.dart';
import '../../../../core/core.dart';

class EditMarketplaceProductPresta extends StatelessWidget {
  final ProductDetailBloc productDetailBloc;
  final MarketplaceProductBloc marketplaceProductBloc;
  final ProductMarketplace productMarketplace;
  final ProductPresta marketplaceProductPresta;
  final VoidCallback setPage;
  final bool isProductSynchronized;

  const EditMarketplaceProductPresta({
    super.key,
    required this.productDetailBloc,
    required this.marketplaceProductBloc,
    required this.productMarketplace,
    required this.marketplaceProductPresta,
    required this.setPage,
    required this.isProductSynchronized,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketplaceProductBloc, MarketplaceProductState>(
      bloc: marketplaceProductBloc,
      builder: (context, state) {
        if (state.marketplaceProductPresta == null) return const Center(child: MyCircularProgressIndicator());

        return Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('ID im Marktplatz:', style: TextStyles.defaultBold),
                  Text(state.marketplaceProductPresta!.id.toString()),
                ],
              ),
              Gaps.h16,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Aktiv:', style: TextStyles.defaultBold),
                  Switch.adaptive(
                    value: switch (state.marketplaceProductPresta!.active) {
                      '0' => false,
                      '1' => true,
                      _ => throw Exception(),
                    },
                    onChanged: (value) => marketplaceProductBloc.add(SetMarketplaceProductIsActiveEvent(value: value)),
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
                          onPressed: state.listOfCategoriesPresta != null ? () => setPage() : null,
                          icon: const Icon(Icons.edit, color: CustomColors.primaryColor),
                        )
                ],
              ),
              // Text(state.marketplaceProductPresta!.associations!.associationsCategories!.map((e) => e.id).toList().toString()),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.marketplaceProductPresta!.associations!.associationsCategories!.length,
                itemBuilder: (context, index) {
                  final category = state.marketplaceProductPresta!.associations!.associationsCategories![index];
                  return Row(
                    children: [
                      Text('${category.id}: '),
                      if (state.listOfCategoriesPresta != null &&
                          state.listOfCategoriesPresta!.where((e) => e.id.toString() == category.id).firstOrNull != null)
                        Text(state.listOfCategoriesPresta!.where((e) => e.id.toString() == category.id).first.name)
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

class EditMarketplaceProductPrestaCategories extends StatelessWidget {
  final MarketplaceProductBloc marketplaceProductBloc;

  const EditMarketplaceProductPrestaCategories({super.key, required this.marketplaceProductBloc});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    return BlocBuilder<MarketplaceProductBloc, MarketplaceProductState>(
      bloc: marketplaceProductBloc,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CategoryWidget(
                category: state.listOfCategoriesPresta!.first,
                index: 0,
                allCategories: state.listOfCategoriesPresta!,
                marketplaceProductBloc: marketplaceProductBloc,
              ),
              Container(height: screenHeight / 1.30),
            ],
          ),
        );
      },
    );
  }
}

class CategoryWidget extends StatelessWidget {
  final CategoryPresta category;
  final int index;
  final List<CategoryPresta> allCategories;
  final MarketplaceProductBloc marketplaceProductBloc;

  const CategoryWidget({super.key, required this.category, required this.index, required this.allCategories, required this.marketplaceProductBloc});

  @override
  Widget build(BuildContext context) {
    List<CategoryPresta> subCategories =
        allCategories.where((c) => c.idParent == category.id.toString() && c.levelDepth == (int.parse(category.levelDepth) + 1).toString()).toList();

    return BlocBuilder<MarketplaceProductBloc, MarketplaceProductState>(
      bloc: marketplaceProductBloc,
      builder: (context, state) {
        return Column(
          children: [
            if (subCategories.isNotEmpty) const Divider(height: 0, color: CustomColors.backgroundLightGrey),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (category.levelDepth.toMyInt() != 0) SizedBox(width: 20 * (category.levelDepth.toMyDouble())),
                      if (subCategories.isNotEmpty)
                        InkWell(
                          onTap: () => marketplaceProductBloc.add(OnCategoriesIsExpandedChangedEvent(index: index)),
                          child: state.isExpanded[index] ? const Icon(Icons.keyboard_arrow_down) : const Icon(Icons.keyboard_arrow_right),
                        )
                      else
                        const Icon(Icons.keyboard_arrow_right, color: Colors.transparent),
                      Checkbox.adaptive(
                        value: state.isSelected[index],
                        onChanged: (value) {
                          if (value != null && !value && category.id.toString() == state.marketplaceProductPresta!.idCategoryDefault) {
                            showMyDialogAlert(
                              context: context,
                              title: 'Achtung',
                              content: 'Ändere bitte zuerst die Standardkategorie um diese Kategorie deaktivieren zu können',
                            );
                            return;
                          }
                          marketplaceProductBloc.add(OnCategoriesIsSelectedChangedEvent(index: index, value: value!));
                        },
                      ),
                      Expanded(child: Text(category.name, maxLines: 1, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ),
                Checkbox.adaptive(
                  value: category.id.toString() == state.marketplaceProductPresta!.idCategoryDefault,
                  onChanged: (_) => marketplaceProductBloc.add(OnDefaultCategoryChangedEvent(id: category.id, index: index)),
                ),
              ],
            ),
            if (state.isExpanded[index])
              ...subCategories.map((subCategory) => MyAnimatedExpansionContainer(
                    isExpanded: state.isExpanded[index],
                    child: CategoryWidget(
                      category: subCategory,
                      index: allCategories.indexOf(subCategory),
                      allCategories: allCategories,
                      marketplaceProductBloc: marketplaceProductBloc,
                    ),
                  )),
            if (subCategories.isNotEmpty) const Divider(height: 0, color: CustomColors.backgroundLightGrey),
          ],
        );
      },
    );
  }
}
