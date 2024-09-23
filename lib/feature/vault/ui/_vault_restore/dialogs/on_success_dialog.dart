import 'package:guardian_keyper/app/routes.dart';
import 'package:guardian_keyper/feature/vault/domain/entity/vault_id.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

class OnSuccessDialog extends StatelessWidget {
  static Future<bool?> show(
    BuildContext context, {
    required String peerName,
    required VaultId vaultId,
    required bool hasQuorum,
    required bool isFull,
  }) =>
      showModalBottomSheet<bool>(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (_) => OnSuccessDialog(
          peerName: peerName,
          vaultId: vaultId,
          hasQuorum: hasQuorum,
          isFull: isFull,
        ),
      );

  const OnSuccessDialog({
    required this.peerName,
    required this.vaultId,
    required this.hasQuorum,
    required this.isFull,
    super.key,
  });

  final String peerName;
  final VaultId vaultId;
  final bool hasQuorum;
  final bool isFull;

  @override
  Widget build(BuildContext context) => isFull
      ? BottomSheetWidget(
          icon: const Icon(Icons.check_circle, size: 80),
          titleString: 'Ownership Changed',
          textSpan: [
            const TextSpan(
              text: 'The ownership of the Safe ',
            ),
            TextSpan(
              text: vaultId.name,
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
              text: '${vaultId.name}.',
              style: styleW600,
            ),
            if (hasQuorum)
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
            children: [
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      child: const Text('Add another Guardian'),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ),
                ],
              ),
              if (hasQuorum)
                Padding(
                  padding: paddingT12,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          child: const Text('Go to Safe'),
                          onPressed: () => Navigator.pushNamedAndRemoveUntil(
                            context,
                            routeVaultShow,
                            (Route<dynamic> route) => route.isFirst,
                            arguments: vaultId,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
}
