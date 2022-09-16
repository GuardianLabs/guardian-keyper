import '/src/core/di_container.dart';
import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/auth.dart';

import '/src/home/home_view.dart';

import '../intro_controller.dart';

class SetPasscodePage extends StatefulWidget {
  const SetPasscodePage({super.key});

  @override
  State<SetPasscodePage> createState() => _SetPasscodePageState();
}

class _SetPasscodePageState extends State<SetPasscodePage> {
  final _passcodeController = InputController();
  @override
  void initState() {
    super.initState();
    Future.microtask(_createPincode);
  }

  @override
  void dispose() {
    _passcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Container(color: Theme.of(context).colorScheme.background);

  void _createPincode() {
    final diContainer = context.read<DIContainer>();
    screenLock(
      context: context,
      correctString: '',
      canCancel: false,
      confirmation: true,
      digits: diContainer.globals.passCodeLength,
      keyPadConfig: keyPadConfig,
      secretsConfig: secretsConfig,
      screenLockConfig: screenLockConfig,
      inputController: _passcodeController,
      title: Padding(
          padding: paddingV32H20,
          child: Text(
            'Create your passcode',
            style: textStylePoppins620,
            textAlign: TextAlign.center,
          )),
      confirmTitle: Padding(
          padding: paddingV32H20,
          child: Text(
            'Enter it once more',
            style: textStylePoppins620,
            textAlign: TextAlign.center,
          )),
      customizedButtonChild: Text(
        'Reset',
        style: textStyleSourceSansPro416.copyWith(fontSize: 18),
        textAlign: TextAlign.center,
      ),
      customizedButtonTap: _passcodeController.unsetConfirmed,
      didConfirmed: (value) {
        diContainer.boxSettings.passCode = value;
        if (diContainer.platformService.hasBiometrics) {
          context.read<IntroController>().nextScreen();
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomeView()),
            (route) => false,
          );
        }
      },
      didError: (_) async {
        ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(
          text: 'Wrong passcode!',
          duration: const Duration(seconds: 2),
          isFloating: true,
          isError: true,
        ));
        await diContainer.platformService.vibrate();
      },
    );
  }
}
