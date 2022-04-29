import 'package:flutter/material.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/icon_of.dart';

class ShieldsRow extends StatelessWidget {
  final bool isInSquare;
  final int highlighted;
  final int total;

  const ShieldsRow({
    Key? key,
    required this.total,
    required this.highlighted,
    this.isInSquare = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < total; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: isInSquare
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      color: highlighted > i ? clGreen : clIndigo600,
                    ),
                    height: 60,
                    width: 60,
                    child: IconOf.shield(
                      radius: 30,
                      size: 30,
                      bgColor: highlighted > i ? clGreen : clIndigo600,
                    ),
                  )
                : IconOf.shield(
                    radius: 16,
                    size: 20,
                    bgColor: highlighted > i ? clGreen : clIndigo600,
                  ),
          ),
      ],
    );
  }
}
