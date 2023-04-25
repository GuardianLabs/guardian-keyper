import 'package:guardian_keyper/src/core/ui/widgets/emoji.dart';
import 'package:guardian_keyper/src/core/ui/widgets/common.dart';
import 'package:guardian_keyper/src/core/ui/widgets/icon_of.dart';

import '../../../domain/message_model.dart';
import '../message_resolved_dialog.dart';
import '../message_active_dialog.dart';
import '../message_titles_mixin.dart';

class MessageListTile extends StatelessWidget with MessageTitlesMixin {
  static const _icons = {
    MessageCode.createGroup: IconOf.shield(color: clWhite),
    MessageCode.setShard: IconOf.splitAndShare(),
    MessageCode.getShard: IconOf.secret(),
    MessageCode.takeGroup: IconOf.owner(),
  };

  static String _roundedAgo(final DateTime value) {
    const hoursInMonth = 24 * 30;
    const hoursInYear = 24 * 30 * 365;
    final diff = DateTime.now().difference(value);
    if (diff.inMinutes == 0) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}min ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inHours < hoursInMonth) return '${diff.inHours ~/ 24}d ago';
    return diff.inHours < hoursInYear
        ? '${diff.inHours ~/ hoursInMonth}mon ago'
        : '${diff.inHours ~/ hoursInYear}y ago';
  }

  const MessageListTile({super.key, required this.message});

  final MessageModel message;

  @override
  Widget build(final BuildContext context) => ListTile(
        minLeadingWidth: 20,
        leading: _icons[message.code],
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
        title: Row(
          children: [
            Text(
              getTitle(message),
              style: textStyleSourceSansPro614,
            ),
            if (message.isReceived)
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: DotColored(color: clRed),
              ),
          ],
        ),
        subtitle: RichText(
          text: TextSpan(
            style: textStyleSourceSansPro414Purple,
            children: buildTextWithId(
              leadingText: '${_roundedAgo(message.timestamp)} · from ',
              id: message.peerId,
            ),
          ),
        ),
        onTap: () => message.isReceived
            ? MessageActiveDialog.show(context: context, message: message)
            : MessageResolvedDialog.show(context: context, message: message),
      );
}
