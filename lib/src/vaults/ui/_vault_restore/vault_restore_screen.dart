import 'package:guardian_keyper/src/core/consts.dart';
import 'package:guardian_keyper/src/core/ui/widgets/common.dart';
import 'package:guardian_keyper/src/core/domain/entity/core_model.dart';

import 'presenters/vault_restore_presenter.dart';
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
        builder: (final BuildContext context) => VaultRestoreScreen(
          vaultId: settings.arguments as VaultId?,
        ),
      );

  final VaultId? vaultId;

  const VaultRestoreScreen({super.key, required this.vaultId});

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
        create: (final BuildContext context) => VaultRestorePresenter(
          pages: _pages,
          vaultId: vaultId,
        ),
        lazy: false,
        child: ScaffoldSafe(
          child: Selector<VaultRestorePresenter, int>(
            selector: (
              final BuildContext context,
              final VaultRestorePresenter presenter,
            ) =>
                presenter.currentPage,
            builder: (
              final BuildContext context,
              final int currentPage,
              final Widget? widget,
            ) =>
                AnimatedSwitcher(
              duration: pageChangeDuration,
              child: _pages[currentPage],
            ),
          ),
        ),
      );
}
