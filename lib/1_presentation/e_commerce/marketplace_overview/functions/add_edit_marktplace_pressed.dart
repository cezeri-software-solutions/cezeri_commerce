import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../../2_application/database/marketplace/marketplace_bloc.dart';
import '../../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../../3_domain/entities/marketplace/marketplace_presta.dart';
import '../../../../3_domain/entities/marketplace/marketplace_shop.dart';
import '../../../../3_domain/entities/marketplace/marketplace_shopify.dart';
import '../../../../3_domain/repositories/firebase/customer_repository.dart';
import '../../../../constants.dart';
import '../../../../routes/router.gr.dart';
import '../../../core/core.dart';
import '../widgets/add_edit_marketplace_presta.dart';
import '../widgets/add_edit_marketplace_shop.dart';
import '../widgets/add_edit_marketplace_shopify.dart';

void addEditMarketplacepressed({required BuildContext context, required MarketplaceBloc marketplaceBloc, MarketplacePresta? marketplace}) =>
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: marketplaceBloc,
        child: AddEditMarketplacePresta(marketplaceBloc: marketplaceBloc, marketplace: marketplace),
      ),
    );

void onMarketplaceSelected(BuildContext context, MarketplaceShop marketplace) async {
  if (marketplace.defaultCustomerId != null) {
    final customerRepository = GetIt.I<CustomerRepository>();
    final fosCustomer = await customerRepository.getCustomer(marketplace.defaultCustomerId!);
    if (fosCustomer.isRight()) {
      if (context.mounted) context.router.push(PosDetailRoute(marketplace: marketplace, customer: fosCustomer.getRight()));
    } else {
      if (context.mounted) await selectCustomerAndNavigate(context, marketplace);
    }
  } else {
    if (context.mounted) await selectCustomerAndNavigate(context, marketplace);
  }
}

Future<void> selectCustomerAndNavigate(BuildContext context, MarketplaceShop marketplace) async {
  final selectedCustomer = await showSelectCustomerSheet(context);
  if (selectedCustomer == null) return;

  if (context.mounted) context.router.push(PosDetailRoute(marketplace: marketplace, customer: selectedCustomer));
}

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
    child: IconButton(icon: const Icon(Icons.close), onPressed: () => context.router.maybePop()),
  );

  void onMarketplaceSelected(MarketplaceType marketplaceType) {
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
        child: _SelectMarketplaceTypeTile(onMarketplaceSelected: (mpType) => onMarketplaceSelected(mpType)),
      ),
      WoltModalSheetPage(
        leadingNavBarWidget: titleBuilder(marketplace != null ? 'Marktplatz bearbeiten' : 'Marktplatz erstellen'),
        forceMaxHeight: true,
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
              MarketplaceType.shop => BlocProvider.value(
                  value: marketplaceBloc,
                  child: AddEditMarketplaceShop(
                    marketplaceBloc: marketplaceBloc,
                    marketplace: marketplace != null ? marketplace as MarketplaceShop : null,
                  ),
                ),
            };
          },
        ),
      ),
    ],
  );
}

class _SelectMarketplaceTypeTile extends StatelessWidget {
  final Function(MarketplaceType) onMarketplaceSelected;

  const _SelectMarketplaceTypeTile({required this.onMarketplaceSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ResponsiveBreakpoints.of(context).isMobile ? const EdgeInsets.only(top: 16, bottom: 40) : const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          ListTile(
            leading: SvgPicture.asset(getMarketplaceLogoAsset(MarketplaceType.shop), width: 40, height: 40),
            title: const Text('Ladengeschäft (POS)'),
            onTap: () => onMarketplaceSelected(MarketplaceType.shop),
          ),
          const Divider(),
          ListTile(
            leading: SizedBox(width: 40, height: 40, child: SvgPicture.asset(getMarketplaceLogoAsset(MarketplaceType.prestashop))),
            title: const Text('Prestashop'),
            onTap: () => onMarketplaceSelected(MarketplaceType.prestashop),
          ),
          const Divider(),
          ListTile(
            leading: SizedBox(width: 40, height: 40, child: SvgPicture.asset(getMarketplaceLogoAsset(MarketplaceType.shopify))),
            title: const Text('Shopify'),
            onTap: () => onMarketplaceSelected(MarketplaceType.shopify),
          ),
        ],
      ),
    );
  }
}
