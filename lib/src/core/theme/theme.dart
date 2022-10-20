import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

part 'colors.dart';
part 'fonts.dart';
part 'theme_dark.dart';

final themeLight = ThemeData.light();

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
