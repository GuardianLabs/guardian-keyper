import 'package:flutter/material.dart';

import '../theme_data.dart';

export 'package:flutter/material.dart';

class CircleNumber extends StatelessWidget {
  final double size;
  final int number;

  const CircleNumber({super.key, this.size = 24, required this.number});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent),
          shape: BoxShape.circle,
        ),
        height: size,
        width: size,
        child: Center(child: Text(number.toString())),
      );
}

class NumberedListWidget extends StatelessWidget {
  final List<String> list;

  const NumberedListWidget({super.key, required this.list});

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < list.length; i++)
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: Row(children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: CircleNumber(number: i + 1),
                ),
                Expanded(
                  child: Text(
                    list[i],
                    softWrap: true,
                    style: textStyleSourceSansPro414,
                  ),
                ),
              ]),
            )
        ],
      );
}

class DotColored extends StatelessWidget {
  final Widget? child;
  final Color color;
  final double size;

  const DotColored({
    super.key,
    this.child,
    this.color = clWhite,
    this.size = 8,
  });

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        height: size,
        width: size,
        child: child,
      );
}

class DotBar extends StatelessWidget {
  final int count;
  final int active;
  final Color activeColor;
  final Color passiveColor;

  const DotBar({
    super.key,
    required this.count,
    this.active = 0,
    this.activeColor = clWhite,
    this.passiveColor = clIndigo700,
  });

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < count; i++)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child:
                  DotColored(color: i == active ? activeColor : passiveColor),
            ),
        ],
      );
}

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
