import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/database/home/home_product/home_product_bloc.dart';
import '../../../injection.dart';
import '../../core/core.dart';
import 'widgets/home_products_sold_out_collapsed.dart';
import 'widgets/home_products_sold_out_expanded.dart';

class HomeProductsSoldOutView extends StatelessWidget {
  const HomeProductsSoldOutView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProductBloc = sl<HomeProductBloc>();

    return BlocProvider(
      create: (context) => homeProductBloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<HomeProductBloc, HomeProductState>(
            listenWhen: (p, c) => p.fosHomeProductsOnObserveOption != c.fosHomeProductsOnObserveOption,
            listener: (context, state) {
              state.fosHomeProductsOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (products) => myScaffoldMessenger(context, null, null, 'Artikel erfolgreich geladen', null),
                ),
              );
            },
          ),
          BlocListener<HomeProductBloc, HomeProductState>(
            listenWhen: (p, c) => p.fosHomeReordersOnObserveOption != c.fosHomeReordersOnObserveOption,
            listener: (context, state) {
              state.fosHomeReordersOnObserveOption.fold(
                () => null,
                (a) => a.fold(
                  (failure) => failureRenderer(context, [failure]),
                  (reorders) => myScaffoldMessenger(context, null, null, 'Nachbestellungen erfolgreich geladen', null),
                ),
              );
            },
          ),
        ],
        child: BlocBuilder<HomeProductBloc, HomeProductState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeProductsSoldOutCollapsed(homeProductBloc: homeProductBloc),
                  HomeProductsSoldOutExpanded(homeProductBloc: homeProductBloc),
                  const Divider(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
