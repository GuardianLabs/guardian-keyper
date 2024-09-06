import 'package:flutter/material.dart';

class StyledIcon extends StatelessWidget {
  static const defaultIconSize = 40.0;

  final IconData icon;
  final double size;
  final Color? color;
  final Color? bgColor;
  final double scale;
  final bool outlined;

  const StyledIcon({
    required this.icon,
    this.size = defaultIconSize,
    this.color,
    this.bgColor = Colors.transparent,
    this.scale = 0.7,
    this.outlined = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(
      icon,
      size: size * scale,
      color: color,
    );

    return bgColor == null
        ? iconWidget
        : Container(
            decoration: outlined
                ? BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: bgColor ?? Colors.transparent,
                      width: 2,
                    ))
                : BoxDecoration(color: bgColor, shape: BoxShape.circle),
            height: size,
            width: size,
            child: Center(child: iconWidget),
          );
  }
}
