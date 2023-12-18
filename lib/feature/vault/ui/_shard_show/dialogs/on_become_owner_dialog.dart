import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';

import 'package:guardian_keyper/feature/vault/domain/entity/vault_id.dart';
import 'package:guardian_keyper/feature/vault/domain/use_case/vault_interactor.dart';

class OnBecomeOwnerDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required VaultId vaultId,
  }) =>
      showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        builder: (_) => OnBecomeOwnerDialog(vaultId: vaultId),
      );

  const OnBecomeOwnerDialog({
    required this.vaultId,
    super.key,
  });

  final VaultId vaultId;

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        icon: const IconOf.shardOwner(
          isBig: true,
          bage: BageType.warning,
        ),
        // TBD: update texts
        titleString: 'Confirm Action!',
        textString: 'Taking ownership can not be undone! Are you sure?',
        footer: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              child: const Text('Confirm'),
              onPressed: () async {
                await GetIt.I<VaultInteractor>().takeVaultOwnership(vaultId);
                if (context.mounted) {
                  Navigator.of(context).popUntil((r) => r.isFirst);
                }
              },
            ),
            const Padding(padding: paddingT20),
            FilledButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
}
