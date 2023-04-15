import '/src/core/app/consts.dart';
import '../../../core/domain/core_model.dart';
import '/src/core/ui/widgets/common.dart';

import 'vault_add_guardian_presenter.dart';
import 'pages/get_code_page.dart';
import 'pages/loading_page.dart';

class VaultAddGuardianScreen extends StatelessWidget {
  static const routeName = routeVaultAddGuardian;

  static const _pages = [
    GetCodePage(),
    LoadingPage(),
  ];

  static MaterialPageRoute<void> getPageRoute(final RouteSettings settings) =>
      MaterialPageRoute<void>(
        settings: settings,
        fullscreenDialog: true,
        builder: (_) => VaultAddGuardianScreen(
          vaultId: settings.arguments as VaultId,
        ),
      );

  final VaultId vaultId;

  const VaultAddGuardianScreen({super.key, required this.vaultId});

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
        create: (_) => VaultAddGuardianPresenter(
          pages: _pages,
          vaultId: vaultId,
        ),
        lazy: false,
        child: ScaffoldSafe(
          child: Selector<VaultAddGuardianPresenter, int>(
            selector: (_, controller) => controller.currentPage,
            builder: (_, currentPage, __) => AnimatedSwitcher(
              duration: pageChangeDuration,
              child: _pages[currentPage],
            ),
          ),
        ),
      );
}
