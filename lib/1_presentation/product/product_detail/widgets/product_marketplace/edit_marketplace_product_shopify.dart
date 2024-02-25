import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/core/functions/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../4_infrastructur/repositories/shopify_api/shopify.dart';
import '../../../../core/widgets/my_circular_progress_indicator.dart';
import '../../../../core/widgets/my_outlined_button.dart';
import '/2_application/firebase/marketplace_product/marketplace_product_bloc.dart';
import '/2_application/firebase/product_detail/product_detail_bloc.dart';
import '/3_domain/entities/product/product_marketplace.dart';
import '/constants.dart';

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
                  Switch.adaptive(
                    value: switch (state.marketplaceProductShopify!.status) {
                      'active' => true,
                      _ => false,
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
                  IconButton(
                    onPressed: state.listOfCategoriesShopify != null ? () => setPage() : null,
                    icon: const Icon(Icons.edit, color: CustomColors.primaryColor),
                  )
                ],
              ),
              // Text(state.marketplaceProductShopify!.associations!.associationsCategories!.map((e) => e.id).toList().toString()),
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
                    onPressed: () => context.router.pop(),
                    child: Text('Abbrechen', style: TextStyles.textButtonText.copyWith(color: Colors.red)),
                  ),
                  Gaps.w8,
                  isProductSynchronized
                      ? MyOutlinedButton(
                          buttonText: 'Speichern',
                          buttonBackgroundColor: Colors.green,
                          onPressed: () {
                            productDetailBloc.add(OnUpdateProductMarketplaceEvent(productMarketplace: state.productMarketplace!));
                            context.router.pop();
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
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.listOfCategoriesShopify!.length,
            itemBuilder: (context, index) {
              final category = state.listOfCategoriesShopify![index];
              return ListTile(
                leading: Checkbox.adaptive(value: state.isSelected[index], onChanged: (_) {}),
                title: Text(category.title),
              );
            },
          ),
        );
      },
    );
  }
}
