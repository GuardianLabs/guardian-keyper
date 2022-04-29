import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const heightBig = 926;
const heightMedium = 812;
const heightSmall = 640;

const clIndigo900 = Color(0xFF1A0244);
const clIndigo800 = Color(0xFF240360);
const clIndigo700 = Color(0xFF2B0472);
const clIndigo600 = Color(0xFF3C089F);
const clIndigo500 = Color(0xFF570FE4);
const clCyan500 = Color(0xFF54BAF9);
const clCyan50 = Color(0x55E9F8FE);
const clRed = Color(0xFFEC5F59);
const clYellow = Color(0xFFF19C38);
const clGreen = Color(0xFF00D9CC);
const clBlue = Color(0xFF54BAF9);
const clPurpleLight = Color(0xFFE6DEF8);
const clWhite = Colors.white;
const clWhite50 = Color(0xFFE6F9FF);

const paddingAll0 = EdgeInsets.all(0);
const paddingAll8 = EdgeInsets.all(8);
const paddingAll20 = EdgeInsets.all(20);
const paddingH20 = EdgeInsets.symmetric(horizontal: 20);
const paddingH20V1 = EdgeInsets.symmetric(horizontal: 20, vertical: 1);
const paddingH20V5 = EdgeInsets.symmetric(horizontal: 20, vertical: 5);
const paddingH20V10 = EdgeInsets.symmetric(horizontal: 20, vertical: 10);
const paddingV20 = EdgeInsets.symmetric(vertical: 20);
const paddingTop10 = EdgeInsets.only(top: 10);
const paddingTop20 = EdgeInsets.only(top: 20);
const paddingTop40 = EdgeInsets.only(top: 40);
const paddingBottom10 = EdgeInsets.only(bottom: 10);
const paddingBottom20 = EdgeInsets.only(bottom: 20);
const paddingFooter = EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 50);

final borderRadius = BorderRadius.circular(8);

final boxDecoration =
    BoxDecoration(borderRadius: borderRadius, color: clIndigo700);

final textStyleSourceSansProRegular12 =
    GoogleFonts.sourceSansPro(fontSize: 12, fontWeight: FontWeight.w400);

final textStyleSourceSansProBold12 =
    GoogleFonts.sourceSansPro(fontSize: 12, fontWeight: FontWeight.w600);

final textStyleSourceSansProRegular14 =
    GoogleFonts.sourceSansPro(fontSize: 14, fontWeight: FontWeight.w400);

final textStyleSourceSansProBold14 =
    GoogleFonts.sourceSansPro(fontSize: 14, fontWeight: FontWeight.w600);

final textStyleSourceSansProBold14Blue = GoogleFonts.sourceSansPro(
    fontSize: 14, fontWeight: FontWeight.w600, color: clBlue);

final textStyleSourceSansProRegular16 =
    GoogleFonts.sourceSansPro(fontSize: 16, fontWeight: FontWeight.w400);

final textStyleSourceSansProBold16Blue = GoogleFonts.sourceSansPro(
    fontSize: 16, fontWeight: FontWeight.w600, color: clBlue);

final textStyleSourceSansProBold16 =
    GoogleFonts.sourceSansPro(fontSize: 16, fontWeight: FontWeight.w600);

final textStyleSourceSansProBold20 =
    GoogleFonts.sourceSansPro(fontSize: 20, fontWeight: FontWeight.w600);

final textStylePoppinsBold10 =
    GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600);

final textStylePoppinsBold12 =
    GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600);

final textStylePoppinsBold14 =
    GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600);

final textStylePoppinsBold16 =
    GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600);

final textStylePoppinsBold16Blue = GoogleFonts.poppins(
    fontSize: 16, fontWeight: FontWeight.w600, color: clBlue);

final textStylePoppinsBold20 =
    GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600);

final textStylePoppinsBold20Blue = GoogleFonts.poppins(
    fontSize: 20, fontWeight: FontWeight.w600, color: clBlue);

//TBD
final textStyleLinkBig = GoogleFonts.spaceGrotesk(
    fontSize: 20, fontWeight: FontWeight.w700, color: clBlue);

