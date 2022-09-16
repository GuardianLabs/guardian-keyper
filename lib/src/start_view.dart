import 'core/theme_data.dart';
import 'core/di_container.dart';
import 'core/widgets/auth.dart';
import 'core/widgets/common.dart';

import 'intro/intro_view.dart';
import 'home/home_view.dart';

class StartView extends StatefulWidget {
  const StartView({super.key});

  @override
  State<StartView> createState() => _StartViewState();
}

class _StartViewState extends State<StartView> {
  @override
  void initState() {
    super.initState();
    final diContainer = context.read<DIContainer>();
    Future.microtask(
      diContainer.boxSettings.passCode.isEmpty
          ? () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const IntroView()))
          : () => screenLock(
                context: context,
                correctString: diContainer.boxSettings.passCode,
                canCancel: false,
                digits: diContainer.boxSettings.passCode.length,
                keyPadConfig: keyPadConfig,
                secretsConfig: secretsConfig,
                screenLockConfig: screenLockConfig,
                customizedButtonChild: BiometricLogonButton(
                  callback: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomeView()),
                    (_) => false,
                  ),
                ),
                customizedButtonTap: () {}, // Fails if null
                title: Padding(
                    padding: paddingV32,
                    child: Text(
                      'Please enter your current passcode',
                      style: textStylePoppins620,
                      textAlign: TextAlign.center,
                    )),
                didUnlocked: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const HomeView()),
                  (_) => false,
                ),
                didError: (_) async {
                  ScaffoldMessenger.of(context).showSnackBar(buildSnackBar(
                    text: 'Wrong passcode!',
                    duration: const Duration(seconds: 2),
                    isFloating: true,
                    isError: true,
                  ));
                  await diContainer.platformService.vibrate();
                },
              ),
    );
  }

  @override
  Widget build(BuildContext context) => const Scaffold();
}
