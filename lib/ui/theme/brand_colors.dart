import 'package:flutter/material.dart';

@immutable
class BrandColors extends ThemeExtension<BrandColors> {
  const BrandColors({
    this.highlightColor = const Color(0xFF62D6CB),
    this.warningColor = const Color(0xFFFF9800),
    this.dangerColor = const Color(0xFFFF5252),
  });

  final Color highlightColor;
  final Color warningColor;
  final Color dangerColor;

  @override
  BrandColors copyWith({
    Color? highlightColor,
    Color? warningColor,
    Color? dangerColor,
  }) =>
      BrandColors(
        highlightColor: highlightColor ?? this.highlightColor,
        warningColor: warningColor ?? this.warningColor,
        dangerColor: dangerColor ?? this.dangerColor,
      );

  @override
  BrandColors lerp(BrandColors? other, double t) => other == null
      ? this
      : BrandColors(
          highlightColor: Color.lerp(
            highlightColor,
            other.highlightColor,
            t,
          )!,
          warningColor: Color.lerp(
            warningColor,
            other.warningColor,
            t,
          )!,
          dangerColor: Color.lerp(
            dangerColor,
            other.dangerColor,
            t,
          )!,
        );
}
