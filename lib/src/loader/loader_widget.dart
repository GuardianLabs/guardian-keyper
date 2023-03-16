import 'package:flutter/material.dart';

import '/src/core/init.dart';
import '/src/core/consts.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/repository/repository_root.dart';

import '/src/auth/auth_case.dart';

class LoaderWidget extends StatefulWidget {
  const LoaderWidget({super.key});

  @override
  State<LoaderWidget> createState() => _LoaderWidgetState();
}

class _LoaderWidgetState extends State<LoaderWidget>
    with TickerProviderStateMixin {
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
      if (mounted &&
          GetIt.I<RepositoryRoot>()
              .settingsRepository
              .state
              .passCode
              .isNotEmpty) {
        await GetIt.I<AuthCase>().logIn(context);
      }
      if (mounted) Navigator.of(context).pushReplacementNamed(routeHome);
    });
  }

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
