import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/2_application/firebase/marketplace/marketplace_bloc.dart';
import 'package:cezeri_commerce/2_application/firebase/product/product_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/prestashop/product_import/product_import_bloc.dart';
import '../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../constants.dart';
import '../../../injection.dart';
import '../../app_drawer.dart';
import '../../core/functions/my_scaffold_messanger.dart';
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
  int _selectedMarketplaceIndex = 0;
  Marketplace _selectedMarketplace = Marketplace.empty();

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
          BlocListener<ProductBloc, ProductState>(
            listenWhen: (p, c) => p.fosProductOnCreateOption != c.fosProductOnCreateOption,
            listener: (context, state) {
              state.fosProductOnCreateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => myScaffoldMessenger(context, failure, null, null, null),
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
                  (failure) => myScaffoldMessenger(context, failure, null, null, null),
                  (listMarketplace) => null,
                ),
              );
            },
          ),
        ],
        child: BlocBuilder<MarketplaceBloc, MarketplaceState>(
          builder: (context, stateMarketplace) {
            final appBar = AppBar(title: const Text('Artikel Importieren'));
            const drawer = AppDrawer();

            if (stateMarketplace.isLoadingMarketplacesOnObserve) {
              return Scaffold(appBar: appBar, drawer: drawer, body: const Center(child: CircularProgressIndicator()));
            }
            if (stateMarketplace.firebaseFailure != null && stateMarketplace.isAnyFailure) {
              return Scaffold(
                  appBar: appBar, drawer: drawer, body: Center(child: Text(mapFirebaseFailureMessage(stateMarketplace.firebaseFailure!))));
            }

            _selectedMarketplace = stateMarketplace.listOfMarketplace![_selectedMarketplaceIndex];

            return Scaffold(
              drawer: drawer,
              appBar: appBar,
              body: Column(
                children: [
                  _OneOrMultipleProductImportTabbar(onTabTapped: _onTabTapped),
                  _SelectMarketplace(
                    listOfMarketplace: stateMarketplace.listOfMarketplace!,
                    selectedMarketplaceIndex: _selectedMarketplaceIndex,
                    onMarketplaceSelected: _onMarketplaceSelected,
                  ),
                  Expanded(
                    child: _index == 0
                        ? ProductImportPage(
                            productImportBloc: productImportBloc,
                            marketplace: stateMarketplace.listOfMarketplace![_selectedMarketplaceIndex],
                            importProductById: _importProductById,
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

  void _onMarketplaceSelected(int index) => setState(() => _selectedMarketplaceIndex = index);

  void _importProductById(int id) {
    productImportBloc.add(GetProductByIdFromPrestaEvent(id: id, marketplace: _selectedMarketplace));
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
  final List<Marketplace> listOfMarketplace;
  final int selectedMarketplaceIndex;
  final void Function(int index) onMarketplaceSelected;

  const _SelectMarketplace({required this.listOfMarketplace, required this.selectedMarketplaceIndex, required this.onMarketplaceSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: listOfMarketplace.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => onMarketplaceSelected(index),
            child: Card(
              color: selectedMarketplaceIndex == index ? Colors.orange : Colors.orange[50],
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(listOfMarketplace[index].name),
              ),
            ),
          );
        },
      ),
    );
  }
}
