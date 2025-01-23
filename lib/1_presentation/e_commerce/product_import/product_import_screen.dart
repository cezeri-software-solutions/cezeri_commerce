import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/2_application/database/marketplace/marketplace_bloc.dart';
import 'package:cezeri_commerce/2_application/database/product/product_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../2_application/marketplace/product_import/product_import_bloc.dart';
import '../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../constants.dart';
import '../../../injection.dart';
import '../../app_drawer.dart';
import '../../core/core.dart';
import 'product_import_page.dart';
import 'products_import_page.dart';

@RoutePage()
class ProductImportScreen extends StatefulWidget {
  const ProductImportScreen({super.key});

  @override
  State<ProductImportScreen> createState() => _ProductImportScreenState();
}

class _ProductImportScreenState extends State<ProductImportScreen> {
  int _index = 0;
  final int _selectedMarketplaceIndex = 0;

  final productImportBloc = sl<ProductImportBloc>();
  final marketplaceBloc = sl<MarketplaceBloc>()..add(GetAllMarketplacesEvent());
  final productBloc = sl<ProductBloc>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductImportBloc>(
          create: (context) => productImportBloc,
        ),
        BlocProvider<MarketplaceBloc>(
          create: (context) => marketplaceBloc,
        ),
        BlocProvider<ProductBloc>(
          create: (context) => productBloc,
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProductImportBloc, ProductImportState>(
            listenWhen: (p, c) => p.fosProductPrestaOnObserveOption != c.fosProductPrestaOnObserveOption,
            listener: (context, state) {
              state.fosProductPrestaOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => myScaffoldMessenger(context, null, null, null, failure.toString()),
                  (prestaProduct) => myScaffoldMessenger(context, null, null, 'Artikel erfolgreich importiert', null),
                ),
              );
            },
          ),
          BlocListener<ProductImportBloc, ProductImportState>(
            listenWhen: (p, c) => p.fosProductsPrestaOnObserveOption != c.fosProductsPrestaOnObserveOption,
            listener: (context, state) {
              state.fosProductsPrestaOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) {
                    context.router.maybePopTop();
                    myScaffoldMessenger(context, null, null, null, failure.toString());
                  },
                  (unit) {
                    context.router.maybePopTop();
                    myScaffoldMessenger(context, null, null, 'Artikel erfolgreich importiert', null);
                  },
                ),
              );
            },
          ),
          BlocListener<ProductImportBloc, ProductImportState>(
            listenWhen: (p, c) => p.fosProductOnCreateOption != c.fosProductOnCreateOption,
            listener: (context, state) {
              state.fosProductOnCreateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (unit) => myScaffoldMessenger(context, null, null, 'Artikel erfolgreich importiert', null),
                ),
              );
            },
          ),
          BlocListener<ProductImportBloc, ProductImportState>(
            listenWhen: (p, c) => p.fosProductsOnCreateOption != c.fosProductsOnCreateOption,
            listener: (context, state) {
              state.fosProductsOnCreateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) {
                    context.router.maybePopTop();
                    myScaffoldMessenger(context, null, null, null, failure.toString());
                  },
                  (unit) {
                    context.router.maybePopTop();
                    myScaffoldMessenger(context, null, null, 'Artikel erfolgreich importiert', null);
                  },
                ),
              );
            },
          ),
          BlocListener<ProductBloc, ProductState>(
            listenWhen: (p, c) => p.fosProductOnCreateOption != c.fosProductOnCreateOption,
            listener: (context, state) {
              state.fosProductOnCreateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (unit) => myScaffoldMessenger(context, null, null, 'Artikel erfolgreich angelegt', null),
                ),
              );
            },
          ),
          BlocListener<MarketplaceBloc, MarketplaceState>(
            listenWhen: (p, c) => p.fosMarketplacesOnObserveOption != c.fosMarketplacesOnObserveOption,
            listener: (context, state) {
              state.fosMarketplacesOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (listMarketplace) => productImportBloc.add(SetSelectedMarketplaceProductImportEvent(marketplace: listMarketplace.first)),
                ),
              );
            },
          ),
        ],
        child: BlocBuilder<MarketplaceBloc, MarketplaceState>(
          builder: (context, stateMarketplace) {
            final appBar = AppBar(title: const Text('Artikel Importieren'));
            final drawer = context.displayDrawer ? const AppDrawer() : null;

            if (stateMarketplace.isLoadingMarketplacesOnObserve) {
              return Scaffold(appBar: appBar, drawer: drawer, body: const Center(child: CircularProgressIndicator()));
            }
            if (stateMarketplace.firebaseFailure != null && stateMarketplace.isAnyFailure) {
              return Scaffold(appBar: appBar, drawer: drawer, body: const Center(child: Text('Ein Fehler ist aufgetreten.')));
            }

            return Scaffold(
              drawer: drawer,
              appBar: appBar,
              body: Column(
                children: [
                  _OneOrMultipleProductImportTabbar(onTabTapped: _onTabTapped),
                  _SelectMarketplace(
                    listOfMarketplace: stateMarketplace.listOfMarketplace!,
                    productImportBloc: productImportBloc,
                  ),
                  Expanded(
                    child: _index == 0
                        ? ProductImportPage(
                            productImportBloc: productImportBloc,
                            marketplace: stateMarketplace.listOfMarketplace![_selectedMarketplaceIndex],
                          )
                        : ProductsImportPage(productImportBloc: productImportBloc),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _onTabTapped(int id) {
    return switch (id) {
      0 => setState(() => _index = 0),
      1 => setState(() => _index = 1),
      (_) => null,
    };
  }
}

class _OneOrMultipleProductImportTabbar extends StatelessWidget {
  final void Function(int id) onTabTapped;

  const _OneOrMultipleProductImportTabbar({required this.onTabTapped});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: TabBar(
        indicatorColor: CustomColors.primaryColor,
        labelColor: CustomColors.primaryColor,
        unselectedLabelColor: Colors.grey,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
        dragStartBehavior: DragStartBehavior.down,
        indicatorSize: TabBarIndicatorSize.label,
        tabs: const [
          Tab(text: 'Einzelner Artikelimport'),
          Tab(text: 'Alle Artikel importieren'),
        ],
        onTap: (index) => onTabTapped(index),
      ),
    );
  }
}

class _SelectMarketplace extends StatelessWidget {
  final List<AbstractMarketplace> listOfMarketplace;
  final ProductImportBloc productImportBloc;

  const _SelectMarketplace({required this.listOfMarketplace, required this.productImportBloc});

  @override
  Widget build(BuildContext context) {
    final marketplaces = listOfMarketplace.where((e) => e.marketplaceType != MarketplaceType.shop).toList();

    return BlocBuilder<ProductImportBloc, ProductImportState>(
      bloc: productImportBloc,
      builder: (context, state) {
        if (state.isLoadingProductPrestaOnObserve) const CircularProgressIndicator();
        return SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: marketplaces.length,
            itemBuilder: (context, index) {
              final marketplace = marketplaces[index];
              return InkWell(
                onTap: () => productImportBloc.add(SetSelectedMarketplaceProductImportEvent(marketplace: marketplace)),
                child: Card(
                  color: marketplace.id == state.selectedMarketplace!.id ? Colors.orange : Colors.orange[50],
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(marketplaces[index].name),
                        SizedBox(height: 40, width: 40, child: SvgPicture.asset(getMarketplaceLogoAsset(marketplaces[index].marketplaceType))),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
