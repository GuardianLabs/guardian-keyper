import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/theme/brand_colors.dart';

import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';

import '../dialogs/on_message_resolved_dialog.dart';
import '../dialogs/on_message_active_dialog.dart';
import '../dialogs/message_text_mixin.dart';

class MessageListTile extends StatelessWidget with MessageTextMixin {
  const MessageListTile({
    required this.message,
    super.key,
  });

  final MessageModel message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brandColors = theme.extension<BrandColors>()!;
    return ListTile(
      trailing: const Icon(Icons.arrow_forward_ios_rounded),
      title: Row(
        children: [
          Text(
            getTitle(message),
            style: theme.textTheme.bodyMedium,
          ),
          if (message.isReceived)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: DotColored(color: brandColors.dangerColor),
            ),
        ],
      ),
      subtitle: RichText(
        text: TextSpan(
          style: theme.textTheme.bodySmall,
          children: [
            TextSpan(text: '${roundedAgo(message)} · from '),
            TextSpan(text: message.peerId.name, style: styleW600)
          ],
        ),
      ),
      onTap: () => message.isReceived
          ? OnMessageActiveDialog.show(context, message: message)
          : OnMessageResolvedDialog.show(context, message: message),
    );
  }
}
