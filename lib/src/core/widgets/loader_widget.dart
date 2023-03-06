import 'package:flutter/material.dart';

import '/src/core/consts.dart';
import '/src/core/di_container.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/guardian/guardian_controller.dart';

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
  )..repeat(reverse: true);

  @override
  void initState() {
    super.initState();
    context.read<DIContainer>().init().then(
      (diContainer) async {
        _controller.stop();
        _controller.dispose();
        if (diContainer.boxSettings.passCode.isNotEmpty) {
          await diContainer.authService.checkPassCode(
            context: context,
            onUnlock: Navigator.of(context).pop,
            canCancel: false,
          );
        }
        await diContainer.networkService.start();
        if (context.mounted) {
          // Initialize lazy controller
          await context.read<GuardianController>().cleanMessageBox();
        }
        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed(routeHome);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        color: _backgroundColor,
        child: RotationTransition(
          turns: _controller,
          child: IconOf.app(size: _logoSize),
        ),
      );
}
