import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../app_drawer.dart';
import '../core/core.dart';
import 'home_page.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Startseite')),
      drawer: context.displayDrawer ? const AppDrawer() : null,
      body: const SafeArea(child: HomePage()),
    );
  }
}
