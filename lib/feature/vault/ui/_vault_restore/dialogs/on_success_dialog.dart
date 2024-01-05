import 'package:guardian_keyper/ui/widgets/common.dart';

class OnSuccessDialog extends StatelessWidget {
  static Future<bool?> show(
    BuildContext context, {
    required bool isFull,
    required String vaultName,
    required String peerName,
  }) =>
      showModalBottomSheet<bool>(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (_) => OnSuccessDialog(
          peerName: peerName,
          vaultName: vaultName,
          isFull: isFull,
        ),
      );

  const OnSuccessDialog({
    required this.vaultName,
    required this.peerName,
    required this.isFull,
    super.key,
  });

  final String peerName;
  final String vaultName;
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
              text: vaultName,
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
              text: ' approved the transfer of ownership for the Safe ',
            ),
            TextSpan(
              text: vaultName,
              style: styleW600,
            ),
          ],
          footer: FilledButton(
            child: const Text('Add another Guardian'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        );
}
