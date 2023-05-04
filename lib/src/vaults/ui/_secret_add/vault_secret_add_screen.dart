import 'package:guardian_keyper/src/core/consts.dart';
import 'package:guardian_keyper/src/core/ui/widgets/common.dart';

import '../../domain/vault_model.dart';
import 'presenters/vault_secret_add_presenter.dart';

import 'pages/add_name_page.dart';
import 'pages/add_secret_page.dart';
import 'pages/share_page.dart';
import 'pages/secret_transmitting_page.dart';

class VaultSecretAddScreen extends StatelessWidget {
  static const routeName = routeVaultAddSecret;

  static const _pages = [
    AddNamePage(),
    AddSecretPage(),
    ShareSecretPage(),
    SecretTransmittingPage(),
  ];

  static MaterialPageRoute<void> getPageRoute(final RouteSettings settings) =>
      MaterialPageRoute<void>(
        settings: settings,
        fullscreenDialog: true,
        builder: (_) => VaultSecretAddScreen(
          vaultId: settings.arguments as VaultId,
        ),
      );

  const VaultSecretAddScreen({
    super.key,
    required this.vaultId,
  });

  final VaultId vaultId;

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
        create: (final BuildContext context) => VaultSecretAddPresenter(
          pages: _pages,
          vaultId: vaultId,
        ),
        child: ScaffoldSafe(
          child: Selector<VaultSecretAddPresenter, int>(
            selector: (_, presenter) => presenter.currentPage,
            builder: (_, currentPage, __) => AnimatedSwitcher(
              duration: pageChangeDuration,
              child: _pages[currentPage],
            ),
          ),
        ),
      );
}
