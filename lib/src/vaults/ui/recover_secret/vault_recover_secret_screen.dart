import '/src/core/app/consts.dart';
import '/src/core/data/core_model.dart';
import '/src/core/ui/widgets/common.dart';

import 'vault_recover_secret_presenter.dart';
import 'pages/discovering_peers_page.dart';
import 'pages/show_secret_page.dart';

class VaultRecoverSecretScreen extends StatelessWidget {
  static const routeName = routeVaultRecoverSecret;

  static const _pages = [
    DiscoveryPeersPage(),
    ShowSecretPage(),
  ];

  static MaterialPageRoute<void> getPageRoute(final RouteSettings settings) =>
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        settings: settings,
        builder: (_) => VaultRecoverSecretScreen(
          vaultIdWithSecretId:
              settings.arguments as MapEntry<VaultId, SecretId>,
        ),
      );

  final MapEntry<VaultId, SecretId> vaultIdWithSecretId;

  const VaultRecoverSecretScreen({
    super.key,
    required this.vaultIdWithSecretId,
  });

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
        create: (final BuildContext context) => VaultRecoverySecretPresenter(
          pages: _pages,
          vaultId: vaultIdWithSecretId.key,
          secretId: vaultIdWithSecretId.value,
        ),
        child: ScaffoldSafe(
          child: Selector<VaultRecoverySecretPresenter, int>(
            selector: (_, controller) => controller.currentPage,
            builder: (_, currentPage, __) => AnimatedSwitcher(
              duration: pageChangeDuration,
              child: _pages[currentPage],
            ),
          ),
        ),
      );
}
