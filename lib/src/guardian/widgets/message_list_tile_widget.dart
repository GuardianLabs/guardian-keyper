import '/src/core/theme_data.dart';
import '/src/core/widgets/misc.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/model/core_model.dart';

import 'message_action_widget.dart';
import 'request_card_widget.dart';

class MessageListTile extends StatelessWidget {
  static const _icons = {
    OperationType.authPeer: IconOf.shield(color: clWhite),
    OperationType.setShard: IconOf.splitAndShare(),
    OperationType.getShard: IconOf.secret(),
    OperationType.takeOwnership: IconOf.owner(),
  };

  static const _titles = {
    OperationType.authPeer: 'Guardian Approval Request',
    OperationType.setShard: 'Accept the Secret Shard',
    OperationType.getShard: 'Secret Recovery Request',
    OperationType.takeOwnership: 'Ownership Change Request',
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
          title: _titles[message.type]!,
          message: message,
        ),
      );

  final MessageModel message;

  const MessageListTile({super.key, required this.message});

  @override
  Widget build(BuildContext context) => ListTile(
        minLeadingWidth: 20,
        leading: _icons[message.type],
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
        title: Row(
          children: [
            Text(
              _titles[message.type]!,
              style: textStyleSourceSansPro614,
            ),
            if (message.isProcessed)
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: DotColored(color: clRed),
              ),
          ],
        ),
        subtitle: Text(
          '${roundedAgo(message.timestamp)} · from ${message.secretShard.ownerName}',
          style: textStyleSourceSansPro414Purple,
        ),
        onTap: message.isProcessed
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
          titleString: _titles[message.type]!,
          body: Padding(
            padding: paddingV20,
            child: RequestCardWidget(message: message),
          ),
        ),
      );
}
