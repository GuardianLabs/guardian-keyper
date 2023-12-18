import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import '../../domain/entity/secret_id.dart';
import '../../domain/entity/vault_id.dart';
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
    final arguments = ModalRoute.of(context)!.settings.arguments! as ({
      VaultId vaultId,
      SecretId secretId,
    });
    return ChangeNotifierProvider(
      create: (_) => VaultSecretRecoveryPresenter(
        pageCount: _pages.length,
        vaultId: arguments.vaultId,
        secretId: arguments.secretId,
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
