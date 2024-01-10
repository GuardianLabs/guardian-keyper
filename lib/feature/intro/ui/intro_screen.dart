import 'package:guardian_keyper/ui/widgets/common.dart';

import 'intro_presenter.dart';
import 'pages/intros_page.dart';
import 'pages/set_passcode_page.dart';
import 'pages/set_biometric_page.dart';
import 'pages/set_device_name_page.dart';

class IntroScreen extends StatelessWidget {
  static const route = '/intro';

  static const _pages = [
    IntrosPage(),
    SetDeviceNamePage(),
    SetPasscodePage(),
    SetBiometricPage(),
  ];

  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        child: ScaffoldSafe(
          child: ChangeNotifierProvider(
            create: (_) => IntroPresenter(stepsCount: _pages.length),
            builder: (context, _) => PageView(
              controller: context.read<IntroPresenter>(),
              physics: const NeverScrollableScrollPhysics(),
              children: _pages,
            ),
          ),
        ),
      );
}
