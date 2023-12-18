import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';

import '../vault_show_presenter.dart';
import '../../../domain/entity/secret_id.dart';

class OnRemoveSecretDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context,
    VaultShowPresenter presenter, {
    required SecretId secretId,
  }) =>
      showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        builder: (_) => OnRemoveSecretDialog(
          presenter: presenter,
          secretId: secretId,
        ),
      );

  const OnRemoveSecretDialog({
    required this.secretId,
    required this.presenter,
    super.key,
  });

  final SecretId secretId;
  final VaultShowPresenter presenter;

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        icon: const IconOf.removeVault(
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
              await presenter.removeSecret(secretId);
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
        ),
      );
}
