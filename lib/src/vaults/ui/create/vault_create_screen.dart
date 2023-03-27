import '/src/core/consts.dart';
import '/src/core/ui/widgets/common.dart';

import 'vault_create_controller.dart';
import 'pages/choose_size_page.dart';
import 'pages/choose_type_page.dart';
import 'pages/input_name_page.dart';

class VaultCreateScreen extends StatelessWidget {
  static const routeName = routeGroupCreate;

  static const _pages = [
    ChooseTypePage(),
    ChooseSizePage(),
    InputNamePage(),
  ];

  static MaterialPageRoute<void> getPageRoute(final RouteSettings settings) =>
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        settings: settings,
        builder: (_) => const VaultCreateScreen(),
      );

  const VaultCreateScreen({super.key});

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
        create: (final BuildContext context) => VaultCreateController(
          pages: _pages,
        ),
        child: ScaffoldSafe(
          child: Selector<VaultCreateController, int>(
            selector: (context, controller) => controller.currentPage,
            builder: (context, currentPage, __) => AnimatedSwitcher(
              duration: pageChangeDuration,
              child: _pages[currentPage],
            ),
          ),
        ),
      );
}
