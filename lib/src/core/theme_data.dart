import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const clIndigo900 = Color(0xFF1A0244);
const clIndigo800 = Color(0xFF300077);
const clIndigo700 = Color(0xFF3C089F);
const clIndigo600 = Color(0xFF5600D6);
const clIndigo500 = Color(0xFF570FE4);
const clSurface = Color(0xFF24035F);
const clRed = Color(0xFFEC5F59);
const clGreen = Color(0xFF62D6CB);
const clGreenDark = Color(0xFF004D45);
const clBlue = Color(0xFF54BAF9);
const clYellow = Color(0xFFF19C38);
const clPurpleLight = Color(0xFFE6DEF8);
const clWhite = Colors.white;
const clBlack = Colors.black;

const paddingAll0 = EdgeInsets.all(0);
const paddingAll8 = EdgeInsets.all(8);
const paddingAll20 = EdgeInsets.all(20);
const paddingH20 = EdgeInsets.symmetric(horizontal: 20);
const paddingV6 = EdgeInsets.symmetric(vertical: 6);
const paddingV12 = EdgeInsets.symmetric(vertical: 12);
const paddingV20 = EdgeInsets.symmetric(vertical: 20);
const paddingV32 = EdgeInsets.symmetric(vertical: 32);
const paddingTop12 = EdgeInsets.only(top: 12);
const paddingTop20 = EdgeInsets.only(top: 20);
const paddingTop32 = EdgeInsets.only(top: 32);
const paddingBottom12 = EdgeInsets.only(bottom: 12);
const paddingBottom20 = EdgeInsets.only(bottom: 20);
const paddingBottom32 = EdgeInsets.only(bottom: 32);
const paddingV32H20 = EdgeInsets.symmetric(horizontal: 20, vertical: 32);

const textStyleBold = TextStyle(fontWeight: FontWeight.w600);

const radius8 = Radius.circular(8);

const borderRadiusTop = BorderRadius.vertical(top: radius8);

final borderRadius = BorderRadius.circular(8);

final boxDecoration = BoxDecoration(
  borderRadius: borderRadius,
  color: clSurface,
);

final boxDecorationStart = BoxDecoration(
  borderRadius: borderRadius,
  color: clIndigo500,
);

final textStyleSourceSansPro412 = GoogleFonts.sourceSansPro(
  fontSize: 12,
  fontWeight: FontWeight.w400,
);

final textStyleSourceSansPro412Purple = GoogleFonts.sourceSansPro(
  color: clPurpleLight,
  fontSize: 12,
  fontWeight: FontWeight.w400,
);

final textStyleSourceSansPro414 = GoogleFonts.sourceSansPro(
  fontSize: 14,
  fontWeight: FontWeight.w400,
);

final textStyleSourceSansPro414Purple = GoogleFonts.sourceSansPro(
  color: clPurpleLight,
  fontSize: 14,
  fontWeight: FontWeight.w400,
);

final textStyleSourceSansPro416 = GoogleFonts.sourceSansPro(
  fontSize: 16,
  fontWeight: FontWeight.w400,
);

final textStyleSourceSansPro416Purple = GoogleFonts.sourceSansPro(
  color: clPurpleLight,
  fontSize: 16,
  fontWeight: FontWeight.w400,
);

final textStyleSourceSansPro612 = GoogleFonts.sourceSansPro(
  fontSize: 12,
  fontWeight: FontWeight.w600,
);

final textStyleSourceSansPro612Purple = GoogleFonts.sourceSansPro(
  color: clPurpleLight,
  fontSize: 12,
  fontWeight: FontWeight.w600,
);

final textStyleSourceSansPro614 = GoogleFonts.sourceSansPro(
  fontSize: 14,
  fontWeight: FontWeight.w600,
);

final textStyleSourceSansPro614Purple = GoogleFonts.sourceSansPro(
  color: clPurpleLight,
  fontSize: 14,
  fontWeight: FontWeight.w600,
);

