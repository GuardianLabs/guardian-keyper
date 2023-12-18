import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

part 'theme_dark.dart';

const clRed = Color(0xFFEC5F59);
const clGreen = Color(0xFF62D6CB);
const clGreenDark = Color(0xFF004D45);
const clYellow = Color(0xFFF19C38);

const paddingAll20 = EdgeInsets.all(20);
const paddingH20 = EdgeInsets.symmetric(horizontal: 20);
const paddingV6 = EdgeInsets.symmetric(vertical: 6);
const paddingV12 = EdgeInsets.symmetric(vertical: 12);
const paddingV20 = EdgeInsets.symmetric(vertical: 20);
const paddingV32 = EdgeInsets.symmetric(vertical: 32);
const paddingT12 = EdgeInsets.only(top: 12);
const paddingT20 = EdgeInsets.only(top: 20);
const paddingT32 = EdgeInsets.only(top: 32);
const paddingB12 = EdgeInsets.only(bottom: 12);
const paddingB20 = EdgeInsets.only(bottom: 20);
const paddingB32 = EdgeInsets.only(bottom: 32);

const styleW600 = TextStyle(fontWeight: FontWeight.w600);

// TBD: remove all
final styleSourceSansPro414 = GoogleFonts.sourceSans3(
  fontSize: 14,
  fontWeight: FontWeight.w400,
);

final styleSourceSansPro416 = GoogleFonts.sourceSans3(
  fontSize: 16,
  fontWeight: FontWeight.w400,
);

final styleSourceSansPro614 = GoogleFonts.sourceSans3(
  fontSize: 14,
  fontWeight: FontWeight.w600,
);

final styleSourceSansPro616 = GoogleFonts.sourceSans3(
  fontSize: 16,
  fontWeight: FontWeight.w600,
);
