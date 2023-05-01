import 'package:guardian_keyper/src/core/ui/widgets/emoji.dart';
import 'package:guardian_keyper/src/core/ui/widgets/common.dart';
import 'package:guardian_keyper/src/core/ui/widgets/icon_of.dart';
import 'package:guardian_keyper/src/core/domain/entity/core_model.dart';

class OnDuplicateDialog extends StatelessWidget {
  static Future<void> show(
    final BuildContext context,
    final MessageModel message,
  ) =>
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        isScrollControlled: true,
        builder: (final BuildContext context) =>
            OnDuplicateDialog(message: message),
      );

  const OnDuplicateDialog({super.key, required this.message});

  final MessageModel message;

  @override
  Widget build(final BuildContext context) => BottomSheetWidget(
        titleString: 'You can’t add the same Guardian twice',
        textSpan: [
          const TextSpan(text: 'Seems like you’ve already added '),
          ...buildTextWithId(id: message.peerId),
          const TextSpan(
            text: ' to this Vault. Try adding a different Guardian.',
          ),
        ],
        icon: const IconOf.shield(isBig: true, bage: BageType.error),
        footer: PrimaryButton(
          text: 'Add another Guardian',
          onPressed: Navigator.of(context).pop,
        ),
      );
}
