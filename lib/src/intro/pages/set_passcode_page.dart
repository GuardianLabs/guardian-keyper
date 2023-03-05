import '/src/core/consts.dart';
import '/src/core/widgets/common.dart';

import '../intro_controller.dart';

class SetPasscodePage extends StatefulWidget {
  const SetPasscodePage({super.key});

  @override
  State<SetPasscodePage> createState() => _SetPasscodePageState();
}

class _SetPasscodePageState extends State<SetPasscodePage> {
  late final _controller = context.read<IntroController>();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => _controller.diContainer.authService.createPassCode(
        context: context,
        onConfirmed: () async {
          if (await _controller.diContainer.authService.hasBiometrics) {
            if (mounted) {
              Navigator.of(context).pop();
              _controller.nextScreen();
            }
          } else if (mounted) {
            Navigator.of(context).pushReplacementNamed(routeHome);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) =>
      Container(color: Theme.of(context).colorScheme.background);
}
