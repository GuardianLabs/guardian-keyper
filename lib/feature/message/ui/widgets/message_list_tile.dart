import 'package:guardian_keyper/ui/widgets/emoji.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/domain/entity/message_model.dart';

import '../dialogs/on_message_resolved_dialog.dart';
import '../dialogs/on_message_active_dialog.dart';
import '../dialogs/message_titles_mixin.dart';

class MessageListTile extends StatelessWidget with MessageTitlesMixin {
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
        leading: getIcon(message),
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
            ? OnMessageActiveDialog.show(context: context, message: message)
            : OnMessageResolvedDialog.show(context: context, message: message),
      );
}
