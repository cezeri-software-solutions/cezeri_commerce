import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/database/products_booking/products_booking_bloc.dart';
import '../../../constants.dart';
import '../../core/core.dart';
import 'widgets/products_booking_page_table.dart';
import 'widgets/products_booking_select_products_dialog.dart';

class ProductsBookingPage extends StatelessWidget {
  final ProductsBookingBloc productsBookingBloc;

  const ProductsBookingPage({super.key, required this.productsBookingBloc});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return BlocBuilder<ProductsBookingBloc, ProductsBookingState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              MyFormFieldContainer(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                width: double.infinity,
                child: Row(children: [
                  MyOutlinedButton(
                    buttonText: 'Wareneingang aus EK-Bestellung',
                    isLoading: state.isLoadingProductsBookingReordersOnObserve,
                    onPressed: () {
                      if (state.listOfAllReorders == null || state.listOfAllReorders!.isEmpty) {
                        productsBookingBloc.add(ProductsBookingGetReordersEvent());
                      } else {
                        productsBookingBloc.add(OnProductsBookingSetReorderFilterEvent(reorderNumber: ''));
                        showDialog(
                          context: context,
                          builder: (context) => BlocProvider.value(
                            value: productsBookingBloc,
                            child: ProductsBookingSelectProductsDialog(productsBookingBloc: productsBookingBloc),
                          ),
                        );
                      }
                    },
                  )
                ]),
              ),
              Gaps.h10,
              Expanded(
                child: MyFormFieldContainer(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: productsBookingPageTable(
                        context: context,
                        productsBookingBloc: productsBookingBloc,
                        state: state,
                        bookingProductsList: state.listOfSelectedProducts,
                        screenWidth: screenWidth,
                      ),
                    ),
                  ),
                ),
              ),
              Gaps.h10,
              MyFormFieldContainer(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () => productsBookingBloc.add(OnProductsBookingSaveEvent()),
                      child: Container(
                        height: 60,
                        width: 160,
                        decoration: const BoxDecoration(color: Colors.green, borderRadius: BorderRadius.all(Radius.circular(12))),
                        child: state.isLoadingProductsBookingOnUpdate
                            ? const Center(child: MyCircularProgressIndicator(color: Colors.white))
                            : const Center(
                                child: Text('Speichern', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                              ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
