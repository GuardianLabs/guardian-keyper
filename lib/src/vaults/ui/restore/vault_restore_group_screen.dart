import '/src/core/consts.dart';
import '/src/core/ui/widgets/common.dart';

import 'restore_group_controller.dart';
import 'pages/explainer_page.dart';
import 'pages/scan_qr_code_page.dart';
import 'pages/loading_page.dart';

class VaultRestoreGroupScreen extends StatelessWidget {
  static const routeName = routeGroupRestoreGroup;

  static const _pages = [
    ExplainerPage(),
    ScanQRCodePage(),
    LoadingPage(),
  ];

  static MaterialPageRoute<void> getPageRoute(final RouteSettings settings) =>
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        settings: settings,
        builder: (_) => VaultRestoreGroupScreen(
          skipExplainer: settings.arguments as bool,
        ),
      );

  final bool skipExplainer;

  const VaultRestoreGroupScreen({super.key, this.skipExplainer = false});

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
        create: (final BuildContext context) => VaultRestoreGroupController(
          pages: _pages,
          currentPage: skipExplainer ? 1 : 0,
        ),
        lazy: false,
        child: ScaffoldSafe(
          child: Selector<VaultRestoreGroupController, int>(
            selector: (_, controller) => controller.currentPage,
            builder: (_, currentPage, __) => AnimatedSwitcher(
              duration: pageChangeDuration,
              child: _pages[currentPage],
            ),
          ),
        ),
      );
}
