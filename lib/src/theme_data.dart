import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'globals.dart';

final theme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: clIndigo900,
  // appBarTheme: const AppBarTheme(
  //   backgroundColor: clIndigo900,
  //   centerTitle: true,
  //   elevation: 0,
  //   iconTheme: IconThemeData(color: clIndigo500, size: 30),
  // ),
  listTileTheme: const ListTileThemeData(
    tileColor: clIndigo500,
  ),
);

final themeDark = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: clIndigo900,
  cardTheme: CardTheme(
    shape: RoundedRectangleBorder(borderRadius: borderRadius),
  ),
  listTileTheme: ListTileThemeData(
    tileColor: clIndigo500,
    shape: RoundedRectangleBorder(borderRadius: borderRadius),
  ),
  textTheme: GoogleFonts.interTextTheme().apply(
    displayColor: Colors.white,
    bodyColor: Colors.white,
  ),
);
