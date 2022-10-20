import '/src/core/di_container.dart';
import '/src/core/widgets/common.dart';

import 'intro_controller.dart';
import 'pages/intros_page.dart';
import 'pages/set_device_name_page.dart';
import 'pages/set_passcode_page.dart';
import 'pages/set_biometric_page.dart';

class IntroView extends StatelessWidget {
  static const routeName = '/intro';
  static const _pages = [
    IntrosPage(),
    SetDeviceNamePage(),
    SetPasscodePage(),
    SetBiometricPage(),
  ];

  const IntroView({super.key});

  @override
  Widget build(BuildContext context) {
    final diContainer = context.read<DIContainer>();
    return ChangeNotifierProvider(
      create: (context) => IntroController(
        diContainer: diContainer,
        pagesCount: _pages.length,
      ),
      child: ScaffoldWidget(
        child: Selector<IntroController, int>(
          selector: (_, controller) => controller.currentPage,
          builder: (_, currentPage, __) => AnimatedSwitcher(
            duration: diContainer.globals.pageChangeDuration,
            child: _pages[currentPage],
          ),
        ),
      ),
    );
  }
}
