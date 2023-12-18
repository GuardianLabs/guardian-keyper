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
        titleString: 'Guardian rejected the recovery of your Secret',
        textSpan: [
          const TextSpan(text: 'Secret Recovery process for '),
          TextSpan(text: vaultName, style: styleW600),
          const TextSpan(text: ' has been terminated by your Guardians.'),
        ],
        footer: FilledButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Done'),
        ),
      );
}
