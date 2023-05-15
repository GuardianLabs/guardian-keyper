import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/domain/entity/_id/vault_id.dart';
import 'package:guardian_keyper/domain/entity/_id/secret_id.dart';

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
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as (
      VaultId vaultId,
      SecretId secretId,
    );
    return ChangeNotifierProvider(
      create: (_) => VaultSecretRecoveryPresenter(
        pages: _pages,
        vaultId: arguments.$1,
        secretId: arguments.$2,
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