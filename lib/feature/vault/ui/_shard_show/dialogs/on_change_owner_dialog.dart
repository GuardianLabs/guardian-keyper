import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/app/routes.dart';
import 'package:guardian_keyper/domain/entity/vault_model.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/emoji.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';
import 'package:guardian_keyper/feature/message/domain/message_interactor.dart';

class OnChangeOwnerDialog extends StatelessWidget {
  static Future<void> show(
    final BuildContext context, {
    required final VaultModel vault,
  }) =>
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (final BuildContext context) =>
            OnChangeOwnerDialog(vault: vault),
      );

  const OnChangeOwnerDialog({
    super.key,
    required this.vault,
  });

  final VaultModel vault;

  @override
  Widget build(final BuildContext context) => BottomSheetWidget(
        icon: const IconOf.owner(
          isBig: true,
          bage: BageType.warning,
        ),
        titleString: 'Change Owner',
        textSpan: buildTextWithId(
          leadingText: 'Are you sure you want to change owner for vault ',
          id: vault.id,
          trailingText: '? This action cannot be undone.',
        ),
        footer: Column(
          children: [
            PrimaryButton(
              text: 'Confirm',
              onPressed: () async {
                Navigator.of(context).pop();
                final message = await GetIt.I<MessageInteractor>()
                    .createTakeVaultCode(vault.id);
                if (context.mounted) {
                  Navigator.of(context).pushReplacementNamed(
                    routeQrCodeShow,
                    arguments: message,
                  );
                }
              },
            ),
            const Padding(padding: paddingTop20),
            SizedBox(
              width: double.infinity,
              child: TertiaryButton(
                text: 'Keep current Owner',
                onPressed: Navigator.of(context).pop,
              ),
            ),
          ],
        ),
      );
}
