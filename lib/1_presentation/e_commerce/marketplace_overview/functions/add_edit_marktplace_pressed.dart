import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../../2_application/firebase/marketplace/marketplace_bloc.dart';
import '../../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../../3_domain/entities/marketplace/marketplace_presta.dart';
import '../../../../3_domain/entities/marketplace/marketplace_shopify.dart';
import '../../../../constants.dart';
import '../widgets/add_edit_marketplace_presta.dart';
import '../widgets/add_edit_marketplace_shopify.dart';
import '../widgets/select_marketplace_type.dart';

void addEditMarketplacepressed({required BuildContext context, required MarketplaceBloc marketplaceBloc, MarketplacePresta? marketplace}) =>
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: marketplaceBloc,
        child: AddEditMarketplacePresta(marketplaceBloc: marketplaceBloc, marketplace: marketplace),
      ),
    );

void onAddEditMarketplace({required BuildContext context, required MarketplaceBloc marketplaceBloc, AbstractMarketplace? marketplace}) {
  final ValueNotifier<int> pageIndexNotifier = ValueNotifier(marketplace == null ? 0 : 1);
  final ValueNotifier<MarketplaceType> marketplaceTypeNotifier =
      ValueNotifier(marketplace == null ? MarketplaceType.prestashop : marketplace.marketplaceType);

  Widget titleBuilder(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 20),
      child: Text(title, style: TextStyles.h2),
    );
  }

  final closeButton = Padding(
    padding: const EdgeInsets.only(right: 8),
    child: IconButton(
      icon: const Icon(Icons.close),
      onPressed: () => context.router.pop(),
    ),
  );

  void onMarketplaceSelected(MarketplaceType marketplaceType) {
    print(marketplaceType);
    marketplaceTypeNotifier.value = marketplaceType;
    pageIndexNotifier.value = 1;
  }

  WoltModalSheet.show<void>(
    context: context,
    useSafeArea: false,
    pageIndexNotifier: pageIndexNotifier,
    pageListBuilder: (context) => [
      WoltModalSheetPage(
        leadingNavBarWidget: titleBuilder('Marktplatz auswählen'),
        trailingNavBarWidget: closeButton,
        child: SelectMarketplaceType(onMarketplaceSelected: (mpType) => onMarketplaceSelected(mpType)),
      ),
      WoltModalSheetPage(
        leadingNavBarWidget: titleBuilder(marketplace != null ? 'Marktplatz bearbeiten' : 'Marktplatz erstellen'),
        trailingNavBarWidget: closeButton,
        child: ValueListenableBuilder(
          valueListenable: marketplaceTypeNotifier,
          builder: (context, marketplaceType, child) {
            return switch (marketplaceType) {
              MarketplaceType.prestashop => BlocProvider.value(
                  value: marketplaceBloc,
                  child: AddEditMarketplacePresta(
                    marketplaceBloc: marketplaceBloc,
                    marketplace: marketplace != null ? marketplace as MarketplacePresta : null,
                  ),
                ),
              MarketplaceType.shopify => BlocProvider.value(
                  value: marketplaceBloc,
                  child: AddEditMarketplaceShopify(
                    marketplaceBloc: marketplaceBloc,
                    marketplace: marketplace != null ? marketplace as MarketplaceShopify : null,
                  ),
                ),
              MarketplaceType.shop => throw Exception('UNKWNOWN Marketplace Type SHOP')
            };
          },
        ),
      ),
    ],
  );
}
