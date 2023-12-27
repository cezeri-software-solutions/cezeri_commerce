import 'package:flutter/material.dart';

import 'home_product/home_product_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        HomeProductView(),
      ],
    );
  }
}
