import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'brand_colors.dart';

part 'theme_dark.dart';
part 'theme_light.dart';

final textTheme = TextTheme(
  bodyLarge: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
  bodyMedium: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ),
  bodySmall: const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  ),
  headlineLarge: GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.w600,
  ),
  headlineMedium: GoogleFonts.poppins(
    fontSize: 30,
    fontWeight: FontWeight.w500,
  ),
  headlineSmall: GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w400,
  ),
  labelLarge: const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),
  labelMedium: const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  ),
  labelSmall: const TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
  ),
  titleLarge: GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  ),
  titleMedium: GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ),
  titleSmall: GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  ),
);

final themeData = ThemeData(
  // AppBar
  appBarTheme: AppBarTheme(
    centerTitle: true,
    titleTextStyle: textTheme.titleMedium,
    toolbarHeight: 68,
  ),
  // Bottom Navigation Bar
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedLabelStyle: textTheme.labelMedium,
    unselectedLabelStyle: textTheme.labelSmall,
  ),
  // Bottom Sheet
  bottomSheetTheme: const BottomSheetThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
    ),
  ),
  // Card
  cardTheme: CardTheme(
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  // Divider
  dividerTheme: const DividerThemeData(
    thickness: 2,
  ),
  // Expansion Panel
  expansionTileTheme: ExpansionTileThemeData(
    childrenPadding: const EdgeInsets.all(20),
    collapsedShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  // Filled Button
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      fixedSize: const MaterialStatePropertyAll(Size(double.infinity, 48)),
      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      )),
      textStyle: MaterialStatePropertyAll(textTheme.titleMedium),
    ),
  ),
  // Font family
  fontFamily: GoogleFonts.sourceSans3().fontFamily,
  // Input
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        width: 2,
      ),
    ),
    floatingLabelStyle: textTheme.labelMedium,
  ),
  // ListTile
  listTileTheme: ListTileThemeData(
    titleTextStyle: textTheme.bodyMedium?.copyWith(
      overflow: TextOverflow.ellipsis,
    ),
    subtitleTextStyle: textTheme.bodySmall,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  // Outlined Button
  outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
    fixedSize: const MaterialStatePropertyAll(Size(double.infinity, 48)),
    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    )),
    textStyle: MaterialStatePropertyAll(textTheme.titleMedium),
  )),
  // SnackBar
  snackBarTheme: const SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    showCloseIcon: true,
  ),
  // Text
  textTheme: textTheme,
);
