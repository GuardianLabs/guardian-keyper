import 'package:flutter/material.dart';

import 'icon_of.dart';

class InitLoader extends StatefulWidget {
  const InitLoader({super.key});

  @override
  State<InitLoader> createState() => _InitLoaderState();
}

class _InitLoaderState extends State<InitLoader> with TickerProviderStateMixin {
  late final _logoSize = MediaQuery.of(context).size.width / 3;

  late final _backgroundColor = Theme.of(context).scaffoldBackgroundColor;

  late final _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => Container(
        alignment: Alignment.center,
        color: _backgroundColor,
        child: RotationTransition(
          turns: _controller,
          child: IconOf.app(size: _logoSize),
        ),
      );
}
