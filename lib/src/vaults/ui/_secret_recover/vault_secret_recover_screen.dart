import 'package:guardian_keyper/src/core/consts.dart';
import 'package:guardian_keyper/src/core/ui/widgets/common.dart';

import '../../domain/vault_model.dart';
import '../../domain/secret_shard_model.dart';
import 'presenters/vault_secret_recover_presenter.dart';
import 'pages/discovering_peers_page.dart';
import 'pages/show_secret_page.dart';

class VaultSecretRecoverScreen extends StatelessWidget {
  static const routeName = routeVaultRecoverSecret;

  static const _pages = [
    DiscoveryPeersPage(),
    ShowSecretPage(),
  ];

  static MaterialPageRoute<void> getPageRoute(final RouteSettings settings) =>
      MaterialPageRoute<void>(
        settings: settings,
        fullscreenDialog: true,
        builder: (_) => VaultSecretRecoverScreen(
          vaultIdWithSecretId:
              settings.arguments as MapEntry<VaultId, SecretId>,
        ),
      );

  const VaultSecretRecoverScreen(
      {super.key, required this.vaultIdWithSecretId});

  final MapEntry<VaultId, SecretId> vaultIdWithSecretId;

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
        create: (final BuildContext context) => VaultSecretRecoverPresenter(
          pages: _pages,
          vaultId: vaultIdWithSecretId.key,
          secretId: vaultIdWithSecretId.value,
        ),
        child: ScaffoldSafe(
          child: Selector<VaultSecretRecoverPresenter, int>(
            selector: (_, presenter) => presenter.currentPage,
            builder: (_, currentPage, __) => AnimatedSwitcher(
              duration: pageChangeDuration,
              child: _pages[currentPage],
            ),
          ),
        ),
      );
}
