import 'package:get_it/get_it.dart';

import '/src/core/ui/widgets/common.dart';
import '/src/core/ui/widgets/icon_of.dart';
import '/src/vaults/data/vault_repository.dart';

class RemoveSecretBottomSheet extends StatelessWidget {
  final VaultModel group;
  final SecretId secretId;

  const RemoveSecretBottomSheet({
    super.key,
    required this.group,
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
              group.secrets.remove(secretId);
              await GetIt.I<VaultRepository>().put(group.aKey, group);
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
        ),
      );
}
