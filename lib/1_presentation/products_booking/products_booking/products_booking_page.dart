import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/firebase/products_booking/products_booking_bloc.dart';
import '../../../constants.dart';
import '../../core/widgets/my_form_field_container.dart';
import '../../core/widgets/my_outlined_button.dart';
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
                      child: Container(
                        height: 60,
                        width: 160,
                        color: Colors.green,
                        child: const Center(child: Text('Senden', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white))),
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
