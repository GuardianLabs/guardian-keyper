import 'package:guardian_keyper/ui/widgets/common.dart';

class OnRejectDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required String vaultName,
  }) =>
      showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        builder: (_) => OnRejectDialog(vaultName: vaultName),
      );

  const OnRejectDialog({
    required this.vaultName,
    super.key,
  });

  final String vaultName;

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        icon: const Icon(Icons.cancel, size: 80),
        titleString: 'Rejected by Guardian',
        textSpan: [
          const TextSpan(text: 'Sharding process for '),
          TextSpan(
            text: vaultName,
            style: styleW600,
          ),
          const TextSpan(
            text: ' has been terminated by one of you Guardians. '
                'The Secret has been removed.',
          ),
        ],
        footer: FilledButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Go to Safe'),
        ),
      );
}
