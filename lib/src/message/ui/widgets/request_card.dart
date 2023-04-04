import 'package:intl/intl.dart';

import '/src/core/ui/widgets/common.dart';
import '/src/core/ui/widgets/emoji.dart';
import '/src/core/data/core_model.dart';

class RequestCard extends StatelessWidget {
  final MessageModel message;

  const RequestCard({super.key, required this.message});

  @override
  Widget build(final BuildContext context) => Container(
        decoration: boxDecoration,
        padding: paddingAll20,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: paddingBottom20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('FROM', style: textStyleSourceSansPro612Purple),
                  RichText(
                    text: TextSpan(
                      children: buildTextWithId(
                        id: message.peerId,
                        style: textStyleSourceSansPro616,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: paddingBottom20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('KEY', style: textStyleSourceSansPro612Purple),
                  Text(
                    message.peerId.toHexShort(),
                    style: textStyleSourceSansPro616,
                  ),
                ],
              ),
            ),
            if (message.payload is VaultModel)
              Padding(
                padding: paddingBottom20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('VAULT', style: textStyleSourceSansPro612Purple),
                    RichText(
                      text: TextSpan(
                        children: buildTextWithId(
                          id: message.groupId,
                          style: textStyleSourceSansPro616,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (message.payload is SecretShardModel)
              Padding(
                padding: paddingBottom20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('SHARD', style: textStyleSourceSansPro612Purple),
                    Text(
                      message.secretShard.id.name,
                      style: textStyleSourceSansPro616,
                    ),
                  ],
                ),
              ),
            Padding(
              padding: paddingBottom20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('DATE', style: textStyleSourceSansPro612Purple),
                  Text(
                    '${DateFormat(DateFormat.HOUR24_MINUTE_SECOND).format(message.timestamp)} '
                    '  ${DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY).format(message.timestamp)}',
                    style: textStyleSourceSansPro616,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('STATUS', style: textStyleSourceSansPro612Purple),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: message.isAccepted
                        ? clGreen.withAlpha(56)
                        : clRed.withAlpha(56),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Text(
                        message.isAccepted ? ' Approved' : ' Rejected',
                        style: textStyleSourceSansPro616,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: DotColored(
                          color: message.isAccepted ? clGreen : clRed,
                          size: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
