import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

import '../1_presentation/app_drawer.dart';
import '../constants.dart';

class RootLayout extends StatelessWidget {
  final Widget child;
  final double breakpoint;

  const RootLayout({super.key, required this.child, this.breakpoint = FixSizes.persistantWidth});

  @override
  Widget build(BuildContext context) {
    final customBreakpoint = Breakpoint(beginWidth: breakpoint);

    return AdaptiveLayout(
      primaryNavigation: SlotLayout(
        config: {
          customBreakpoint: SlotLayout.from(
            key: const Key('Primary Navigation'),
            builder: (_) => Material(
              color: Theme.of(context).colorScheme.surfaceContainer,
              elevation: 1,
              child: const SizedBox(
                width: FixSizes.drawerWidth,
                child: AppDrawer(isPersistent: true),
              ),
            ),
          ),
        },
      ),
      body: SlotLayout(
        config: {
          Breakpoints.standard: SlotLayout.from(key: const Key('Body'), builder: (_) => child),
        },
      ),
    );
  }
}
