import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/app_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../2_application/database/product/product_bloc.dart';
import '../../../3_domain/entities/product/product.dart';
import '../../../constants.dart';
import '../../../injection.dart';
import '../../../routes/router.gr.dart';
import '../../core/core.dart';
import 'functions/get_products_app_bar_title.dart';
import 'modals/product_modals.dart';
import 'products_overview_page.dart';
import 'widgets/pme_failure_sheet.dart';
import 'widgets/widgets.dart';

@RoutePage()
class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> with AutomaticKeepAliveClientMixin {
  final productBloc = sl<ProductBloc>()..add(GetProductsPerPageEvent(isFirstLoad: true, calcCount: true, currentPage: 1));
  final iconButtonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider.value(
      value: productBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProductBloc, ProductState>(
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
          BlocListener<ProductBloc, ProductState>(
            listenWhen: (p, c) => p.fosProductOnUpdateQuantityOption != c.fosProductOnUpdateQuantityOption,
            listener: (context, state) {
              state.fosProductOnUpdateQuantityOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) {
                    failureRenderer(context, [failure]);
                    context.router.popUntilRouteWithName(ProductsOverviewRoute.name);
                  },
                  (unit) {
                    myScaffoldMessenger(context, null, null, 'Bestand erfolgreich aktualisiert', null);
                    context.router.popUntilRouteWithName(ProductsOverviewRoute.name);
                    state.productSearchController.text.isEmpty
                        ? productBloc.add(GetProductsPerPageEvent(isFirstLoad: false, calcCount: false, currentPage: state.currentPage))
                        : productBloc.add(GetFilteredProductsBySearchTextEvent(currentPage: state.currentPage));
                  },
                ),
              );
            },
          ),
          BlocListener<ProductBloc, ProductState>(
            listenWhen: (p, c) => p.fosProductAbstractFailuresOption != c.fosProductAbstractFailuresOption,
            listener: (context, state) {
              state.fosProductAbstractFailuresOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, failure),
                  (unit) => null,
                ),
              );
            },
          ),
          BlocListener<ProductBloc, ProductState>(
            listenWhen: (p, c) => p.fosProductOnEditQuantityPrestaOption != c.fosProductOnEditQuantityPrestaOption,
            listener: (context, state) {
              state.fosProductOnEditQuantityPrestaOption.fold(
                () => null,
                (a) => a.fold(
                  (prestaFailure) => myScaffoldMessenger(context, null, null, null, 'Bestand konnte in den Marktplätzen nicht aktualisiert werden'),
                  (unit) => myScaffoldMessenger(context, null, null, 'Bestand wurde erfolgreich in den Marktplätzen aktualisiert', null),
                ),
              );
            },
          ),
          BlocListener<ProductBloc, ProductState>(
            listenWhen: (p, c) => p.fosMassEditActivateProductMarketplaceOption != c.fosMassEditActivateProductMarketplaceOption,
            listener: (context, state) {
              state.fosMassEditActivateProductMarketplaceOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) =>
                      myScaffoldMessenger(context, null, null, null, 'Marktplätze konnten für die gewählten Artikel nicht aktiviert werden.'),
                  (unit) => myScaffoldMessenger(context, null, null, 'Marktplätze erfolgreich bei allen ausgewählten Artikeln aktiviert', null),
                ),
              );
            },
          ),
          BlocListener<ProductBloc, ProductState>(
            bloc: productBloc,
            listenWhen: (p, c) => p.fosMassEditProductsOption != c.fosMassEditProductsOption,
            listener: (context, state) {
              state.fosMassEditProductsOption.fold(
                () => null,
                (a) => a.fold((failure) {
                  context.router.popUntilRouteWithName(ProductsOverviewRoute.name);
                  myScaffoldMessenger(context, null, null, null, 'Beim Aktualisieren der Artikel ist ein Fehler aufgetreten');
                  showDialog(
                    context: context,
                    builder: (context) => PMEFailureSheet(productsList: state.listOfNotUpdatedProductsOnMassEditing),
                  );
                }, (_) {
                  context.router.popUntilRouteWithName(ProductsOverviewRoute.name);
                  myScaffoldMessenger(context, null, null, 'Alle Artikel wurden erfolgreich aktualisiert', null);
                }),
              );
            },
          ),
        ],
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            return Scaffold(
              drawer: const AppDrawer(),
              appBar: AppBar(
                title: getProductsAppBarTitle(context, state.listOfFilteredProducts, state.selectedProducts),
                actions: [
                  IconButton(
                    onPressed: () => addEditProductFilterValues(context, productBloc, state.productsFilterValues),
                    icon: Badge(isLabelVisible: state.isAnyFilterSet, child: const Icon(Icons.filter_list)),
                  ),
                  IconButton(
                    onPressed: () => state.productSearchController.text.isEmpty
                        ? productBloc.add(GetProductsPerPageEvent(isFirstLoad: false, calcCount: false, currentPage: state.currentPage))
                        : productBloc.add(GetFilteredProductsBySearchTextEvent(currentPage: state.currentPage)),
                    icon: const Icon(Icons.refresh),
                  ),
                  IconButton(
                    onPressed: () => _showMoreOptions(state.selectedProducts),
                    icon: const Icon(Icons.more_vert),
                  ),
                ],
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20, bottom: 10),
                      child: Row(
                        children: [
                          Checkbox.adaptive(
                            value: state.isSelectedAllProducts,
                            onChanged: (value) => productBloc.add(OnProductIsSelectedAllChangedEvent(isSelected: value!)),
                          ),
                          Expanded(
                            child: CupertinoSearchTextField(
                              controller: state.productSearchController,
                              onSubmitted: (value) => _onSearchFieldSubmitted(value, true),
                              onChanged: (value) => _onSearchFieldSubmitted(value, false),
                              onSuffixTap: () => productBloc.add(OnSearchFieldClearedEvent()),
                            ),
                          ),
                          Gaps.w12,
                          MySortBar<ProductsSortValue>(
                            sortingType: state.productsSortValue,
                            defaultType: ProductsSortValue.name,
                            isSortedAscending: state.isSortedAsc,
                            isLabelVisible: ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET),
                            translate: (s) => switch (s) {
                              ProductsSortValue.name => 'Sortiert nach Name',
                              ProductsSortValue.articleNumber => 'Sortiert nach Artikelnummer',
                              ProductsSortValue.manufacturer => 'Sortiert nach Hersteller',
                              ProductsSortValue.supplier => 'Sortiert nach Lieferant',
                              ProductsSortValue.wholesalePrice => 'Sortiert nach EK-Preis',
                              ProductsSortValue.netPrice => 'Sortiert nach VK-Preis',
                              ProductsSortValue.creationDate => 'Sortiert nach Erstellungsdatum',
                              ProductsSortValue.lastEditingDate => 'Sortiert nach Änderungsdatum',
                            },
                            sortMenuItem: const [
                              (value: ProductsSortValue.name, label: 'Name'),
                              (value: ProductsSortValue.articleNumber, label: 'Artikelnummer'),
                              (value: ProductsSortValue.manufacturer, label: 'Hersteller'),
                              (value: ProductsSortValue.supplier, label: 'Lieferant'),
                              (value: ProductsSortValue.wholesalePrice, label: 'EK-Preis'),
                              (value: ProductsSortValue.netPrice, label: 'VK-Preis'),
                              (value: ProductsSortValue.creationDate, label: 'Erstellungsdatum'),
                              (value: ProductsSortValue.lastEditingDate, label: 'Änderungsdatum'),
                            ],
                            onSortingConditionChanged: ({required type, required isSortedAscending}) {
                              productBloc.add(GetProductsPerPageEvent(
                                isFirstLoad: false,
                                calcCount: false,
                                currentPage: state.currentPage,
                                isSortedAsc: isSortedAscending,
                                productsSortValue: type,
                              ));
                            },
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 0),
                    ProductOverviewPage(productBloc: productBloc),
                    if (state.totalQuantity > 0) ...[
                      const Divider(height: 0),
                      PagesPaginationBar(
                        currentPage: state.currentPage,
                        totalPages: (state.totalQuantity / state.perPageQuantity).ceil(),
                        itemsPerPage: state.perPageQuantity,
                        totalItems: state.totalQuantity,
                        onPageChanged: (newPage) => state.productSearchController.text.isEmpty
                            ? productBloc.add(GetProductsPerPageEvent(isFirstLoad: false, calcCount: false, currentPage: newPage))
                            : productBloc.add(
                                GetFilteredProductsBySearchTextEvent(currentPage: newPage),
                              ),
                        onItemsPerPageChanged: (newValue) => productBloc.add(ItemsPerPageChangedEvent(value: newValue)),
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
      productBloc.add(GetProductsPerPageEvent(isFirstLoad: false, calcCount: true, currentPage: 1));
      return;
    }

    if (isOnSubmit && value.length < 3) {
      showMyDialogAlert(context: context, title: 'Achtung', content: 'Die Suche muss mindestens 3 Zeichen enthalten!');
      return;
    }

    productBloc.add(GetFilteredProductsBySearchTextEvent(currentPage: 1));
  }

  void _showMoreOptions(List<Product> listOfProducts) {
    showProductsOverviewOptions(context: context, productBloc: productBloc, listOfSelectedProducts: listOfProducts, iconButtonKey: iconButtonKey);
  }

  @override
  bool get wantKeepAlive => true;
}
