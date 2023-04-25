import '../../../core/consts.dart';
import '../../../core/domain/entity/core_model.dart';
import '/src/core/ui/widgets/common.dart';

import 'vault_restore_presenter.dart';
import 'pages/get_code_page.dart';
import 'pages/loading_page.dart';

class VaultRestoreScreen extends StatelessWidget {
  static const routeName = routeVaultRestore;

  static const _pages = [
    GetCodePage(),
    LoadingPage(),
  ];

  static MaterialPageRoute<void> getPageRoute(final RouteSettings settings) =>
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        settings: settings,
        builder: (_) => VaultRestoreScreen(
          vaultId: settings.arguments as VaultId?,
        ),
      );

  final VaultId? vaultId;

  const VaultRestoreScreen({super.key, required this.vaultId});

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
        create: (_) => VaultRestorePresenter(
          pages: _pages,
          vaultId: vaultId,
        ),
        lazy: false,
        child: ScaffoldSafe(
          child: Selector<VaultRestorePresenter, int>(
            selector: (_, controller) => controller.currentPage,
            builder: (_, currentPage, __) => AnimatedSwitcher(
              duration: pageChangeDuration,
              child: _pages[currentPage],
            ),
          ),
        ),
      );
}
