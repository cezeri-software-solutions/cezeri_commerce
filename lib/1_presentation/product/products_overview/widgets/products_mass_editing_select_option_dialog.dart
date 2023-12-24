import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/firebase/product/product_bloc.dart';
import '../../../../3_domain/entities/marketplace/marketplace.dart';
import '../../../../constants.dart';
import '../../../../routes/router.gr.dart';
import '../../../core/widgets/my_outlined_button.dart';
import 'products_mass_editing_purchace_dialog.dart';
import 'products_mass_editing_weight_and_dimensions_dialog.dart';

class ProductsMassEditingSelectOptionDialog extends StatelessWidget {
  final ProductBloc productBloc;
  final List<Marketplace> selectedMarketplaces;

  const ProductsMassEditingSelectOptionDialog({super.key, required this.selectedMarketplaces, required this.productBloc});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Dialog(
      child: SizedBox(
        width: screenWidth > 600 ? 600 : screenWidth,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Auswahlmöglichkeiten', style: TextStyles.h1),
              Gaps.h32,
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    MyOutlinedButton(
                      buttonText: 'Einkauf',
                      onPressed: () {
                        context.router.popUntilRouteWithName(ProductsOverviewRoute.name);
                        showDialog(
                          context: context,
                          builder: (_) => BlocProvider.value(
                            value: productBloc,
                            child: ProductsMassEditingPurchaceDialog(
                              productBloc: productBloc,
                              selectedMarketplaces: selectedMarketplaces,
                            ),
                          ),
                        );
                      },
                    ),
                    Gaps.h10,
                    MyOutlinedButton(
                      buttonText: 'Gewicht & Abmessungen',
                      onPressed: () {
                        context.router.popUntilRouteWithName(ProductsOverviewRoute.name);
                        showDialog(
                          context: context,
                          builder: (_) => BlocProvider.value(
                            value: productBloc,
                            child: ProductsMassEditingWeightAndDimensionsDialog(
                              productBloc: productBloc,
                              selectedMarketplaces: selectedMarketplaces,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
