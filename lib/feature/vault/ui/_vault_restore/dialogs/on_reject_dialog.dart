import 'package:guardian_keyper/ui/widgets/common.dart';

class OnRejectDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required String peerId,
  }) =>
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (_) => OnRejectDialog(peerName: peerId),
      );

  const OnRejectDialog({
    required this.peerName,
    super.key,
  });

  final String peerName;

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        icon: const Icon(Icons.cancel, size: 80),
        titleString: 'Ownership Transfer Rejected',
        textSpan: [
          TextSpan(text: peerName, style: styleW600),
          const TextSpan(
            text: ' rejected the transfer of ownership for the Vault.',
          ),
        ],
        body: const Card(
          child: Padding(
            padding: paddingAll20,
            child: Text(
              'Since Guardian rejected ownership transfer, '
              'it is impossible to restore the Vault.',
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
