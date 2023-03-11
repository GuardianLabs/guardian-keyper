import '/src/core/consts.dart';
import '/src/core/widgets/common.dart';

import 'intro_controller.dart';
import 'pages/intros_page.dart';
import 'pages/set_device_name_page.dart';
import 'pages/set_passcode_page.dart';
import 'pages/set_biometric_page.dart';

class IntroView extends StatelessWidget {
  static const routeName = routeIntro;

  static const _pages = [
    IntrosPage(),
    SetDeviceNamePage(),
    SetPasscodePage(),
    SetBiometricPage(),
  ];

  const IntroView({super.key});

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
        create: (final BuildContext context) => IntroController(pages: _pages),
        child: ScaffoldWidget(
          child: Selector<IntroController, int>(
            selector: (_, controller) => controller.currentPage,
            builder: (_, currentPage, __) => AnimatedSwitcher(
              duration: pageChangeDuration,
              child: _pages[currentPage],
            ),
          ),
        ),
      );
}
