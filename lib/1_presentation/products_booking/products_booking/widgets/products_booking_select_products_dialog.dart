import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../2_application/firebase/products_booking/products_booking_bloc.dart';
import '../../../../constants.dart';
import '../../../core/widgets/my_outlined_button.dart';
import 'products_booking_select_products_table.dart';

class ProductsBookingSelectProductsDialog extends StatelessWidget {
  final ProductsBookingBloc productsBookingBloc;

  const ProductsBookingSelectProductsDialog({super.key, required this.productsBookingBloc});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(onPressed: () => context.popRoute(), child: const Text('Abbrechen')),
                      Gaps.w16,
                      MyOutlinedButton(
                        buttonText: 'Übernehmen',
                        onPressed: () {},
                        buttonBackgroundColor: Colors.green,
                      ),
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
