import 'package:flutter/material.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';
import 'package:fuel_finder/core/themes/text_theme.dart';

class AppTheme {
  static OutlineInputBorder _border([
    Color color = AppPallete.lightBorderColor,
  ]) => OutlineInputBorder(
    borderSide: BorderSide(color: color, width: 1),
    borderRadius: BorderRadius.circular(10),
  );

  static final lightThemeMode = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.green,
      primary: Colors.green,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    textTheme: TextThemes.lightTextTheme.apply(
      bodyColor: AppPallete.lightTextColor,
      fontFamily: 'ProductSans',
    ),
    inputDecorationTheme: InputDecorationTheme(
      errorStyle: const TextStyle(color: Colors.red),
      hintStyle: const TextStyle(color: AppPallete.lightHintTextColor),
      contentPadding: const EdgeInsets.all(16),
      enabledBorder: _border(),
      focusedBorder: _border(),
      errorBorder: _border(Colors.redAccent),
      focusedErrorBorder: _border(AppPallete.greyColor),
    ),
    outlinedButtonTheme: const OutlinedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(AppPallete.primaryColor),
        foregroundColor: WidgetStatePropertyAll(AppPallete.whiteColor),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        minimumSize: WidgetStatePropertyAll(Size(double.infinity, 45)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>((
          Set<WidgetState> states,
        ) {
          return AppPallete.primaryColor;
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((
          Set<WidgetState> states,
        ) {
          return AppPallete.whiteColor;
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 45)),
      ),
    ),
    dialogTheme: DialogTheme(backgroundColor: Colors.grey.shade200),
    cardTheme: CardTheme(color: AppPallete.lightCardColor),
  );

  static final darkThemeMode = ThemeData(
    scaffoldBackgroundColor: AppPallete.darkBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.darkBackgroundColor,
      foregroundColor: AppPallete.whiteColor,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppPallete.primaryColor,
      primary: AppPallete.primaryColor,
      secondary: AppPallete.primaryColor,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    textTheme: TextThemes.darkTextTheme.apply(
      bodyColor: AppPallete.darkTextColor,
      fontFamily: 'ProductSans',
    ),
    inputDecorationTheme: InputDecorationTheme(
      errorStyle: const TextStyle(color: Colors.red),
      hintStyle: const TextStyle(color: AppPallete.whiteColor),
      contentPadding: const EdgeInsets.all(16),
      enabledBorder: _border(AppPallete.greyColor),
      focusedBorder: _border(AppPallete.greyColor),
      errorBorder: _border(Colors.redAccent),
      focusedErrorBorder: _border(AppPallete.greyColor),
    ),
    outlinedButtonTheme: const OutlinedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(AppPallete.primaryColor),
        foregroundColor: WidgetStatePropertyAll(AppPallete.whiteColor),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        minimumSize: WidgetStatePropertyAll(Size(double.infinity, 45)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>((
          Set<WidgetState> states,
        ) {
          return AppPallete.primaryColor;
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((
          Set<WidgetState> states,
        ) {
          return AppPallete.whiteColor;
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 45)),
      ),
    ),
  );
}
