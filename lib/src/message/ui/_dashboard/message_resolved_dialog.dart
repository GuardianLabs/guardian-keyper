import 'package:intl/intl.dart';

import 'package:guardian_keyper/src/core/ui/widgets/emoji.dart';
import 'package:guardian_keyper/src/core/ui/widgets/common.dart';

import '../../domain/message_model.dart';
import 'message_titles_mixin.dart';

class MessageResolvedDialog extends StatelessWidget with MessageTitlesMixin {
  static Future<bool?> show({
    required final BuildContext context,
    required final MessageModel message,
  }) =>
      showModalBottomSheet<bool>(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        builder: (final BuildContext context) =>
            MessageResolvedDialog(message: message),
      );

  final MessageModel message;

  const MessageResolvedDialog({super.key, required this.message});

  @override
  Widget build(final BuildContext context) => BottomSheetWidget(
        titleString: getTitle(message),
        body: Padding(
          padding: paddingV20,
          child: Container(
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
                if (message.haveVault)
                  Padding(
                    padding: paddingBottom20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('VAULT', style: textStyleSourceSansPro612Purple),
                        RichText(
                          text: TextSpan(
                            children: buildTextWithId(
                              id: message.vaultId,
                              style: textStyleSourceSansPro616,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (message.haveSecretShard)
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
          ),
        ),
      );
}
