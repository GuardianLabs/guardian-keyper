import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';

class OnFailDialog extends StatelessWidget {
  static Future<void> show(BuildContext context) => showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (_) => const OnFailDialog(),
      );

  const OnFailDialog({super.key});

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
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
