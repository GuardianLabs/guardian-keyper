import 'package:intl/intl.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';

import '../../domain/entity/message_model.dart';
import 'message_titles_mixin.dart';

class OnMessageResolvedDialog extends StatelessWidget with MessageTitlesMixin {
  static Future<bool?> show(
    BuildContext context, {
    required MessageModel message,
  }) =>
      showModalBottomSheet<bool>(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        builder: (_) => OnMessageResolvedDialog(message: message),
      );

  static final _yamd = DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY);
  static final _h24ms = DateFormat(DateFormat.HOUR24_MINUTE_SECOND);

  const OnMessageResolvedDialog({
    required this.message,
    super.key,
  });

  final MessageModel message;

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
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
                  padding: paddingB20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('FROM', style: styleSourceSansPro612Purple),
                      RichText(
                        text: TextSpan(
                          children: buildTextWithId(
                            name: message.peerId.name,
                            style: styleSourceSansPro616,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: paddingB20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('KEY', style: styleSourceSansPro612Purple),
                      Text(
                        message.peerId.toHexShort(),
                        style: styleSourceSansPro616,
                      ),
                    ],
                  ),
                ),
                if (message.containsVault)
                  Padding(
                    padding: paddingB20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('VAULT', style: styleSourceSansPro612Purple),
                        RichText(
                          text: TextSpan(
                            children: buildTextWithId(
                              name: message.vaultId.name,
                              style: styleSourceSansPro616,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (message.containsSecretShard)
                  Padding(
                    padding: paddingB20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('SHARD', style: styleSourceSansPro612Purple),
                        Text(
                          message.secretShard.id.name,
                          style: styleSourceSansPro616,
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: paddingB20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('DATE', style: styleSourceSansPro612Purple),
                      Text(
                        '${_h24ms.format(message.timestamp)} '
                        '  ${_yamd.format(message.timestamp)}',
                        style: styleSourceSansPro616,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('STATUS', style: styleSourceSansPro612Purple),
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
                            style: styleSourceSansPro616,
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
