import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';

import 'message_text_mixin.dart';

class OnMessageResolvedDialog extends StatelessWidget with MessageTextMixin {
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

  const OnMessageResolvedDialog({
    required this.message,
    super.key,
  });

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final style = TextStyle(
      color: colorScheme.onSecondary,
      fontWeight: FontWeight.w600,
      fontSize: 12,
    );
    return BottomSheetWidget(
      titleString: getTitle(message),
      body: Card(
        child: Padding(
          padding: paddingAll20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: paddingB20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('FROM', style: style),
                    Text(
                      message.peerId.name,
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
                    Text('KEY', style: style),
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
                      Text('VAULT', style: style),
                      Text(
                        message.vaultId.name,
                        style: styleSourceSansPro616,
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
                      Text('SHARD', style: style),
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
                    Text('DATE', style: style),
                    Text(
                      '${MessageTextMixin.h24ms.format(message.timestamp)} '
                      '  ${MessageTextMixin.yamd.format(message.timestamp)}',
                      style: styleSourceSansPro616,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('STATUS', style: style),
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
}
