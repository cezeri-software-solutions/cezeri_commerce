import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/database/products_booking/products_booking_bloc.dart';
import '../../../../constants.dart';
import '../../../core/core.dart';
import 'products_booking_select_products_table.dart';

class ProductsBookingSelectProductsDialog extends StatelessWidget {
  final ProductsBookingBloc productsBookingBloc;

  const ProductsBookingSelectProductsDialog({super.key, required this.productsBookingBloc});

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.screenWidth;
    return BlocBuilder<ProductsBookingBloc, ProductsBookingState>(
      builder: (context, state) {
        return Dialog(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: productsBookingSelectProductsTable(
                          productsBookingBloc: productsBookingBloc,
                          state: state,
                          listOfBookingProductsFromReorders: state.listOfBookingProductsFromReorders,
                          screenWidth: screenWidth,
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 0, color: Colors.black),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 70,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: state.listOfAllReorders!.length,
                          itemBuilder: (context, index) {
                            final reorder = state.listOfAllReorders![index];
                            return _ReorderFilterContainer(
                              productsBookingBloc: productsBookingBloc,
                              reorderNumber: reorder.reorderNumber.toString(),
                              isSelected: state.reorderFilter == reorder.reorderNumber.toString(),
                            );
                          },
                        ),
                      ),
                      Row(
                        children: [
                          TextButton(onPressed: () => context.maybePop(), child: const Text('Abbrechen')),
                          Gaps.w16,
                          MyOutlinedButton(
                            buttonText: 'Übernehmen',
                            onPressed: () {
                              productsBookingBloc.add(OnProductsBookingSetBookingProductsFromReorderEvent());
                              context.maybePop();
                            },
                            buttonBackgroundColor: Colors.green,
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ReorderFilterContainer extends StatelessWidget {
  final ProductsBookingBloc productsBookingBloc;
  final String reorderNumber;
  final bool isSelected;

  const _ReorderFilterContainer({required this.productsBookingBloc, required this.reorderNumber, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => productsBookingBloc.add(OnProductsBookingSetReorderFilterEvent(reorderNumber: isSelected ? '' : reorderNumber)),
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: isSelected ? CustomColors.chipSelectedColor : CustomColors.chipBackgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border: Border.all(color: Colors.grey),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(child: Text(reorderNumber, style: TextStyles.defaultBold)),
            ),
          ),
        ),
        Gaps.w16,
      ],
    );
  }
}
