import 'package:guardian_keyper/app/consts.dart';
import 'package:guardian_keyper/domain/entity/_id/vault_id.dart';
import 'package:guardian_keyper/domain/entity/_id/secret_id.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import 'vault_secret_recovery_presenter.dart';
import 'pages/discovering_peers_page.dart';
import 'pages/show_secret_page.dart';

class VaultSecretRecoveryScreen extends StatelessWidget {
  static const _pages = [
    DiscoveringPeersPage(),
    ShowSecretPage(),
  ];

  const VaultSecretRecoveryScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    final vaultIdWithSecretId = ModalRoute.of(context)?.settings.arguments
        as MapEntry<VaultId, SecretId>;
    return ChangeNotifierProvider(
      create: (_) => VaultSecretRecoveryPresenter(
        pages: _pages,
        vaultId: vaultIdWithSecretId.key,
        secretId: vaultIdWithSecretId.value,
      ),
      child: ScaffoldSafe(
        child: Selector<VaultSecretRecoveryPresenter, int>(
          selector: (_, presenter) => presenter.currentPage,
          builder: (_, currentPage, __) => AnimatedSwitcher(
            duration: pageChangeDuration,
            child: _pages[currentPage],
          ),
        ),
      ),
    );
  }
}
