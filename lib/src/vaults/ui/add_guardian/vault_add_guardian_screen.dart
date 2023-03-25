import '/src/core/consts.dart';
import '/src/core/data/core_model.dart';
import '/src/core/ui/widgets/common.dart';

import 'vault_add_guardian_controller.dart';
import 'pages/scan_qrcode_page.dart';
import 'pages/loading_page.dart';

class VaultAddGuardianScreen extends StatelessWidget {
  static const routeName = routeGroupAddGuardian;

  static const _pages = [
    ScanQRCodePage(),
    LoadingPage(),
  ];

  static MaterialPageRoute<void> getPageRoute(final RouteSettings settings) =>
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        maintainState: false,
        settings: settings,
        builder: (_) => VaultAddGuardianScreen(
          groupId: settings.arguments as VaultId,
        ),
      );

  final VaultId groupId;

  const VaultAddGuardianScreen({super.key, required this.groupId});

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
        create: (final BuildContext context) => VaultAddGuardianController(
          pages: _pages,
          groupId: groupId,
        ),
        lazy: false,
        child: ScaffoldSafe(
          child: Selector<VaultAddGuardianController, int>(
            selector: (_, controller) => controller.currentPage,
            builder: (_, currentPage, __) => AnimatedSwitcher(
              duration: pageChangeDuration,
              child: _pages[currentPage],
            ),
          ),
        ),
      );
}
