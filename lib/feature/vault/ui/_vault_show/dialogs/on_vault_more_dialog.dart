import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';

import '../vault_show_presenter.dart';

class OnVaultMoreDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context,
    VaultShowPresenter presenter,
  ) =>
      showModalBottomSheet<bool>(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        builder: (_) => OnVaultMoreDialog(presenter: presenter),
      );

  const OnVaultMoreDialog({
    required this.presenter,
    super.key,
  });

  final VaultShowPresenter presenter;

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        footer: FilledButton(
          child: const SizedBox(
            width: double.infinity,
            child: Text(
              'Remove the Vault',
              textAlign: TextAlign.center,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            showModalBottomSheet<void>(
              context: context,
              useSafeArea: true,
              isScrollControlled: true,
              builder: _removeVaultDialogBuilder,
            );
          },
        ),
      );

  Widget _removeVaultDialogBuilder(BuildContext context) => BottomSheetWidget(
        icon: const IconOf.removeVault(
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
              await presenter.removeVault();
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
        ),
      );
}
