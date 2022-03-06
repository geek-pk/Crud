import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

final lightTheme = ThemeData(
  primarySwatch: primarySwatchLight,
  scaffoldBackgroundColor: colorCard,
  primaryColor: colorPrimary,
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    backgroundColor: colorAppBarBackground,
    titleTextStyle: fontStyleLight.copyWith(fontSize: 18, color: colorFont),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: colorBlack,
    circularTrackColor: colorGrey,
    refreshBackgroundColor: colorBlack,
  ),
  textTheme: TextTheme(
    headlineLarge: fontStyleLight.copyWith(fontSize: 18),
    headlineMedium: fontStyleLight.copyWith(fontSize: 16),
    headlineSmall: fontStyleLight.copyWith(fontSize: 14),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(color: colorPrimary),
    focusedBorder:
        OutlineInputBorder(borderSide: BorderSide(color: colorPrimary)),
    border: OutlineInputBorder(
        borderSide: BorderSide(color: colorPrimary, width: 0.2)),
  ),
  textSelectionTheme: const TextSelectionThemeData(
      selectionHandleColor: colorPrimary,
      selectionColor: colorPrimary,
      cursorColor: colorPrimary),
);

final fontStyleLight =
    GoogleFonts.roboto(fontWeight: FontWeight.bold, color: colorFont);
