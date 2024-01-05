import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/vault/domain/entity/vault.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/secret_id.dart';
import 'package:guardian_keyper/feature/vault/domain/use_case/vault_interactor.dart';

class OnRemoveSecretDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required Vault vault,
    required SecretId secretId,
  }) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => OnRemoveSecretDialog(
          vault: vault,
          secretId: secretId,
        ),
      );

  const OnRemoveSecretDialog({
    required this.vault,
    required this.secretId,
    super.key,
  });

  final Vault vault;
  final SecretId secretId;

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        icon: const Icon(Icons.warning_rounded, size: 80),
        titleString: 'Do you want to remove this Secret?',
        textString: 'All the Shards of this Secret will not be removed '
            'from Guardians device.',
        footer: FilledButton(
          onPressed: () async {
            await GetIt.I<VaultInteractor>().removeSecret(
              vault: vault,
              secretId: secretId,
            );
            if (context.mounted) Navigator.of(context).pop();
          },
          child: const Text('Yes, remove the Secret'),
        ),
      );
}
