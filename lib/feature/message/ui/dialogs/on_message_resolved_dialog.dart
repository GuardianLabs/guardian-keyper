import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/theme/brand_colors.dart';

import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';

import 'message_text_mixin.dart';

class OnMessageResolvedDialog extends StatelessWidget with MessageTextMixin {
  static Future<bool?> show(
    BuildContext context, {
    required MessageModel message,
  }) =>
      showModalBottomSheet<bool>(
        context: context,
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
    final theme = Theme.of(context);
    final brandColors = theme.extension<BrandColors>()!;
    return BottomSheetWidget(
      titleString: getTitle(message),
      body: Card(
        child: Padding(
          padding: paddingAllDefault,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: paddingBDefault,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'FROM',
                      style: theme.textTheme.labelMedium,
                    ),
                    Text(
                      message.peerId.name,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: paddingBDefault,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'KEY',
                      style: theme.textTheme.labelMedium,
                    ),
                    Text(
                      message.peerId.toHexShort(),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              if (message.containsVault)
                Padding(
                  padding: paddingBDefault,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'VAULT',
                        style: theme.textTheme.labelMedium,
                      ),
                      Text(
                        message.vaultId.name,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              if (message.containsSecretShard)
                Padding(
                  padding: paddingBDefault,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'SHARD',
                        style: theme.textTheme.labelMedium,
                      ),
                      Text(
                        message.secretShard.id.name,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              Padding(
                padding: paddingBDefault,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'DATE',
                      style: theme.textTheme.labelMedium,
                    ),
                    Text(
                      '${MessageTextMixin.h24ms.format(message.timestamp)} '
                      '  ${MessageTextMixin.yamd.format(message.timestamp)}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'STATUS',
                    style: theme.textTheme.labelMedium,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: message.isAccepted
                          ? brandColors.highlightColor.withAlpha(56)
                          : brandColors.dangerColor.withAlpha(56),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Text(
                          message.isAccepted ? ' Approved' : ' Rejected',
                          style: theme.textTheme.bodyMedium,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Container(
                            decoration: BoxDecoration(
                              color: message.isAccepted
                                  ? brandColors.highlightColor
                                  : brandColors.dangerColor,
                              shape: BoxShape.circle,
                            ),
                            height: 8,
                            width: 8,
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
