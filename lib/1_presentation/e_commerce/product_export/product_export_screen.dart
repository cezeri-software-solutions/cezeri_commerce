import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/marketplace/product_export/bloc/product_export_bloc.dart';
import '../../../constants.dart';
import '../../../injection.dart';
import '../../app_drawer.dart';
import '../../core/renderer/failure_renderer.dart';
import '../../core/widgets/my_circular_progress_indicator.dart';
import '../../product/products_overview/functions/get_products_app_bar_title.dart';
import 'functions/select_marketplace_to_export.dart';
import 'product_export_page.dart';

@RoutePage()
class ProductExportScreen extends StatefulWidget {
  const ProductExportScreen({super.key});

  @override
  State<ProductExportScreen> createState() => _ProductExportScreenState();
}

class _ProductExportScreenState extends State<ProductExportScreen> with AutomaticKeepAliveClientMixin {
  final productExportBloc = sl<ProductExportBloc>()..add(GetAllProductsEvent());

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider.value(
      value: productExportBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProductExportBloc, ProductExportState>(
            listenWhen: (p, c) => p.fosProductsOnObserveOption != c.fosProductsOnObserveOption,
            listener: (context, state) {
              state.fosProductsOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (listOfProducts) => null,
                ),
              );
            },
          ),
          BlocListener<ProductExportBloc, ProductExportState>(
            listenWhen: (p, c) => p.fosMarketplacesOnObserveOption != c.fosMarketplacesOnObserveOption,
            listener: (context, state) {
              state.fosMarketplacesOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (listOfMarketplaces) => selectMarketplaceToExport(
                    context: context,
                    productExportBloc: productExportBloc,
                    marketplaces: listOfMarketplaces,
                  ),
                ),
              );
            },
          ),
        ],
        child: BlocBuilder<ProductExportBloc, ProductExportState>(
          builder: (context, state) {
            return Scaffold(
              drawer: const AppDrawer(),
              appBar: AppBar(
                title: getProductsAppBarTitle(context, state.listOfFilteredProducts, state.selectedProducts),
                actions: [
                  state.isLoadingOnExportProducts || state.isLoadingMarketplacesOnObserve
                      ? const MyCircularProgressIndicator()
                      : IconButton(
                          onPressed: () {
                            if (state.listOfMarketplaces.isEmpty) {
                              productExportBloc.add(GetAllMarketplacesEvent());
                              return;
                            }

                            selectMarketplaceToExport(context: context, productExportBloc: productExportBloc, marketplaces: state.listOfMarketplaces);
                          },
                          icon: const Icon(Icons.import_export, color: CustomColors.primaryColor),
                        ),
                  IconButton(onPressed: () => productExportBloc.add(GetAllProductsEvent()), icon: const Icon(Icons.refresh)),
                ],
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: CupertinoSearchTextField(
                            controller: state.productSearchController,
                            onChanged: (value) => productExportBloc.add(OnProductSearchControllerChangedEvent()),
                            onSubmitted: (value) => productExportBloc.add(OnProductSearchControllerChangedEvent()),
                            onSuffixTap: () => productExportBloc.add(OnProductSearchControllerClearedEvent()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ProductExportPage(productExportBloc: productExportBloc),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
