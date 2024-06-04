import 'package:flutter/material.dart';

import 'home_porducts_outlet/home_products_outlet_view.dart';
import 'home_products_sold_out/home_products_sold_out_view.dart';
import 'home_products_stock_failures/home_products_stock_failures_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        HomeProductsOutletView(),
        HomeProductsSoldOutView(),
        HomeProductsStockFailuresView(),
      ],
    );
  }
}
