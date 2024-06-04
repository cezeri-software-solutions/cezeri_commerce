import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../2_application/database/home/home_product/home_product_bloc.dart';
import '../../../injection.dart';
import 'widgets/home_products_stock_failures_collapsed.dart';
import 'widgets/home_products_stock_failures_expanded.dart';

class HomeProductsStockFailuresView extends StatelessWidget {
  const HomeProductsStockFailuresView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProductBloc = sl<HomeProductBloc>();

    return BlocProvider.value(
      value: homeProductBloc,
      child: BlocBuilder<HomeProductBloc, HomeProductState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeProductsStockFailuresCollapsed(homeProductBloc: homeProductBloc),
                HomeProductsStockFailuresExpanded(homeProductBloc: homeProductBloc),
                const Divider(),
              ],
            ),
          );
        },
      ),
    );
  }
}
