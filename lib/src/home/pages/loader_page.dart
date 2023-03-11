import 'package:flutter/material.dart';

import '/src/core/init.dart';
import '/src/core/consts.dart';
import '/src/core/widgets/icon_of.dart';

import '/src/auth/auth_controller.dart';
import '/src/settings/settings_controller.dart';

class LoaderPage extends StatefulWidget {
  const LoaderPage({super.key});

  @override
  State<LoaderPage> createState() => _LoaderPageState();
}

class _LoaderPageState extends State<LoaderPage> with TickerProviderStateMixin {
  late final _logoSize = MediaQuery.of(context).size.width / 3;

  late final _backgroundColor = Theme.of(context).scaffoldBackgroundColor;

  late final _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await init();
      _controller.stop();
      _controller.dispose();
      if (mounted && GetIt.I<SettingsController>().state.passCode.isNotEmpty) {
        await GetIt.I<AuthController>().checkPassCode(
          context: context,
          canCancel: false,
          onUnlock: Navigator.of(context).pop,
        );
      }
      if (mounted) Navigator.of(context).pushReplacementNamed(routeHome);
    });
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
