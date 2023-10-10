import 'package:auto_route/auto_route.dart';
import 'package:cezeri_commerce/1_presentation/core/extensions/to_my_currency.dart';
import 'package:flutter/material.dart';

import 'app_drawer.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const valueString1 = '2,6384';
    const valueString2 = '2,3750';
    const valueString3 = '2,374999';
    print(valueString1.toMyDouble());
    print(valueString2.toMyDouble());
    print(valueString3.toMyDouble());
    const valueDouble1 = 2.6384;
    const valueDouble2 = 2.3750;
    const valueDouble3 = 2.374999;
    print(valueDouble1.toMyCurrencyString());
    print(valueDouble2.toMyCurrencyString());
    print(valueDouble3.toMyCurrencyString());

    return Scaffold(
      appBar: AppBar(title: const Text('Startseite')),
      drawer: const AppDrawer(),
      body: const Center(
        child: SelectableText('Herzlich Willkommen'),
      ),
    );
  }
}
