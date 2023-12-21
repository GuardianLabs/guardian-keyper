import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/utils/screen_size.dart';

import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';

import 'message_home_presenter.dart';
import 'widgets/message_list_tile.dart';
import 'dialogs/on_message_archivate_dialog.dart';
// import 'widgets/resolved_messages_tab.dart';
// import 'widgets/active_messages_tab.dart';

class MessageHomeScreen extends StatelessWidget {
  const MessageHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTitleVisible =
        MediaQuery.of(context).size.height >= ScreenMedium.height;
    return ChangeNotifierProvider(
      create: (_) => MessageHomePresenter(),
      builder: (context, child) {
        final presenter = context.watch<MessageHomePresenter>();
        return ScaffoldSafe(
          isSeparated: true,
          header: isTitleVisible
              ? AppBar(
                  title: const Text('Requests'),
                  titleTextStyle: theme.textTheme.titleMedium,
                )
              : null,
          child: presenter.isEmpty
              ? const Center(
                  child: Text(
                    'You don’t have any requests',
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                )
              : null,
          children: presenter.isEmpty
              ? null
              : [
                  if (presenter.activeMessages.isNotEmpty) ...[
                    for (final message in presenter.activeMessages)
                      Dismissible(
                        key: Key(message.aKey),
                        background: Container(
                          alignment: Alignment.centerLeft,
                          color: Theme.of(context).colorScheme.background,
                          height: double.infinity,
                          padding: paddingH20,
                          child: const Text('Move to Resolved'),
                        ),
                        direction: DismissDirection.startToEnd,
                        confirmDismiss: (_) =>
                            OnMessageArchivateDialog.show(context),
                        onDismissed: (_) =>
                            presenter.archivateMessage(message.copyWith(
                          status: MessageStatus.rejected,
                        )),
                        child: Padding(
                          padding: paddingV6,
                          child: MessageListTile(message: message),
                        ),
                      ),
                  ],
                  if (presenter.resolvedMessages.isNotEmpty) ...[
                    for (final message in presenter.resolvedMessages)
                      MessageListTile(message: message),
                  ],
                ],
        );
      },
    );
  }
}
