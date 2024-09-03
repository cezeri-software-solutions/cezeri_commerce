import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../../../2_application/marketplace/product_export/bloc/product_export_bloc.dart';
import '../../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../../constants.dart';
import '../widgets/product_export_overview_sheet.dart';
import '../widgets/select_marketplace_to_export_sheet.dart';

void selectMarketplaceToExport({
  required BuildContext context,
  required ProductExportBloc productExportBloc,
  required List<AbstractMarketplace> marketplaces,
}) {
  final ValueNotifier<int> pageIndexNotifier = ValueNotifier(0);

  AbstractMarketplace? selectedMarketplace;

  Widget titleBuilder(String title) {
    return Padding(padding: const EdgeInsets.only(left: 24, top: 20), child: Text(title, style: TextStyles.h2));
  }

  final closeButton = Padding(
    padding: const EdgeInsets.only(right: 8),
    child: IconButton(icon: const Icon(Icons.close), onPressed: () => context.router.maybePop()),
  );

  void onMarketplaceSelected(AbstractMarketplace sM) {
    selectedMarketplace = sM;
    pageIndexNotifier.value = 1;
  }

  void onMarketplaceForSourceCategoriesSelected(AbstractMarketplace? sM) {
    productExportBloc.add(OnProductsExportToSelectedMarketplaceEvent(
      selectedMarketplace: selectedMarketplace!,
      selectedMarketplaceForSourceCategoires: sM,
    ));
    pageIndexNotifier.value = 2;
  }

  WoltModalSheet.show<void>(
    context: context,
    useSafeArea: false,
    pageIndexNotifier: pageIndexNotifier,
    pageListBuilder: (context) => [
      WoltModalSheetPage(
        leadingNavBarWidget: titleBuilder('Marktplatz auswählen'),
        trailingNavBarWidget: closeButton,
        child: SelectMarketplaceToExportSheet(
          isSelectMarketplaceForSourceCategories: false,
          marketplaces: marketplaces,
          onMarketplaceSelected: (sM) => onMarketplaceSelected(sM!),
        ),
      ),
      WoltModalSheetPage(
        leadingNavBarWidget: titleBuilder('Marktplatz auswählen'),
        trailingNavBarWidget: closeButton,
        child: SelectMarketplaceToExportSheet(
          isSelectMarketplaceForSourceCategories: true,
          marketplaces: marketplaces,
          onMarketplaceSelected: (sM) => onMarketplaceForSourceCategoriesSelected(sM),
        ),
      ),
      WoltModalSheetPage(
        leadingNavBarWidget: titleBuilder('Marktplatz auswählen'),
        trailingNavBarWidget: closeButton,
        child: BlocProvider.value(
          value: productExportBloc,
          child: ProductExportOverviewSheet(productExportBloc: productExportBloc),
        ),
      ),
      // WoltModalSheetPage(
      //   leadingNavBarWidget: titleBuilder(marketplace != null ? 'Marktplatz bearbeiten' : 'Marktplatz erstellen'),
      //   trailingNavBarWidget: closeButton,
      //   child: ValueListenableBuilder(
      //     valueListenable: marketplaceTypeNotifier,
      //     builder: (context, marketplaceType, child) {
      //       return switch (marketplaceType) {
      //         MarketplaceType.prestashop => BlocProvider.value(
      //             value: marketplaceBloc,
      //             child: AddEditMarketplacePresta(
      //               marketplaceBloc: marketplaceBloc,
      //               marketplace: marketplace != null ? marketplace as MarketplacePresta : null,
      //             ),
      //           ),
      //         MarketplaceType.shopify => BlocProvider.value(
      //             value: marketplaceBloc,
      //             child: AddEditMarketplaceShopify(
      //               marketplaceBloc: marketplaceBloc,
      //               marketplace: marketplace != null ? marketplace as MarketplaceShopify : null,
      //             ),
      //           ),
      //         MarketplaceType.shop => throw Exception('UNKWNOWN Marketplace Type SHOP')
      //       };
      //     },
      //   ),
      // ),
    ],
  );
}
