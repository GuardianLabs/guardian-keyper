import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

part 'fonts.dart';
part 'theme_dark.dart';
part 'theme_light.dart';

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

const radius8 = Radius.circular(8);

const borderRadiusTop10 = BorderRadius.vertical(top: Radius.circular(10));

final borderRadius = BorderRadius.circular(8);

final boxDecoration = BoxDecoration(
  borderRadius: borderRadius,
  color: clSurface,
);

final boxDecorationStart = BoxDecoration(
  borderRadius: borderRadius,
  color: clIndigo500,
);

final _fixedSizeHeight48 = MaterialStateProperty.all<Size>(
  const Size(double.infinity, 48),
);

final _shapeBorder = RoundedRectangleBorder(borderRadius: borderRadius);

final _buttonShape = MaterialStateProperty.all<OutlinedBorder>(
  RoundedRectangleBorder(borderRadius: borderRadius),
);

final _buttonForegroundColor = MaterialStateProperty.resolveWith<Color>(
  (states) => states.contains(MaterialState.disabled)
      ? const Color(0xFF76678F)
      : clWhite,
);
