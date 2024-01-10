import 'package:flutter/widgets.dart';

sealed class ScreenSize {
  static EdgeInsets getPadding(BuildContext context) =>
      (ScreenSize(context) is ScreenSmall
          ? const EdgeInsets.symmetric(vertical: 12, horizontal: 20)
          : const EdgeInsets.symmetric(vertical: 32, horizontal: 20));

  factory ScreenSize(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return switch (size.height) {
      < ScreenSmall.height => ScreenSmall(size),
      < ScreenMedium.height => ScreenMedium(size),
      < ScreenLarge.height => ScreenLarge(size),
      _ => ScreenBig(size),
    };
  }

  const ScreenSize._(this.size);

  final Size size;

  bool get isSmall;

  bool get isBig;
}

class ScreenSmall extends ScreenSize {
  static const height = 600;

  const ScreenSmall(super.size) : super._();

  @override
  bool get isSmall => true;

  @override
  bool get isBig => false;
}

class ScreenMedium extends ScreenSize {
  static const height = 900;

  const ScreenMedium(super.size) : super._();

  @override
  bool get isSmall => true;

  @override
  bool get isBig => false;
}

class ScreenLarge extends ScreenSize {
  static const height = 1200;

  const ScreenLarge(super.size) : super._();

  @override
  bool get isSmall => false;

  @override
  bool get isBig => true;
}

class ScreenBig extends ScreenSize {
  static const height = 1600;

  const ScreenBig(super.size) : super._();

  @override
  bool get isSmall => false;

  @override
  bool get isBig => true;
}
