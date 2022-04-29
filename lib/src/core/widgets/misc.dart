import 'package:flutter/material.dart';

import '../theme_data.dart';

class CircleNumber extends StatelessWidget {
  final double size;
  final int number;

  const CircleNumber({
    Key? key,
    this.size = 24,
    required this.number,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
        shape: BoxShape.circle,
      ),
      height: size,
      width: size,
      child: Center(child: Text(number.toString())),
    );
  }
}

class NumberedListWidget extends StatelessWidget {
  final List<String> list;

  const NumberedListWidget({Key? key, required this.list}) : super(key: key);

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
                    style: textStyleSourceSansProRegular14,
                  ),
                ),
              ]),
            )
        ],
      );
}

class DotColored extends StatelessWidget {
  final Color color;
  final double size;

  const DotColored({
    Key? key,
    this.color = Colors.white,
    this.size = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        height: size,
        width: size,
      );
}

class DotBar extends StatelessWidget {
  final int count;
  final int active;
  const DotBar({
    Key? key,
    this.active = 0,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < count; i++)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child:
                  DotColored(color: i == active ? Colors.white : clIndigo700),
            ),
        ],
      );
}
