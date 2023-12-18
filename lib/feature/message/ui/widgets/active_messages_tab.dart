import 'package:guardian_keyper/ui/widgets/common.dart';

import '../../domain/entity/message_model.dart';
import '../message_home_presenter.dart';
import '../dialogs/on_message_archivate_dialog.dart';
import 'message_list_tile.dart';

class ActiveMessagesTab extends StatelessWidget {
  const ActiveMessagesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final presenter = context.watch<MessageHomePresenter>();
    return presenter.activeMessages.isEmpty
        ? const Center(
            child: Text(
              'You don’t have any active notifications',
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          )
        : ListView(
            children: presenter.activeMessages
                .map(
                  (message) => Dismissible(
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
                )
                .toList(),
          );
  }
}
