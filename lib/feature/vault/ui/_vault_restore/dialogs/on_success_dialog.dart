import 'package:guardian_keyper/app/routes.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/vault.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

class OnSuccessDialog extends StatelessWidget {
  static Future<bool?> show(
    BuildContext context, {
    required Vault vault,
    required String peerName,
  }) =>
      showModalBottomSheet<bool>(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (_) => OnSuccessDialog(
          vault: vault,
          peerName: peerName,
        ),
      );

  const OnSuccessDialog({
    required this.vault,
    required this.peerName,
    super.key,
  });

  final Vault vault;
  final String peerName;

  @override
  Widget build(BuildContext context) => vault.isFull
      ? BottomSheetWidget(
          icon: const Icon(Icons.check_circle, size: 80),
          titleString: 'Ownership Changed',
          textSpan: [
            const TextSpan(
              text: 'The ownership of the Safe ',
            ),
            TextSpan(
              text: vault.id.name,
              style: styleW600,
            ),
            const TextSpan(
              text: ' has been transferred to your device.',
            ),
          ],
          footer: FilledButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Done'),
          ),
        )
      : BottomSheetWidget(
          icon: const Icon(Icons.check_circle, size: 80),
          titleString: 'Ownership Transfer Approved',
          textSpan: [
            TextSpan(
              text: peerName,
              style: styleW600,
            ),
            const TextSpan(
                text: ' approved the transfer of ownership for the Safe '),
            TextSpan(
              text: '${vault.id.name}.',
              style: styleW600,
            ),
            if (vault.hasQuorum)
              const TextSpan(
                text:
                    '\n\nYou need to add all the Guardians linked to that Safe '
                    'to gain full access to it. For now, you have limited access '
                    'and can restore your secrets from the Safe page.',
              )
            else
              const TextSpan(
                text: '\n\nAdd more Guardians of the Safe to gain access to it',
              )
          ],
          footer: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton(
                child: const Text('Add another Guardian'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
              if (vault.hasQuorum)
                Padding(
                  padding: paddingT12,
                  child: OutlinedButton(
                    child: const Text('Go to Safe'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacementNamed(
                        context,
                        routeVaultShow,
                        arguments: vault.id,
                      );
                    },
                  ),
                ),
            ],
          ),
        );
}
