import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';

import '../../domain/use_case/vault_interactor.dart';

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
        icon: const IconOf.shield(isBig: true, bage: BageType.error),
        titleString: 'Update the app',
        textString: 'Seems like your Guardian is using the latest '
            'version of the Guardian Keyper. Please update the app.',
        footer: Column(
          children: [
            ElevatedButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Close'),
            ),
            const Padding(padding: paddingT20),
            OutlinedButton(
              onPressed: GetIt.I<VaultInteractor>().openMarket,
              child: const Text('Update'),
            )
          ],
        ),
      );
}
