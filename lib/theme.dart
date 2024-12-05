import 'package:flutter/material.dart';
import 'package:edmyn/shared/styling.dart' as styling;

ThemeData lightTheme = ThemeData(
  fontFamily: 'NotoSans',
  brightness: Brightness.light,
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
      seedColor: styling.kPrimaryColor,
      primary: styling.kPrimaryColor,
      surface: styling.kBackgroundColor),
  scaffoldBackgroundColor: styling.kBackgroundColor,
  shadowColor: styling.kShadowColor,
  textTheme: const TextTheme(
    // Large Display text
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      color: styling.kPrimaryTextColor,
    ),
    // Page Titles
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w400,
      color: styling.kPrimaryTextColor,
    ),
    // Headlines
    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: styling.kPrimaryTextColor,
    ),
    // Sub headlines
    headlineSmall: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: styling.kPrimaryTextColor,
    ),
    // Body Text
    bodyLarge: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w400,
      color: styling.kPrimaryTextColor,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: styling.kPrimaryTextColor,
    ),
    bodySmall: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: styling.kPrimaryTextColor,
    ),
    // Captions
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: styling.kPrimaryTextColor,
    ),
    labelMedium: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: styling.kPrimaryTextColor,
    ),
  ),
  appBarTheme: const AppBarTheme(
    color: styling.kPrimaryColor,
    iconTheme: IconThemeData(color: Colors.white),
    centerTitle: true,
    foregroundColor: styling.kLightTextColor,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: styling.kLightTextColor,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    isDense: true,
    filled: true,
    fillColor: styling.kDefaultFieldFillColor,
    floatingLabelBehavior: FloatingLabelBehavior.never,
    labelStyle: const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: styling.kSecondaryTextColor,
    ),
    hintStyle: const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      color: styling.kTertiaryTextColor,
    ),
    errorStyle: const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      color: styling.kErrorTextColor,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(
        color: styling.kDefaultFieldBorderColor,
        width: 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(
        color: styling.kActiveFieldBorderColor,
        width: 1,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(
        color: styling.kErrorFieldBorderColor,
        width: 1,
      ),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      backgroundColor:
          WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.pressed)) {
          return styling.kPrimaryColor;
        } else if (states.contains(WidgetState.hovered)) {
          return styling.kButtonHoverColor;
        }
        return styling.kPrimaryColor;
      }),
      shape: WidgetStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      minimumSize: WidgetStateProperty.all<Size>(const Size(48, 48)),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor:
          WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.pressed)) {
          return styling.kPrimaryColor;
        } else if (states.contains(WidgetState.hovered)) {
          return styling.kButtonHoverColor;
        }
        return styling.kPrimaryColor;
      }),
      shape: WidgetStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      minimumSize: WidgetStateProperty.all<Size>(const Size(48, 48)),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      side: WidgetStateProperty.all<BorderSide>(
        const BorderSide(
          color: styling.kPrimaryBorderColor,
        ),
      ),
      minimumSize: WidgetStateProperty.all<Size>(const Size(48, 48)),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      minimumSize: WidgetStateProperty.all<Size>(const Size(48, 48)),
    ),
  ),
  snackBarTheme: const SnackBarThemeData(
    contentTextStyle: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: styling.kLightTextColor,
    ),
    elevation: 2.0,
    behavior: SnackBarBehavior.floating,
  ),
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 8.0,
    clipBehavior: Clip.hardEdge,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    shadowColor: styling.kShadowColor,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: styling.kPrimaryColor,
    foregroundColor: styling.kLightColor,
  ),
  dividerTheme: const DividerThemeData(
      color: styling.kDividerColor, thickness: 1.0, indent: 8, endIndent: 8),
);
