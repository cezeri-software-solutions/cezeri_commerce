import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/database/products_booking/products_booking_bloc.dart';
import '../../../injection.dart';
import '../../app_drawer.dart';
import '../../core/core.dart';
import 'products_booking_page.dart';
import 'widgets/products_booking_select_products_dialog.dart';

@RoutePage()
class ProductsBookingScreen extends StatelessWidget {
  const ProductsBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsBookingBloc = sl<ProductsBookingBloc>();

    return BlocProvider(
      create: (context) => productsBookingBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProductsBookingBloc, ProductsBookingState>(
            listenWhen: (p, c) => p.fosProductsBookingReordersOnObserveOption != c.fosProductsBookingReordersOnObserveOption,
            listener: (context, state) {
              state.fosProductsBookingReordersOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (listOfReorders) => showDialog(
                    context: context,
                    builder: (context) => BlocProvider.value(
                      value: productsBookingBloc,
                      child: ProductsBookingSelectProductsDialog(productsBookingBloc: productsBookingBloc),
                    ),
                  ),
                ),
              );
            },
          ),
          BlocListener<ProductsBookingBloc, ProductsBookingState>(
            listenWhen: (p, c) => p.fosProductsBookingOnUpdateOption != c.fosProductsBookingOnUpdateOption,
            listener: (context, state) {
              state.fosProductsBookingOnUpdateOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (unit) => myScaffoldMessenger(context, null, null, 'Nachbestellungen und Artikel erfolgreich aktualisiert', null),
                ),
              );
            },
          ),
        ],
        child: Scaffold(
          drawer: const AppDrawer(),
          appBar: AppBar(title: const Text('Wareneingang')),
          body: SafeArea(child: ProductsBookingPage(productsBookingBloc: productsBookingBloc)),
        ),
      ),
    );
  }
}
