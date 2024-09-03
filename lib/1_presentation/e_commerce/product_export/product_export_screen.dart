import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/marketplace/product_export/bloc/product_export_bloc.dart';
import '../../../constants.dart';
import '../../../injection.dart';
import '../../app_drawer.dart';
import '../../core/core.dart';
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
  final productExportBloc = sl<ProductExportBloc>()..add(GetProductsPerPageEvent(isFirstLoad: true, calcCount: true, currentPage: 1));

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
                  IconButton(
                    onPressed: () => state.productSearchController.text.isEmpty
                        ? productExportBloc.add(GetProductsPerPageEvent(isFirstLoad: false, calcCount: false, currentPage: state.currentPage))
                        : productExportBloc.add(GetFilteredProductsBySearchTextEvent(currentPage: state.currentPage)),
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: CupertinoSearchTextField(
                              controller: state.productSearchController,
                              onSubmitted: (value) => _onSearchFieldSubmitted(value, true),
                              onChanged: (value) => _onSearchFieldSubmitted(value, false),
                              onSuffixTap: () => productExportBloc.add(OnProductSearchControllerClearedEvent()),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 0),
                    ProductExportPage(productExportBloc: productExportBloc),
                    if (state.totalQuantity > 0) ...[
                      const Divider(height: 0),
                      PagesPaginationBar(
                        currentPage: state.currentPage,
                        totalPages: (state.totalQuantity / state.perPageQuantity).ceil(),
                        itemsPerPage: state.perPageQuantity,
                        totalItems: state.totalQuantity,
                        onPageChanged: (newPage) => state.productSearchController.text.isEmpty
                            ? productExportBloc.add(GetProductsPerPageEvent(isFirstLoad: false, calcCount: false, currentPage: newPage))
                            : productExportBloc.add(
                                GetFilteredProductsBySearchTextEvent(currentPage: newPage),
                              ),
                        onItemsPerPageChanged: (newValue) => productExportBloc.add(ItemsPerPageChangedEvent(value: newValue)),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onSearchFieldSubmitted(String value, bool isOnSubmit) {
    if (value.isEmpty) {
      productExportBloc.add(GetProductsPerPageEvent(isFirstLoad: false, calcCount: true, currentPage: 1));
      return;
    }

    if (isOnSubmit && value.length < 3) {
      showMyDialogAlert(context: context, title: 'Achtung', content: 'Die Suche muss mindestens 3 Zeichen enthalten!');
      return;
    }

    productExportBloc.add(GetFilteredProductsBySearchTextEvent(currentPage: 1));
  }

  @override
  bool get wantKeepAlive => true;
}
