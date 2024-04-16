import 'package:flutter/material.dart';

import '../constants.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: CustomColors.primaryColor,
    ).copyWith(
      brightness: Brightness.light,
      // BackgroundColor of Container
      primaryContainer: CustomColors.containerBackgroundLight,
      // BorderColor of Container
      outline: CustomColors.borderColorLight,
      surface: Colors.white,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData().copyWith(
      backgroundColor: CustomColors.primaryColor,
    ),
    textTheme: const TextTheme().copyWith(bodyMedium: const TextStyle(fontSize: 13)),
    iconTheme: const IconThemeData().copyWith(color: CustomColors.iconColor),
    appBarTheme: const AppBarTheme().copyWith(surfaceTintColor: Colors.transparent),
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
