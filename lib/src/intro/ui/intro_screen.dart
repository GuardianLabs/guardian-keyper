import '/src/core/consts.dart';
import '/src/core/ui/widgets/common.dart';

import 'intro_presenter.dart';
import 'pages/intros_page.dart';
import 'pages/set_device_name_page.dart';
import 'pages/set_passcode_page.dart';
import 'pages/set_biometric_page.dart';

class IntroScreen extends StatelessWidget {
  static const routeName = routeIntro;

  static const _pages = [
    IntrosPage(),
    SetDeviceNamePage(),
    SetPasscodePage(),
    SetBiometricPage(),
  ];

  static MaterialPageRoute<void> getPageRoute(final RouteSettings settings) =>
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        maintainState: false,
        settings: settings,
        builder: (_) => const IntroScreen(),
      );

  const IntroScreen({super.key});

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
        create: (final BuildContext context) => IntroPresenter(pages: _pages),
        child: WillPopScope(
          onWillPop: () => Future.value(false),
          child: ScaffoldSafe(
            child: Selector<IntroPresenter, int>(
              selector: (_, controller) => controller.currentPage,
              builder: (_, currentPage, __) => AnimatedSwitcher(
                duration: pageChangeDuration,
                child: _pages[currentPage],
              ),
            ),
          ),
        ),
      );
}
