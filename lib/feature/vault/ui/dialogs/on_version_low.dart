import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/vault/domain/use_case/vault_interactor.dart';

class OnVersionLowDialog extends StatelessWidget {
  static Future<void> show(BuildContext context) => showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (_) => const OnVersionLowDialog(),
      );

  const OnVersionLowDialog({super.key});

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        icon: const Icon(Icons.file_upload_outlined, size: 80),
        titleString: 'Update the app',
        textString: 'Seems like your Guardian is using the latest '
            'version of the Guardian Keyper. Please update the app.',
        footer: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              onPressed: GetIt.I<VaultInteractor>().openMarket,
              child: const Text('Update'),
            ),
            const Padding(padding: paddingTDefault),
            OutlinedButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Close, I’ll update it later'),
            ),
          ],
        ),
      );
}
