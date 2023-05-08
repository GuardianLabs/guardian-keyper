import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/domain/entity/message_model.dart';

import '../message_home_presenter.dart';
import '../dialogs/on_message_archivate_dialog.dart';
import 'message_list_tile.dart';

class ActiveMessagesTab extends StatelessWidget {
  const ActiveMessagesTab({super.key});

  @override
  Widget build(final BuildContext context) {
    final presenter = context.watch<MessageHomePresenter>();
    return presenter.activeMessages.isEmpty
        ? Center(
            child: Text(
              'You don’t have any active messages',
              textAlign: TextAlign.center,
              style: textStyleSourceSansPro414,
              softWrap: true,
            ),
          )
        : ListView(
            children: presenter.activeMessages
                .map(
                  (final MessageModel message) => Dismissible(
                    key: Key(message.aKey),
                    background: Container(
                      alignment: Alignment.centerLeft,
                      color: Theme.of(context).colorScheme.background,
                      height: double.infinity,
                      padding: paddingH20,
                      child: Text(
                        'Move to Resolved',
                        style: textStyleSourceSansPro416Purple,
                      ),
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
                )
                .toList(),
          );
  }
}
