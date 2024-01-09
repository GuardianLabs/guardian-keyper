import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/vault/domain/entity/vault_id.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/secret_id.dart';

import 'vault_secret_recovery_presenter.dart';
import 'pages/discovering_peers_page.dart';
import 'pages/show_secret_page.dart';

class VaultSecretRecoveryScreen extends StatelessWidget {
  static const route = '/vault/secret/recovery';

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
    return ScaffoldSafe(
      child: ChangeNotifierProvider(
        create: (_) => VaultSecretRecoveryPresenter(
          stepsCount: _pages.length,
          vaultId: arguments.vaultId,
          secretId: arguments.secretId,
        ),
        builder: (context, _) => PageView(
          controller: context.read<VaultSecretRecoveryPresenter>(),
          physics: const NeverScrollableScrollPhysics(),
          children: _pages,
        ),
      ),
    );
  }
}
