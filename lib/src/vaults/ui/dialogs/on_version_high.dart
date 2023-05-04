import 'package:guardian_keyper/src/core/ui/widgets/common.dart';
import 'package:guardian_keyper/src/core/ui/widgets/icon_of.dart';

class OnVersionHighDialog extends StatelessWidget {
  static Future<void> show(final BuildContext context) => showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (final BuildContext context) => const OnVersionHighDialog(),
      );

  const OnVersionHighDialog({super.key});

  @override
  Widget build(final BuildContext context) => BottomSheetWidget(
        icon: const IconOf.shield(isBig: true, bage: BageType.error),
        titleString: 'Guardian’s app is outdated',
        textString: 'Seems like your Guardian is using the older '
            'version of the Guardian Keyper. Ask them to update the app.',
        footer: PrimaryButton(
          text: 'Close',
          onPressed: Navigator.of(context).pop,
        ),
      );
}
