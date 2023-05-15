import 'package:guardian_keyper/ui/widgets/emoji.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';
import 'package:guardian_keyper/domain/entity/message_model.dart';

class OnSuccessDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required MessageModel message,
  }) =>
      showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        builder: (_) => OnSuccessDialog(message: message),
      );

  const OnSuccessDialog({
    super.key,
    required this.message,
  });

  final MessageModel message;

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        icon: const IconOf.splitAndShare(isBig: true, bage: BageType.ok),
        titleString: 'Your Secret has been split',
        textSpan: [
          const TextSpan(text: 'Now you can restore your '),
          ...buildTextWithId(id: message.vaultId),
          const TextSpan(text: ' Secret with the help of Guardians.'),
        ],
        footer: Padding(
          padding: paddingV20,
          child: PrimaryButton(
            text: 'Done',
            onPressed: Navigator.of(context).pop,
          ),
        ),
      );
}
