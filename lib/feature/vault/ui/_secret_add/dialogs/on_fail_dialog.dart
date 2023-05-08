import 'package:guardian_keyper/ui/widgets/emoji.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';
import 'package:guardian_keyper/domain/entity/message_model.dart';

class OnFailDialog extends StatelessWidget {
  static Future<void> show(
    final BuildContext context,
    final MessageModel message,
  ) =>
      showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        builder: (_) => OnFailDialog(message: message),
      );

  const OnFailDialog({super.key, required this.message});

  final MessageModel message;

  @override
  Widget build(final BuildContext context) => BottomSheetWidget(
        icon: const IconOf.splitAndShare(isBig: true, bage: BageType.error),
        titleString: 'Something went wrong!',
        textSpan: [
          const TextSpan(text: 'Sharding process for '),
          ...buildTextWithId(id: message.vaultId),
          const TextSpan(text: ' has been terminated.'),
        ],
        footer: Padding(
          padding: paddingV20,
          child: PrimaryButton(
            text: 'Close',
            onPressed: Navigator.of(context).pop,
          ),
        ),
      );
}
