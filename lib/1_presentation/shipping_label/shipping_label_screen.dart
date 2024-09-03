import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../app_drawer.dart';
import 'shipping_label_page.dart';

@RoutePage()
class ShippingLabelScreen extends StatelessWidget {
  const ShippingLabelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text('Versandlabel')),
      body: const SafeArea(child: ShippingLabelPage()),
    );
  }
}