//TBD
final textStyleLinkSmall = GoogleFonts.spaceGrotesk(
    fontSize: 12, fontWeight: FontWeight.w700, color: clBlue);

final buttonStyleSecondary = ButtonStyle(
  fixedSize: _fixedSizeHeight48,
  textStyle: MaterialStateProperty.all<TextStyle>(textStylePoppinsBold16),
);

final buttonStyleDestructive = ButtonStyle(
  fixedSize: _fixedSizeHeight48,
  backgroundColor: MaterialStateProperty.all<Color>(clWhite),
  foregroundColor: MaterialStateProperty.all<Color>(const Color(0xFFEC5F59)),
  shape: _buttonShape,
  textStyle: MaterialStateProperty.all<TextStyle>(textStylePoppinsBold16),
);

final themeLight = ThemeData.light();

final themeDark = ThemeData.dark().copyWith(
  // Color Scheme
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: clWhite,
    onPrimary: clIndigo600,
    secondary: clIndigo500,
    onSecondary: clWhite,
    error: clRed,
    onError: clYellow,
    background: clIndigo900,
    onBackground: clCyan500,
    surface: clIndigo700,
    onSurface: clWhite,
  ),
  scaffoldBackgroundColor: clIndigo900,
  canvasColor: clIndigo900,
  // Elevated Button
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
    fixedSize: _fixedSizeHeight40,
    foregroundColor: _buttonForegroundColor,
    shape: _buttonShape,
    textStyle: MaterialStateProperty.all<TextStyle>(textStylePoppinsBold14),
    backgroundColor: MaterialStateProperty.resolveWith<Color>((states) =>
        states.contains(MaterialState.disabled)
            ? const Color(0xFF320784)
            : clIndigo500),
  )),
  // Outlined Button
  outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
    fixedSize: _fixedSizeHeight40,
    foregroundColor: _buttonForegroundColor,
    side: MaterialStateProperty.resolveWith<BorderSide>(
      (states) => BorderSide(
          color: states.contains(MaterialState.disabled)
              ? const Color(0xFF2E4283)
              : clCyan500),
    ),
    shape: _buttonShape,
    textStyle:
        MaterialStateProperty.all<TextStyle>(textStyleSourceSansProBold14),
  )),
  // Text Button
  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
    foregroundColor: MaterialStateProperty.all<Color>(clWhite),
  )),
  // Card
  cardTheme: CardTheme(
    color: clIndigo700,
    elevation: 0,
    margin: paddingAll0,
    shape: _shapeBorder,
  ),
  // Icon
  iconTheme: const IconThemeData(color: clIndigo600),
  // Input
  inputDecorationTheme: InputDecorationTheme(
    border: MaterialStateOutlineInputBorder.resolveWith(
      (states) {
        double borderWidth = 1;
        Color borderColor = clCyan50;
        if (states.contains(MaterialState.focused)) {
          borderWidth = 2;
          borderColor = clCyan500;
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
    helperStyle: textStyleSourceSansProRegular14,
  ),
  // ListTile
  listTileTheme: ListTileThemeData(
    iconColor: clWhite,
    tileColor: clIndigo700,
    textColor: clWhite,
    shape: _shapeBorder,
  ),
  // Text
  textTheme: TextTheme(
    caption: const TextStyle(
      color: clPurpleLight,
      fontSize: 10,
      fontWeight: FontWeight.w600,
    ),
    headline6: GoogleFonts.poppins(
      color: clWhite,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    subtitle1: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: clWhite,
    ),
    bodyText2: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: clWhite,
    ),
  ),
);

final _fixedSizeHeight40 =
    MaterialStateProperty.all<Size>(const Size(double.infinity, 40));

final _fixedSizeHeight48 =
    MaterialStateProperty.all<Size>(const Size(double.infinity, 48));

final _shapeBorder = RoundedRectangleBorder(borderRadius: borderRadius);

final _buttonShape = MaterialStateProperty.all<OutlinedBorder>(
    RoundedRectangleBorder(borderRadius: borderRadius));

final _buttonForegroundColor = MaterialStateProperty.resolveWith<Color>(
    (states) => states.contains(MaterialState.disabled)
        ? const Color(0xFF76678F)
        : clWhite);
