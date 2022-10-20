import '/src/core/theme/theme.dart';
import '/src/core/widgets/misc.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/model/core_model.dart';

import 'message_action_widget.dart';
import 'request_card.dart';

class MessageListTile extends StatelessWidget {
  static const _icons = {
    MessageCode.createGroup: IconOf.shield(color: clWhite),
    MessageCode.setShard: IconOf.splitAndShare(),
    MessageCode.getShard: IconOf.secret(),
    MessageCode.takeGroup: IconOf.owner(),
  };

  static const _titles = {
    MessageCode.createGroup: 'Guardian Approval Request',
    MessageCode.setShard: 'Accept the Secret Shard',
    MessageCode.getShard: 'Secret Recovery Request',
    MessageCode.takeGroup: 'Ownership Change Request',
  };

  static String roundedAgo(DateTime value) {
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

  static Future<void> showActiveMessage(
    BuildContext context,
    MessageModel message,
  ) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => MessageActionWidget(
          title: _titles[message.code]!,
          message: message,
        ),
      );

  final MessageModel message;

  const MessageListTile({super.key, required this.message});

  @override
  Widget build(BuildContext context) => ListTile(
        minLeadingWidth: 20,
        leading: _icons[message.code],
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
        title: Row(
          children: [
            Text(
              _titles[message.code]!,
              style: textStyleSourceSansPro614,
            ),
            if (message.isReceived)
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: DotColored(color: clRed),
              ),
          ],
        ),
        subtitle: Text(
          '${roundedAgo(message.timestamp)} · from ${message.peerId.name}',
          style: textStyleSourceSansPro414Purple,
        ),
        onTap: message.isReceived
            ? () => showActiveMessage(context, message)
            : () => _showResolvedMessage(context, message),
      );

  Future<void> _showResolvedMessage(
    BuildContext context,
    MessageModel message,
  ) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => BottomSheetWidget(
          titleString: _titles[message.code]!,
          body: Padding(
            padding: paddingV20,
            child: RequestCard(message: message),
          ),
        ),
      );
}
