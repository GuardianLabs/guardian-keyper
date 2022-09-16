import 'package:intl/intl.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/misc.dart';
import '/src/core/model/core_model.dart';

class RequestCardWidget extends StatelessWidget {
  final MessageModel message;

  const RequestCardWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) => Container(
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
                  Text(
                    message.secretShard.ownerName,
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
                  Text('KEY', style: textStyleSourceSansPro612Purple),
                  Text(
                    message.secretShard.ownerId.toHexShort(),
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
                  Text('GROUP NAME', style: textStyleSourceSansPro612Purple),
                  Text(
                    message.secretShard.groupName,
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
