import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/app_drawer.dart';
import 'package:cezeri_commerce/1_presentation/core/widgets/my_info_dialog.dart';
import 'package:cezeri_commerce/routes/router.gr.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../2_application/firebase/marketplace/marketplace_bloc.dart';
import '../../../2_application/firebase/product/product_bloc.dart';
import '../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../constants.dart';
import '../../../injection.dart';
import '../../core/functions/my_scaffold_messanger.dart';
import '../../core/widgets/my_delete_dialog.dart';
import '../../core/widgets/my_outlined_button.dart';
import 'products_overview_page.dart';

@RoutePage()
class ProductsOverviewScreen extends StatelessWidget {
  const ProductsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productBloc = sl<ProductBloc>()..add(GetAllProductsEvent());

    final searchController = TextEditingController();

    return BlocProvider<ProductBloc>(
      create: (context) => productBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProductBloc, ProductState>(
            listenWhen: (p, c) => p.fosProductsOnObserveOption != c.fosProductsOnObserveOption,
            listener: (context, state) {
              state.fosProductsOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => myScaffoldMessenger(context, failure, null, null, null),
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
                  (prestaFailure) => context.router.popUntilRouteWithName(ProductsOverviewRoute.name),
                  (unit) => context.router.popUntilRouteWithName(ProductsOverviewRoute.name),
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
        ],
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            return Scaffold(
              drawer: const AppDrawer(),
              appBar: AppBar(
                title: const Text('Artikel'),
                actions: [
                  IconButton(onPressed: () => context.read<ProductBloc>().add(GetAllProductsEvent()), icon: const Icon(Icons.refresh)),
                  TextButton.icon(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => state.selectedProducts.isEmpty
                          ? const MyInfoDialog(title: 'Achtung!', content: 'Bitte wähle mindestens einen Artikel aus.')
                          : MarketplacesDialog(
                              onChanged: (marketplace) {
                                context.read<ProductBloc>().add(MassEditActivateProductMarketplaceEvent(marketplace: marketplace!));
                                context.router.pop();
                              },
                            ),
                    ),
                    icon: state.isLoadingOnMassEditActivateProductMarketplace
                        ? const CircularProgressIndicator()
                        : const Icon(FontAwesomeIcons.diagramProject),
                    label: const Text('Massenbearbeitung'),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.add, color: Colors.green)),
                  IconButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => state.selectedProducts.isEmpty
                          ? const MyInfoDialog(title: 'Achtung!', content: 'Bitte wähle mindestens einen Artikel aus.')
                          : MyDeleteDialog(
                              content: 'Bist du sicher, dass du alle ausgewählten Artikel unwiederruflich löschen willst?',
                              onConfirm: () {
                                context.read<ProductBloc>().add(DeleteSelectedProductsEvent(selectedProducts: state.selectedProducts));
                                context.router.pop();
                              },
                            ),
                    ),
                    icon: state.isLoadingProductOnDelete
                        ? const CircularProgressIndicator(color: Colors.red)
                        : const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: CupertinoSearchTextField(
                      controller: searchController,
                      onChanged: (value) => context.read<ProductBloc>().add(SetSearchFieldTextEvent(searchText: value)),
                      onSubmitted: (value) => context.read<ProductBloc>().add(OnSearchFieldSubmittedEvent()),
                      onSuffixTap: () {
                        searchController.clear();
                        context.read<ProductBloc>().add(SetSearchFieldTextEvent(searchText: ''));
                        context.read<ProductBloc>().add(OnSearchFieldSubmittedEvent());
                      },
                    ),
                  ),
                  ProductOverviewPage(productBloc: productBloc),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class MarketplacesDialog extends StatelessWidget {
  final Function(Marketplace?)? onChanged;

  const MarketplacesDialog({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final marketplaceBloc = sl<MarketplaceBloc>()..add(GetAllMarketplacesEvent());

    return BlocProvider(
      create: (context) => marketplaceBloc,
      child: BlocBuilder<MarketplaceBloc, MarketplaceState>(
        builder: (context, state) {
          return Dialog(
            child: SizedBox(
              width: 400,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Marktplätze', style: TextStyles.h1),
                    Gaps.h32,
                    Flexible(
                      child: state.listOfMarketplace == null || state.isLoadingMarketplacesOnObserve
                          ? const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()))
                          : state.firebaseFailure != null && state.isAnyFailure
                              ? const SizedBox(
                                  height: 200,
                                  child: Center(
                                    child: Text('Ein Fehler ist aufgetreten'),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: state.listOfMarketplace!.length,
                                  itemBuilder: (context, index) {
                                    final marketplace = state.listOfMarketplace![index];
                                    return MyOutlinedButton(buttonText: marketplace.name, onPressed: () => onChanged?.call(marketplace));
                                  },
                                ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