final textStyleSourceSansPro616 = GoogleFonts.sourceSansPro(
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

final textStylePoppins616 = GoogleFonts.poppins(
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

final textStylePoppins620 = GoogleFonts.poppins(
  fontSize: 20,
  fontWeight: FontWeight.w600,
);

final themeLight = ThemeData.light();

final themeDark = ThemeData.dark().copyWith(
  // Color Scheme
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: clWhite,
    onPrimary: clIndigo600,
    secondary: clIndigo700,
    onSecondary: clWhite,
    error: clRed,
    onError: clYellow,
    background: clIndigo900,
    onBackground: clBlue,
    surface: clSurface,
    onSurface: clWhite,
  ),
  scaffoldBackgroundColor: clIndigo900,
  backgroundColor: clIndigo900,
  canvasColor: clIndigo900,
  // AppBar
  appBarTheme: AppBarTheme(
    backgroundColor: clIndigo900,
    centerTitle: true,
    titleTextStyle: textStylePoppins616,
    toolbarHeight: 68,
  ),
  // Bottom Navigation Bar
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    backgroundColor: clIndigo900,
    selectedItemColor: clWhite,
    selectedLabelStyle: textStyleSourceSansPro612.copyWith(height: 2.5),
    unselectedLabelStyle: textStyleSourceSansPro412.copyWith(height: 2.5),
  ),
  // Bottom Sheet
  bottomSheetTheme: const BottomSheetThemeData(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
    topLeft: radius8,
    topRight: radius8,
  ))),
  // Card
  cardTheme: CardTheme(
    color: clSurface,
    elevation: 0,
    margin: paddingAll0,
    shape: _shapeBorder,
  ),
  // Elevated Button
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
    fixedSize: _fixedSizeHeight48,
    foregroundColor: _buttonForegroundColor,
    shape: _buttonShape,
    textStyle: MaterialStateProperty.all<TextStyle>(textStylePoppins616),
    backgroundColor: MaterialStateProperty.resolveWith<Color>((states) =>
        states.contains(MaterialState.disabled)
            ? const Color(0xFF320784)
            : clIndigo500),
  )),
  // Expansion Panel
  expansionTileTheme: const ExpansionTileThemeData(
    backgroundColor: clSurface,
    childrenPadding: paddingAll20,
  ),
  // Icon
  iconTheme: const IconThemeData(color: clWhite),
  // Input
  inputDecorationTheme: InputDecorationTheme(
    border: MaterialStateOutlineInputBorder.resolveWith(
      (states) {
        var borderWidth = 1.0;
        var borderColor = const Color(0x55E9F8FE);
        if (states.contains(MaterialState.focused)) {
          borderWidth = 2;
          borderColor = clBlue;
        }
        if (states.contains(MaterialState.error)) {
          borderColor = clRed;
        }
        return OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(width: borderWidth, color: borderColor),
        );
      },
    ),
    counterStyle: textStyleSourceSansPro412,
    helperStyle: textStyleSourceSansPro412,
    labelStyle: textStyleSourceSansPro412,
  ),
  // ListTile
  listTileTheme: ListTileThemeData(
    iconColor: clWhite,
    tileColor: clSurface,
    textColor: clWhite,
    shape: _shapeBorder,
  ),
  // Outlined Button
  outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
    fixedSize: _fixedSizeHeight48,
    foregroundColor: _buttonForegroundColor,
    side: MaterialStateProperty.resolveWith<BorderSide>(
      (states) => BorderSide(
          color: states.contains(MaterialState.disabled)
              ? const Color(0xFF2E4283)
              : clIndigo500),
    ),
    shape: _buttonShape,
    textStyle: MaterialStateProperty.all<TextStyle>(textStylePoppins616),
  )),
  // Radio
  radioTheme: RadioThemeData(
    fillColor: MaterialStateProperty.all<Color>(clWhite),
  ),
  // SnackBar
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: clGreen,
    behavior: SnackBarBehavior.floating,
    contentTextStyle: TextStyle(color: clGreenDark),
  ),
  // Switch
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.all<Color>(clWhite),
    trackColor: MaterialStateProperty.resolveWith<Color>((states) =>
        states.contains(MaterialState.selected) ? clBlue : clIndigo700),
  ),
  // TabBar
  tabBarTheme: TabBarTheme(
    indicator: const BoxDecoration(
      borderRadius: borderRadiusTop,
      color: clIndigo600,
    ),
    labelPadding: paddingAll0,
    labelColor: clWhite,
    labelStyle: textStyleSourceSansPro614,
    unselectedLabelColor: clWhite,
    unselectedLabelStyle: textStyleSourceSansPro614,
  ),
  // Text
  textTheme: TextTheme(
    caption: const TextStyle(
      color: clPurpleLight,
      fontSize: 10,
      fontWeight: FontWeight.w600,
    ),
    headline6: textStylePoppins620,
    subtitle1: textStyleSourceSansPro614,
    bodyText2: textStyleSourceSansPro414,
  ),
  // Text Button
  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
    foregroundColor: MaterialStateProperty.all<Color>(clWhite),
  )),
);

final _fixedSizeHeight48 =
    MaterialStateProperty.all<Size>(const Size(double.infinity, 48));

final _shapeBorder = RoundedRectangleBorder(borderRadius: borderRadius);

final _buttonShape = MaterialStateProperty.all<OutlinedBorder>(
    RoundedRectangleBorder(borderRadius: borderRadius));

final _buttonForegroundColor = MaterialStateProperty.resolveWith<Color>(
    (states) => states.contains(MaterialState.disabled)
        ? const Color(0xFF76678F)
        : clWhite);
