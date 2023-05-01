import 'package:guardian_keyper/src/core/consts.dart';
import 'package:guardian_keyper/src/core/ui/widgets/common.dart';
import 'package:guardian_keyper/src/core/domain/entity/core_model.dart';

import 'presenters/vault_guardian_add_presenter.dart';
import 'pages/get_code_page.dart';
import 'pages/loading_page.dart';

class VaultGuardianAddScreen extends StatelessWidget {
  static const routeName = routeVaultAddGuardian;

  static const _pages = [
    GetCodePage(),
    LoadingPage(),
  ];

  static MaterialPageRoute<void> getPageRoute(final RouteSettings settings) =>
      MaterialPageRoute<void>(
        settings: settings,
        fullscreenDialog: true,
        builder: (final BuildContext context) => VaultGuardianAddScreen(
          vaultId: settings.arguments as VaultId,
        ),
      );

  const VaultGuardianAddScreen({super.key, required this.vaultId});

  final VaultId vaultId;

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
        create: (final BuildContext context) => VaultGuardianAddPresenter(
          pages: _pages,
          vaultId: vaultId,
        ),
        child: ScaffoldSafe(
          child: Selector<VaultGuardianAddPresenter, int>(
            selector: (
              final BuildContext context,
              final VaultGuardianAddPresenter presenter,
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
