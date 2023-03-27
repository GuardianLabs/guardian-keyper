import '/src/core/consts.dart';
import '/src/core/ui/widgets/common.dart';
import '/src/core/data/core_model.dart';

import 'vault_recover_secret_controller.dart';
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
          groupIdWithSecretId:
              settings.arguments as MapEntry<VaultId, SecretId>,
        ),
      );

  final MapEntry<VaultId, SecretId> groupIdWithSecretId;

  const VaultRecoverSecretScreen({
    super.key,
    required this.groupIdWithSecretId,
  });

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
        create: (final BuildContext context) => VaultRecoverySecretController(
          pages: _pages,
          groupId: groupIdWithSecretId.key,
          secretId: groupIdWithSecretId.value,
        ),
        child: ScaffoldSafe(
          child: Selector<VaultRecoverySecretController, int>(
            selector: (_, controller) => controller.currentPage,
            builder: (_, currentPage, __) => AnimatedSwitcher(
              duration: pageChangeDuration,
              child: _pages[currentPage],
            ),
          ),
        ),
      );
}
