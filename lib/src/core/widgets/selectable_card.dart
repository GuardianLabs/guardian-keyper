import 'package:flutter/material.dart';

import '../theme_data.dart';

class SelectableCard extends StatelessWidget {
  final Widget child;
  final bool isSelected;

  const SelectableCard({
    Key? key,
    required this.child,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: isSelected ? clIndigo500 : clIndigo700,
      ),
      child: Stack(
        children: [
          Positioned(
              top: -20,
              right: -30,
              child: Container(
                decoration: const BoxDecoration(
                  backgroundBlendMode: BlendMode.colorDodge,
                  shape: BoxShape.circle,
                  color: Colors.white10,
                ),
                height: 180,
                width: 180,
              )),
          Positioned(
              top: 30,
              right: 20,
              child: Container(
                decoration: const BoxDecoration(
                  backgroundBlendMode: BlendMode.colorDodge,
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.white10,
                    ],
                  ),
                ),
                height: 150,
                width: 150,
              )),
          Positioned(
              top: -30,
              right: -40,
              child: Container(
                decoration: const BoxDecoration(
                  backgroundBlendMode: BlendMode.colorDodge,
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white12,
                      Colors.transparent,
                    ],
                  ),
                ),
                height: 148,
                width: 148,
              )),
          Padding(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ],
      ),
    );
  }
}
