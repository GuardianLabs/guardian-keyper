import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import 'intro_presenter.dart';
import 'pages/intros_page.dart';
import 'pages/set_passcode_page.dart';
import 'pages/set_biometric_page.dart';
import 'pages/set_device_name_page.dart';

class IntroScreen extends StatelessWidget {
  static const _pages = [
    IntrosPage(),
    SetDeviceNamePage(),
    SetPasscodePage(),
    SetBiometricPage(),
  ];

  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => IntroPresenter(pages: _pages),
        child: WillPopScope(
          onWillPop: () async => false,
          child: ScaffoldSafe(
            child: Selector<IntroPresenter, int>(
              selector: (_, presenter) => presenter.currentPage,
              builder: (_, currentPage, __) => AnimatedSwitcher(
                duration: pageChangeDuration,
                child: _pages[currentPage],
              ),
            ),
          ),
        ),
      );
}
