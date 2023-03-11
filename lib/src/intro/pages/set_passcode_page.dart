import '/src/core/consts.dart';
import '/src/core/widgets/common.dart';
import '/src/auth/auth_controller.dart';

import '../intro_controller.dart';

class SetPasscodePage extends StatefulWidget {
  const SetPasscodePage({super.key});

  @override
  State<SetPasscodePage> createState() => _SetPasscodePageState();
}

class _SetPasscodePageState extends State<SetPasscodePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_init);
  }

  @override
  Widget build(final BuildContext context) =>
      Container(color: Theme.of(context).colorScheme.background);

  Future<void> _init() async {
    final controller = context.read<IntroController>();
    await context.read<AuthController>().createPassCode(
          context: context,
          onConfirmed: () {
            if (controller.hasBiometrics) {
              Navigator.of(context).pop();
              // TBD: use PageControllerBase?
              controller.nextScreen();
            } else {
              Navigator.of(context).pushReplacementNamed(routeHome);
            }
          },
        );
  }
}
