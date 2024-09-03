import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/database/product_detail/product_detail_bloc.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';

class PurchaseCard extends StatelessWidget {
  final ProductDetailBloc productDetailBloc;

  const PurchaseCard({super.key, required this.productDetailBloc});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailBloc, ProductDetailState>(
      bloc: productDetailBloc,
      builder: (context, state) {
        if (state.product == null) return const MyCircularProgressIndicator();
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Einkauf', style: TextStyles.h3BoldPrimary),
                const Divider(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: MyTextFormFieldSmallDouble(
                        aboveText: 'EK-Preis',
                        controller: state.wholesalePriceController,
                        onChanged: (_) => productDetailBloc.add(OnProductControllerChangedEvent()),
                      ),
                    ),
                    if (state.product!.isSetArticle && state.product!.listOfProductIdWithQuantity.isNotEmpty)
                      IconButton(
                        onPressed: () => productDetailBloc.add(OnSetProductWholesalePriceGeneratedEvent()),
                        icon: const Icon(Icons.reply_all_outlined, color: CustomColors.primaryColor),
                      )
                    else
                      Gaps.w8,
                    Expanded(
                      child: GestureDetector(
                        onTap: state.listOfSuppliers == null
                            ? () => productDetailBloc.add(OnProductGetSuppliersEvent())
                            : () => showDialog(
                                  context: context,
                                  builder: (_) => MyDialogSuppliers(
                                    listOfSuppliers: state.listOfSuppliers!,
                                    onChanged: (supplier) => productDetailBloc.add(OnProductSetSupplierEvent(supplierName: supplier.company)),
                                  ),
                                ),
                        child: MyButtonSmall(
                          labelText: 'Lieferant',
                          child: state.isLoadingProductSuppliersOnObseve ? const MyCircularProgressIndicator() : Text(state.product!.supplier),
                        ),
                      ),
                    ),
                  ],
                ),
                Gaps.h8,
                Row(
                  children: [
                    Expanded(
                      child: MyTextFormFieldSmall(
                        labelText: 'Lief. Artikel-Nr.',
                        controller: state.supplierArticleNumberController,
                        onChanged: (_) => productDetailBloc.add(OnProductControllerChangedEvent()),
                      ),
                    ),
                    Gaps.w8,
                    Expanded(
                      child: MyTextFormFieldSmall(
                        labelText: 'Hersteller',
                        controller: state.manufacturerController,
                        onChanged: (_) => productDetailBloc.add(OnProductControllerChangedEvent()),
                      ),
                    ),
                  ],
                ),
                Gaps.h8,
                Row(
                  children: [
                    Expanded(
                      child: MyTextFormFieldSmallDouble(
                        aboveText: 'Mindestnachbestellmenge',
                        controller: state.minimumReorderQuantityController,
                        onChanged: (_) => productDetailBloc.add(OnProductControllerChangedEvent()),
                      ),
                    ),
                    Gaps.w8,
                    Expanded(
                      child: MyTextFormFieldSmallDouble(
                        aboveText: 'Verpackungseinheit',
                        controller: state.packagingUnitOnReorderController,
                        onChanged: (_) => productDetailBloc.add(OnProductControllerChangedEvent()),
                      ),
                    ),
                    Gaps.w8,
                    Expanded(
                      child: MyTextFormFieldSmallDouble(
                        aboveText: 'Mindestbestand',
                        controller: state.minimumStockController,
                        onChanged: (_) => productDetailBloc.add(OnProductControllerChangedEvent()),
                      ),
                    ),
                  ],
                ),
                Gaps.w8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text('Unter Mindestbestand: '),
                        Checkbox.adaptive(value: state.product!.isUnderMinimumStock, onChanged: null),
                      ],
                    ),
                    Text('Bestand: ${state.product!.availableStock} / ${state.product!.warehouseStock}'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
