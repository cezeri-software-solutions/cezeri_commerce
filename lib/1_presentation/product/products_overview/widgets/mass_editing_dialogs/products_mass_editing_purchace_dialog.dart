import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/core/extensions/string_to_int.dart';
import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../2_application/database/product/product_bloc.dart';
import '../../../../../3_domain/entities/marketplace/abstract_marketplace.dart';
import '../../../../../3_domain/entities/reorder/supplier.dart';
import '../../../../../constants.dart';
import '../../../../../routes/router.gr.dart';
import '../../../../core/functions/dialogs.dart';
import '../../../../core/widgets/my_button_small.dart';
import '../../../../core/widgets/my_circular_progress_indicator.dart';
import '../../../../core/widgets/my_dialog_suppliers.dart';
import '../../../../core/widgets/my_form_field_small.dart';
import '../../../../core/widgets/my_outlined_button.dart';
import '../../../../core/widgets/my_text_form_field_small_double.dart';

class ProductsMassEditingPurchaceDialog extends StatefulWidget {
  final ProductBloc productBloc;
  final List<AbstractMarketplace> selectedMarketplaces;

  const ProductsMassEditingPurchaceDialog({super.key, required this.selectedMarketplaces, required this.productBloc});

  @override
  State<ProductsMassEditingPurchaceDialog> createState() => _ProductsMassEditingPurchaceDialogState();
}

class _ProductsMassEditingPurchaceDialogState extends State<ProductsMassEditingPurchaceDialog> {
  final _wholesalePriceController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _minimumReorderQuantityController = TextEditingController();
  final _packagingUnitOnReorderController = TextEditingController();
  final _minimumStockController = TextEditingController();

  Supplier _supplier = Supplier.empty();

  bool _isWholesalePriceSelected = false;
  bool _isManufacturerSelected = false;
  bool _isSupplierSelected = false;
  bool _isMinimumReorderQuantitySelected = false;
  bool _isPackagingUnitOnReorderSelected = false;
  bool _isMinimumStockSelected = false;

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
                  const Text('Einkauf', style: TextStyles.h1),
                  Gaps.h32,
                  Row(
                    children: [
                      Expanded(
                        child: MyTextFormFieldSmallDouble(
                          aboveText: 'EK-Preis',
                          controller: _wholesalePriceController,
                          maxWidth: 100,
                        ),
                      ),
                      Checkbox.adaptive(value: _isWholesalePriceSelected, onChanged: (value) => setState(() => _isWholesalePriceSelected = value!))
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: state.listOfSuppliers == null
                              ? () => widget.productBloc.add(OnProductGetSuppliersEvent())
                              : () => showDialog(
                                    context: context,
                                    builder: (_) => MyDialogSuppliers(
                                      listOfSuppliers: state.listOfSuppliers!,
                                      onChanged: (supplier) => setState(() => _supplier = supplier),
                                    ),
                                  ),
                          child: MyButtonSmall(
                            labelText: 'Lieferant',
                            child: state.isLoadingProductSuppliersOnObseve ? const MyCircularProgressIndicator() : Text(_supplier.company),
                          ),
                        ),
                      ),
                      Gaps.w16,
                      Checkbox.adaptive(value: _isSupplierSelected, onChanged: (value) => setState(() => _isSupplierSelected = value!))
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextFormFieldSmall(
                          labelText: 'Hersteller',
                          controller: _manufacturerController,
                        ),
                      ),
                      Gaps.w16,
                      Checkbox.adaptive(value: _isManufacturerSelected, onChanged: (value) => setState(() => _isManufacturerSelected = value!))
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextFormFieldSmallDouble(
                          aboveText: 'Mindestnachbestellmenge',
                          controller: _minimumReorderQuantityController,
                          maxWidth: 100,
                        ),
                      ),
                      Checkbox.adaptive(
                        value: _isMinimumReorderQuantitySelected,
                        onChanged: (value) => setState(() => _isMinimumReorderQuantitySelected = value!),
                      )
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextFormFieldSmallDouble(
                          aboveText: 'Verpackungseinheit',
                          controller: _packagingUnitOnReorderController,
                          maxWidth: 100,
                        ),
                      ),
                      Checkbox.adaptive(
                          value: _isPackagingUnitOnReorderSelected, onChanged: (value) => setState(() => _isPackagingUnitOnReorderSelected = value!))
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextFormFieldSmallDouble(
                          aboveText: 'Mindestbestand',
                          controller: _minimumStockController,
                          maxWidth: 100,
                        ),
                      ),
                      Checkbox.adaptive(value: _isMinimumStockSelected, onChanged: (value) => setState(() => _isMinimumStockSelected = value!))
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
                        ProductsMassEditingPurchaceUpdatedEvent(
                          selectedMarketplaces: widget.selectedMarketplaces,
                          wholesalePrice: _wholesalePriceController.text.toMyDouble(),
                          manufacturer: _manufacturerController.text,
                          supplier: _supplier,
                          minimumReorderQuantity: _minimumReorderQuantityController.text.toMyInt(),
                          packagingUnitOnReorder: _packagingUnitOnReorderController.text.toMyInt(),
                          minimumStock: _minimumStockController.text.toMyInt(),
                          isWholesalePriceSelected: _isWholesalePriceSelected,
                          isManufacturerSelected: _isManufacturerSelected,
                          isSupplierSelected: _isSupplierSelected,
                          isMinimumReorderQuantitySelected: _isMinimumReorderQuantitySelected,
                          isPackagingUnitOnReorderSelected: _isPackagingUnitOnReorderSelected,
                          isMinimumStockSelected: _isMinimumStockSelected,
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
