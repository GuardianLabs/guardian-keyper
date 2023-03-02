import 'package:flutter/material.dart';

import '/src/core/theme/theme.dart';

class SelectableCard extends StatelessWidget {
  final Widget child;
  final bool isSelected;

  const SelectableCard({
    super.key,
    required this.child,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) => Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: isSelected ? clIndigo500 : clSurface,
        ),
        child: Stack(
          children: [
            Positioned(
              top: -20,
              right: -30,
              child: Container(
                height: 180,
                width: 180,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white10,
                ),
              ),
            ),
            Positioned(
              top: 30,
              right: 20,
              child: Container(
                height: 150,
                width: 150,
                decoration: const BoxDecoration(
                  backgroundBlendMode: BlendMode.colorDodge,
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.white10],
                  ),
                ),
              ),
            ),
            Positioned(
              top: -30,
              right: -40,
              child: Container(
                height: 148,
                width: 148,
                decoration: const BoxDecoration(
                  backgroundBlendMode: BlendMode.colorDodge,
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white12, Colors.transparent],
                  ),
                ),
              ),
            ),
            Padding(padding: paddingAll20, child: child),
          ],
        ),
      );
}
