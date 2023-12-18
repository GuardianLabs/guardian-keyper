import 'package:guardian_keyper/ui/widgets/common.dart';

class OnRejectDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required String peerId,
    required String vaultId,
  }) =>
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (_) => OnRejectDialog(
          peerName: peerId,
          vaultName: vaultId,
        ),
      );

  const OnRejectDialog({
    required this.peerName,
    required this.vaultName,
    super.key,
  });

  final String peerName;
  final String vaultName;

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        icon: const Icon(Icons.cancel, size: 80),
        titleString: 'Ownership Transfer Rejected',
        textSpan: [
          TextSpan(text: peerName, style: styleW600),
          const TextSpan(
            text: ' rejected the transfer of ownership for the Vault ',
          ),
          TextSpan(text: vaultName, style: styleW600),
        ],
        body: Card(
          child: Padding(
            padding: paddingAll20,
            child: Text(
              'Since Guardian rejected ownership transfer, '
              'it is impossible to restore the Vault.',
              style: styleSourceSansPro416Purple,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        footer: FilledButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Close'),
        ),
      );
}
