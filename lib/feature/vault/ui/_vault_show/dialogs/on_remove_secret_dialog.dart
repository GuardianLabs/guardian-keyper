import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';
import 'package:guardian_keyper/domain/entity/vault_model.dart';
import 'package:guardian_keyper/domain/entity/_id/secret_id.dart';

import '../../../domain/vault_interactor.dart';

class OnRemoveSecretDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required SecretId secretId,
    required VaultModel vault,
  }) =>
      showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        builder: (_) => OnRemoveSecretDialog(vault: vault, secretId: secretId),
      );

  const OnRemoveSecretDialog({
    super.key,
    required this.vault,
    required this.secretId,
  });

  final VaultModel vault;
  final SecretId secretId;

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
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
