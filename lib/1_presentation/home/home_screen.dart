import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../app_drawer.dart';
import 'home_page.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime firstDayOfNextMonth = DateTime(now.year, now.month + 1, 1);
    DateTime lastDayOfCurrentMonth = firstDayOfNextMonth.subtract(const Duration(days: 1));

    bool isTodayLastDayOfMonth =
        now.day == lastDayOfCurrentMonth.day && now.month == lastDayOfCurrentMonth.month && now.year == lastDayOfCurrentMonth.year;

    return Scaffold(
      appBar: AppBar(title: const Text('Startseite')),
      drawer: const AppDrawer(),
      body: const SafeArea(child: HomePage()),
    );
  }
}
