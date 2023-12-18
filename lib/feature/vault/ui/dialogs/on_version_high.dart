import 'package:guardian_keyper/ui/widgets/common.dart';

class OnVersionHighDialog extends StatelessWidget {
  static Future<void> show(BuildContext context) => showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (_) => const OnVersionHighDialog(),
      );

  const OnVersionHighDialog({super.key});

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        icon: const Icon(Icons.file_upload_outlined, size: 80),
        titleString: 'Guardian’s app is outdated',
        textString: 'Seems like your Guardian is using the older '
            'version of the Guardian Keyper. Ask them to update the app.',
        footer: FilledButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Close'),
        ),
      );
}
