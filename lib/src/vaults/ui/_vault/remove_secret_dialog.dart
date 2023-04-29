import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/src/core/ui/widgets/common.dart';
import 'package:guardian_keyper/src/core/ui/widgets/icon_of.dart';
import 'package:guardian_keyper/src/vaults/domain/secret_shard_model.dart';

import '../../domain/vault_interactor.dart';
import '../../domain/vault_model.dart';

class RemoveSecretDialog extends StatelessWidget {
  static Future<void> show({
    required final BuildContext context,
    required final SecretId secretId,
    required final VaultModel vault,
  }) =>
      showModalBottomSheet<bool>(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        builder: (final BuildContext context) => RemoveSecretDialog(
          vault: vault,
          secretId: secretId,
        ),
      );

  final VaultModel vault;
  final SecretId secretId;

  const RemoveSecretDialog({
    super.key,
    required this.vault,
    required this.secretId,
  });

  @override
  Widget build(final BuildContext context) => BottomSheetWidget(
        icon: const IconOf.removeGroup(
          isBig: true,
          bage: BageType.warning,
        ),
        titleString: 'Do you want to remove this Secret?',
        textString: 'All the Shards of this Secret will not be removed '
            'from Guardians device.',
        footer: SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            text: 'Yes, remove the Secret',
            onPressed: () async {
              await GetIt.I<VaultInteractor>().removeSecret(
                vault: vault,
                secretId: secretId,
              );
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
        ),
      );
}
