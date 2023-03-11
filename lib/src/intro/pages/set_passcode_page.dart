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
  late final _controller = context.read<IntroController>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async => await GetIt.I<AuthController>().createPassCode(
          context: context,
          onConfirmed: () {
            if (_controller.hasBiometrics) {
              Navigator.of(context).pop();
              // TBD: use PageControllerBase?
              _controller.nextScreen();
            } else {
              Navigator.of(context).pushReplacementNamed(routeHome);
            }
          },
        ));
  }

  @override
  Widget build(final BuildContext context) =>
      Container(color: Theme.of(context).colorScheme.background);
}
