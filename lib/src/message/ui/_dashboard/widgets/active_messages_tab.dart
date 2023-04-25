import 'package:guardian_keyper/src/core/ui/widgets/common.dart';

import '../../../domain/message_model.dart';
import '../presenters/messages_presenter.dart';
import 'message_list_tile.dart';

class ActiveMessagesTab extends StatelessWidget {
  const ActiveMessagesTab({super.key});

  @override
  Widget build(final BuildContext context) {
    final messages = context.watch<MessagesPresenter>().activeMessages;
    return messages.isEmpty
        ? Center(
            child: Text(
              'You don’t have any active messages',
              textAlign: TextAlign.center,
              style: textStyleSourceSansPro414,
              softWrap: true,
            ),
          )
        : ListView(
            children: messages
                .map(
                  (msg) => Dismissible(
                    key: Key(msg.aKey),
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
                    confirmDismiss: (_) => _showConfirmation(context),
                    onDismissed: (_) => context
                        .read<MessagesPresenter>()
                        .archivateMessage(msg.copyWith(
                          status: MessageStatus.rejected,
                        )),
                    child: Padding(
                      padding: paddingV6,
                      child: MessageListTile(message: msg),
                    ),
                  ),
                )
                .toList(),
          );
  }

  Future<bool?> _showConfirmation(final BuildContext context) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (final BuildContext context) => BottomSheetWidget(
          titleString: 'Are you sure?',
          textString: 'This Request will be moved to Resolved'
              ' and you will not able to Approve it!',
          footer: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: PrimaryButton(
                  text: 'Yes',
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ),
            ],
          ),
        ),
      );
}
