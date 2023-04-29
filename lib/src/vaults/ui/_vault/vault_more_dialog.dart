import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/src/core/ui/widgets/common.dart';
import 'package:guardian_keyper/src/core/ui/widgets/icon_of.dart';

import '../../domain/vault_model.dart';
import '../../domain/vault_interactor.dart';

class VaultMoreDialog extends StatelessWidget {
  static Future<void> show({
    required final BuildContext context,
    required final VaultId vaultId,
  }) =>
      showModalBottomSheet<bool>(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        builder: (final BuildContext context) =>
            VaultMoreDialog(vaultId: vaultId),
      );

  const VaultMoreDialog({super.key, required this.vaultId});

  final VaultId vaultId;

  @override
  Widget build(final BuildContext context) => BottomSheetWidget(
        footer: ElevatedButton(
          child: const SizedBox(
            width: double.infinity,
            child: Text(
              'Remove the Vault',
              textAlign: TextAlign.center,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            showModalBottomSheet(
              context: context,
              useSafeArea: true,
              isScrollControlled: true,
              builder: _removeVaultDialogBuilder,
            );
          },
        ),
      );

  Widget _removeVaultDialogBuilder(final BuildContext context) =>
      BottomSheetWidget(
        icon: const IconOf.removeGroup(
          isBig: true,
          bage: BageType.warning,
        ),
        titleString: 'Do you want to remove this Vault?',
        textString: 'All the Secrets from this Vault will be removed as well.',
        footer: SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            text: 'Yes, remove the Vault',
            onPressed: () async {
              Navigator.of(context).pop();
              await GetIt.I<VaultInteractor>().removeVault(vaultId);
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
        ),
      );
}
