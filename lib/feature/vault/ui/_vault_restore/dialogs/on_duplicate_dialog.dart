import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';

class OnDuplicateDialog extends StatelessWidget {
  static Future<void> show(final BuildContext context) => showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (final BuildContext context) => const OnDuplicateDialog(),
      );

  const OnDuplicateDialog({super.key});

  @override
  Widget build(final BuildContext context) => BottomSheetWidget(
        icon: const IconOf.owner(isBig: true),
        titleString: 'The Vault is yours',
        textString: 'Seems like you are the owner of the Vault already. '
            'No recovery required here.',
        footer: PrimaryButton(
          text: 'Close',
          onPressed: Navigator.of(context).pop,
        ),
      );
}
