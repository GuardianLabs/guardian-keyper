import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vector_graphics/vector_graphics_compat.dart';

import 'package:guardian_keyper/ui/theme/theme.dart';

class Splash extends StatefulWidget {
  const Splash({
    this.brightness,
    super.key,
  });

  @override
  State<Splash> createState() => _SplashState();

  final Brightness? brightness;
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  late final _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat();

  late bool _isSystemThemeDark;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isSystemThemeDark =
        (widget.brightness ?? MediaQuery.of(context).platformBrightness) ==
            Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(
      _isSystemThemeDark ? systemStyleDark : systemStyleLight,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width / 3;
    return Container(
      alignment: Alignment.center,
      color:
          _isSystemThemeDark ? darkTheme.canvasColor : lightTheme.canvasColor,
      child: RotationTransition(
        turns: _controller,
        child: SvgPicture(
          const AssetBytesLoader('assets/images/logo.svg.vec'),
          height: size,
          width: size,
        ),
      ),
    );
  }
}
