import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../constants.dart';

// import '../../themes/themes.dart';

// extension GetCustomColors on BuildContext {
//   CustomColors get customColors => Theme.of(this).extension<CustomColors>()!;
// }

extension GetColorScheme on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}

extension GetBrightness on BuildContext {
  Brightness get brightness => Theme.of(this).brightness;
}

extension GetTextTheme on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
}

extension GetScreenSize on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;
}

// extension AppLocalizationsExtension on BuildContext {
//   AppLocalizations get l10n => AppLocalizations.of(this)!;
// }

extension PopContext on BuildContext {
  void pop<T extends Object?>([T? result]) => Navigator.of(this).pop(result);
}

extension ResponsiveBreakpointsExtension on BuildContext {
  ResponsiveBreakpointsData get breakpoint => ResponsiveBreakpoints.of(this);
}

extension GetOverallScreenWidth on BuildContext {
  double get overallScreenWidth => MediaQuery.sizeOf(this).width;
}

extension GetScreenWidth on BuildContext {
  double get screenWidth => overallScreenWidth <= FixSizes.persistantWidth ? overallScreenWidth : overallScreenWidth - FixSizes.drawerWidth;
}

extension GetScreenHeight on BuildContext {
  double get screenHeight => MediaQuery.sizeOf(this).height;
}

extension ShouldDisplayDrawer on BuildContext {
  bool get displayDrawer => overallScreenWidth <= FixSizes.persistantWidth;
}
