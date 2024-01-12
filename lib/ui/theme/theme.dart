import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/theme/brand_colors.dart';

part 'theme_dark.dart';
part 'theme_light.dart';

final textTheme = ThemeData().textTheme.copyWith(
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
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    elevation: 0,
    shadowColor: Colors.transparent,
    toolbarHeight: toolbarHeight,
  ),
  // Bottom Navigation Bar
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedLabelStyle: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w700,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w400,
    ),
  ),
  // Bottom Sheet
  bottomSheetTheme: const BottomSheetThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(cornerRadius)),
    ),
    showDragHandle: true,
  ),
  // Card
  cardTheme: CardTheme(
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(cornerRadius),
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
      borderRadius: BorderRadius.circular(cornerRadius),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(cornerRadius),
    ),
  ),
  // Filled Button
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      fixedSize: const MaterialStatePropertyAll(Size(
        double.infinity,
        buttonSize,
      )),
      textStyle: MaterialStatePropertyAll(textTheme.titleMedium),
    ),
  ),
  // Font family
  fontFamily: GoogleFonts.sourceSans3().fontFamily,
  // Input
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(cornerRadius),
      borderSide: const BorderSide(width: 2),
    ),
    floatingLabelStyle: textTheme.labelMedium,
    labelStyle: textTheme.bodySmall,
    helperStyle: textTheme.bodySmall,
    helperMaxLines: 1,
  ),
  // ListTile
  listTileTheme: ListTileThemeData(
    titleTextStyle: textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w600,
      overflow: TextOverflow.ellipsis,
    ),
    subtitleTextStyle: textTheme.bodySmall,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(cornerRadius),
    ),
  ),
  // Outlined Button
  outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
    fixedSize: const MaterialStatePropertyAll(Size(
      double.infinity,
      buttonSize,
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
