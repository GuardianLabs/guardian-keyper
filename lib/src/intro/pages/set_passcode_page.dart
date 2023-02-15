import '/src/core/di_container.dart';
import '/src/core/widgets/common.dart';

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
    final authService = context.read<DIContainer>().authService;
    Future.microtask(
      () => authService.createPassCode(
        context: context,
        onConfirmed: () async {
          final hasBiometrics = await authService.hasBiometrics;
          if (!mounted) return;
          if (hasBiometrics) {
            Navigator.of(context).pop();
            context.read<IntroController>().nextScreen();
          } else {
            Navigator.of(context).pushReplacementNamed('/home');
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) =>
      Container(color: Theme.of(context).colorScheme.background);
}
