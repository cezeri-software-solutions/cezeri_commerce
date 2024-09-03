import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../e_commerce/marketplace_overview/marketplaces_overview_screen.dart';

@RoutePage()
class PosOverviewScreen extends StatelessWidget {
  const PosOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MarketplacesOverviewScreen(comeFromPos: true);
  }
}
