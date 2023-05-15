import 'package:guardian_keyper/ui/widgets/emoji.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';
import 'package:guardian_keyper/domain/entity/message_model.dart';

class OnRejectDialog extends StatelessWidget {
  static Future<void> show(
    BuildContext context, {
    required MessageModel message,
  }) =>
      showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        builder: (_) => OnRejectDialog(message: message),
      );

  const OnRejectDialog({
    super.key,
    required this.message,
  });

  final MessageModel message;

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        icon: const IconOf.splitAndShare(isBig: true, bage: BageType.error),
        titleString:
            'Guardian rejected your Secret. The Secret will be removed.',
        textSpan: [
          const TextSpan(text: 'Sharding process for '),
          ...buildTextWithId(id: message.vaultId),
          const TextSpan(
            text: ' has been terminated by one of your Guardians.',
          ),
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
