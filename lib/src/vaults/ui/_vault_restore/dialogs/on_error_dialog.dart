import 'package:guardian_keyper/src/core/ui/widgets/common.dart';
import 'package:guardian_keyper/src/core/ui/widgets/icon_of.dart';

class OnErrorDialog extends StatelessWidget {
  static Future<void> show(final BuildContext context) => showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (final BuildContext context) => const OnErrorDialog(),
      );

  const OnErrorDialog({super.key});

  @override
  Widget build(final BuildContext context) => BottomSheetWidget(
        icon: const IconOf.secrets(isBig: true, bage: BageType.error),
        titleString: 'Ownership Transfer Failed',
        textString:
            'We couldn’t finish scanning the QR Code.\nPlease try again.',
        footer: PrimaryButton(
          text: 'Close',
          onPressed: Navigator.of(context).pop,
        ),
      );
}
