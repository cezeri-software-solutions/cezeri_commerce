import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../2_application/database/product/product_bloc.dart';
import '../../../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../../../constants.dart';
import '../../../../../routes/router.gr.dart';
import '../../../../core/functions/dialogs.dart';
import '../../../../core/widgets/my_outlined_button.dart';
import '../../../../core/widgets/my_text_form_field_small_double.dart';

class ProductsMassEditingWeightAndDimensionsDialog extends StatefulWidget {
  final ProductBloc productBloc;
  final List<AbstractMarketplace> selectedMarketplaces;

  const ProductsMassEditingWeightAndDimensionsDialog({super.key, required this.selectedMarketplaces, required this.productBloc});

  @override
  State<ProductsMassEditingWeightAndDimensionsDialog> createState() => _ProductsMassEditingWeightAndDimensionsDialogState();
}

class _ProductsMassEditingWeightAndDimensionsDialogState extends State<ProductsMassEditingWeightAndDimensionsDialog> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _depthController = TextEditingController();
  final _widthController = TextEditingController();

  bool _isWeightSelected = false;
  bool _isHeightSelected = false;
  bool _isDepthSelected = false;
  bool _isWidthSelected = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return BlocBuilder<ProductBloc, ProductState>(
      bloc: widget.productBloc,
      builder: (context, state) {
        return Dialog(
          child: SizedBox(
            width: screenWidth > 600 ? 600 : screenWidth,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Gewicht & Abmessungen', style: TextStyles.h1),
                  Gaps.h32,
                  Row(
                    children: [
                      Expanded(
                        child: MyTextFormFieldSmallDouble(
                          aboveText: 'Gewicht kg',
                          controller: _weightController,
                          maxWidth: 100,
                        ),
                      ),
                      Checkbox.adaptive(value: _isWeightSelected, onChanged: (value) => setState(() => _isWeightSelected = value!))
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextFormFieldSmallDouble(
                          aboveText: 'Höhe cm',
                          controller: _heightController,
                          maxWidth: 100,
                        ),
                      ),
                      Checkbox.adaptive(value: _isHeightSelected, onChanged: (value) => setState(() => _isHeightSelected = value!))
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextFormFieldSmallDouble(
                          aboveText: 'Länge cm',
                          controller: _depthController,
                          maxWidth: 100,
                        ),
                      ),
                      Checkbox.adaptive(value: _isDepthSelected, onChanged: (value) => setState(() => _isDepthSelected = value!))
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextFormFieldSmallDouble(
                          aboveText: 'Breite cm',
                          controller: _widthController,
                          maxWidth: 100,
                        ),
                      ),
                      Checkbox.adaptive(value: _isWidthSelected, onChanged: (value) => setState(() => _isWidthSelected = value!))
                    ],
                  ),
                  const Divider(),
                  Gaps.h32,
                  MyOutlinedButton(
                    buttonText: 'Übernehmen',
                    buttonBackgroundColor: Colors.green,
                    onPressed: () {
                      context.router.popUntilRouteWithName(ProductsOverviewRoute.name);
                      widget.productBloc.add(
                        ProductsMassEditingWeightAndDimensionsUpdatedEvent(
                          selectedMarketplaces: widget.selectedMarketplaces,
                          weight: _weightController.text.toMyDouble(),
                          height: _heightController.text.toMyDouble(),
                          depth: _depthController.text.toMyDouble(),
                          width: _widthController.text.toMyDouble(),
                          isWeightSelected: _isWeightSelected,
                          isHeightSelected: _isHeightSelected,
                          isDepthSelected: _isDepthSelected,
                          isWidthSelected: _isWidthSelected,
                        ),
                      );
                      showMyDialogLoading(context: context, text: 'Änderungen werden übernommen...', canPop: true);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
