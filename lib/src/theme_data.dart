import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const clIndigo900 = Color(0xFF1A0244);
const clIndigo800 = Color(0xFF240360);
const clIndigo700 = Color(0xFF2B0472);
const clIndigo500 = Color(0xFF4300A7);
const clRed = Color(0xFFFF5252);
const clYellow = Color(0xFFFF9800);
const clGreen = Color(0xFF00D9CC);
const clBlue = Color(0xFF54BAF9);
const clPurpleLight = Color(0xFFD8C7FA);
const clWhite = Colors.white;
const clWhite50 = Color(0xFFE6F9FF);

final borderRadius = BorderRadius.circular(8);

final decorBlueButton = BoxDecoration(
    borderRadius: borderRadius,
    gradient: const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF7BE7FF),
        Color(0xFF3AABF0),
      ],
    ));

final theme = ThemeData.light();

final themeDark = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: clIndigo900,
  cardTheme: CardTheme(
    color: clIndigo700,
    shape: RoundedRectangleBorder(borderRadius: borderRadius),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(8),
    ),
    filled: true,
    fillColor: clIndigo800,
  ),
  listTileTheme: ListTileThemeData(
    iconColor: clWhite,
    tileColor: clIndigo700,
    textColor: clWhite,
    shape: RoundedRectangleBorder(borderRadius: borderRadius),
  ),
  textTheme: GoogleFonts.sourceSansProTextTheme().copyWith(
    caption: const TextStyle(
      color: clPurpleLight,
      fontSize: 10,
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
