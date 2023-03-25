import '/src/core/consts.dart';
import '/src/core/ui/widgets/common.dart';

import 'restore_group_controller.dart';
import 'pages/explainer_page.dart';
import 'pages/scan_qr_code_page.dart';
import 'pages/loading_page.dart';

class RestoreGroupView extends StatelessWidget {
  static const routeName = routeGroupRestoreGroup;

  static const _pages = [
    ExplainerPage(),
    ScanQRCodePage(),
    LoadingPage(),
  ];

  final bool skipExplainer;

  const RestoreGroupView({super.key, this.skipExplainer = false});

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
        create: (final BuildContext context) => RestoreGroupController(
          pages: _pages,
          currentPage: skipExplainer ? 1 : 0,
        ),
        lazy: false,
        child: ScaffoldSafe(
          child: Selector<RestoreGroupController, int>(
            selector: (_, controller) => controller.currentPage,
            builder: (_, currentPage, __) => AnimatedSwitcher(
              duration: pageChangeDuration,
              child: _pages[currentPage],
            ),
          ),
        ),
      );
}
