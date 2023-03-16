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
    _controller.createPassCode(
      context: context,
      onConfirmed: () => Navigator.of(context).pushReplacementNamed(routeHome),
      onConfirmedHasBiometrics: _controller.nextScreen,
    );
  }

  @override
  Widget build(final BuildContext context) =>
      Container(color: Theme.of(context).colorScheme.background);
}
