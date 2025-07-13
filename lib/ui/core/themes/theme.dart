import 'package:catppuccin_flutter/catppuccin_flutter.dart';
import 'package:flutter/material.dart';

ThemeData catppuccinTheme(Flavor flavor) {
  Color primaryColor = flavor.mauve;
  Color secondaryColor = flavor.pink;

  return ThemeData(
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      elevation: 0,
      titleTextStyle: TextStyle(
        color: flavor.text,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: flavor.crust,
      foregroundColor: flavor.mantle,
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      error: flavor.surface2,
      onError: flavor.red,
      onPrimary: primaryColor,
      onSecondary: secondaryColor,
      onSurface: flavor.text,
      primary: flavor.crust,
      secondary: flavor.mantle,
      surface: flavor.surface0,
      surfaceContainerLow: flavor.surface1,
      surfaceContainerHigh: flavor.surface2,
    ),
    textTheme: const TextTheme().apply(
      bodyColor: flavor.text,
      displayColor: primaryColor,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: flavor.lavender,
      hoverColor: flavor.mauve
    ),
    dividerColor: flavor.overlay0,
  );
}
