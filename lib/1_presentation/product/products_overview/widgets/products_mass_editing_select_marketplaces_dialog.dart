import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/firebase/marketplace/marketplace_bloc.dart';
import '../../../../2_application/firebase/product/product_bloc.dart';
import '../../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../../constants.dart';
import '../../../../injection.dart';
import '../../../core/widgets/my_circular_progress_indicator.dart';
import '../../../core/widgets/my_outlined_button.dart';
import 'products_mass_editing_select_option_dialog.dart';

class ProductsMassEditingSelectMarketplacesDialog extends StatefulWidget {
  final ProductBloc productBloc;

  const ProductsMassEditingSelectMarketplacesDialog({super.key, required this.productBloc});

  @override
  State<ProductsMassEditingSelectMarketplacesDialog> createState() => _ProductsMassEditingSelectMarketplacesDialogState();
}

class _ProductsMassEditingSelectMarketplacesDialogState extends State<ProductsMassEditingSelectMarketplacesDialog> {
  final List<AbstractMarketplace> _selectedMarketplaces = [];

  @override
  Widget build(BuildContext context) {
    final marketplaceBloc = sl<MarketplaceBloc>()..add(GetAllMarketplacesEvent());

    final screenWidth = MediaQuery.sizeOf(context).width;

    return BlocProvider(
      create: (context) => marketplaceBloc,
      child: BlocBuilder<MarketplaceBloc, MarketplaceState>(
        builder: (context, state) {
          if (state.listOfMarketplace == null && state.isLoadingMarketplacesOnObserve) {
            return const Dialog(
              child: SizedBox(
                height: 400,
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [MyCircularProgressIndicator(), Gaps.h24, Text('Marktplätze werden geladen')],
                ),
              ),
            );
          }

          if (state.firebaseFailure != null && state.isAnyFailure) {
            return const Dialog(
              child: SizedBox(
                height: 400,
                width: 400,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: Text('Ein Fehler ist aufgetreten')),
                ),
              ),
            );
          }

          return Dialog(
            child: SizedBox(
              width: screenWidth > 600 ? 600 : screenWidth,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Marktplätze', style: TextStyles.h1),
                    Gaps.h32,
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.listOfMarketplace!.length + 1,
                        itemBuilder: (context, index) {
                          if (index == state.listOfMarketplace!.length) {
                            final value = state.listOfMarketplace!.every((e) => _selectedMarketplaces.any((f) => e.id == f.id));

                            return ListTile(
                              title: const Text('Alle Marktplätze', style: TextStyles.h3Bold),
                              trailing: Checkbox.adaptive(
                                value: value,
                                onChanged: (_) {
                                  setState(() => value ? _selectedMarketplaces.clear() : _selectedMarketplaces.addAll(state.listOfMarketplace!));
                                },
                              ),
                            );
                          }

                          final marketplace = state.listOfMarketplace![index];
                          final selectedIndex = _selectedMarketplaces.indexWhere((e) => e.id == marketplace.id);
                          final isInList = selectedIndex != -1;

                          return ListTile(
                            title: Text(marketplace.name),
                            trailing: Checkbox.adaptive(
                              value: isInList,
                              onChanged: (_) {
                                if (isInList) {
                                  setState(() => _selectedMarketplaces.removeAt(selectedIndex));
                                } else {
                                  setState(() => _selectedMarketplaces.add(marketplace));
                                }
                              },
                            ),
                          );

                          // MyOutlinedButton(buttonText: marketplace.name, onPressed: () => widget.onChanged?.call(marketplace));
                        },
                      ),
                    ),
                    Gaps.h32,
                    MyOutlinedButton(
                      buttonText: 'Weiter',
                      onPressed: () {
                        context.router.popUntilRouteWithName(ProductsOverviewRoute.name);
                        showDialog(
                          context: context,
                          builder: (_) => BlocProvider.value(
                            value: widget.productBloc,
                            child: ProductsMassEditingSelectOptionDialog(
                              productBloc: widget.productBloc,
                              selectedMarketplaces: _selectedMarketplaces,
                            ),
                          ),
                        );
                      },
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
