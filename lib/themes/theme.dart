import 'package:flutter/material.dart';

import '../constants.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData tempTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: CustomColors.primaryColor,
    ).copyWith(
      brightness: Brightness.light,
      primaryContainer: CustomColors.containerBackgroundLight,
      outline: CustomColors.borderColorLight,
      surface: Colors.white,
    ),
  );

  static final ThemeData lightTheme = ThemeData(
    colorScheme: tempTheme.colorScheme,
    floatingActionButtonTheme: const FloatingActionButtonThemeData().copyWith(
      backgroundColor: CustomColors.primaryColor,
    ),
    // textTheme: const TextTheme().copyWith(bodyMedium: const TextStyle(fontSize: 14)),
    iconTheme: const IconThemeData().copyWith(color: CustomColors.iconColor),
    appBarTheme: AppBarTheme(
      surfaceTintColor: Colors.transparent,
      color: tempTheme.colorScheme.surfaceBright, // Verwende die Hintergrundfarbe aus tempTheme
    ),
    useMaterial3: true,
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: CustomColors.primaryColor,
      brightness: Brightness.dark,
      // primaryContainer: CustomColors.containerBackgroundDark,
      outline: CustomColors.borderColorDark,
      background: Colors.black,
      surface: Colors.grey[850],
    ),
    useMaterial3: true,
  );
}
