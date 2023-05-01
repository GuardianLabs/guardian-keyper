import 'package:guardian_keyper/src/core/ui/widgets/common.dart';
import 'package:guardian_keyper/src/core/ui/widgets/icon_of.dart';

class OnRejectDialog extends StatelessWidget {
  static Future<void> show(final BuildContext context) => showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (final BuildContext context) => const OnRejectDialog(),
      );

  const OnRejectDialog({super.key});

  @override
  Widget build(final BuildContext context) => BottomSheetWidget(
        titleString: 'Request has been rejected',
        textString: 'Guardian rejected your request to join Vault.',
        icon: const IconOf.shield(isBig: true, bage: BageType.error),
        footer: PrimaryButton(
          text: 'Close',
          onPressed: Navigator.of(context).pop,
        ),
      );
}
