import '/src/core/widgets/common.dart';
import '/src/core/repository/repository_root.dart';

import '../guardian_controller.dart';
import 'message_list_tile.dart';

class ActiveTabWidget extends StatelessWidget {
  const ActiveTabWidget({super.key});

  @override
  Widget build(final BuildContext context) =>
      ValueListenableBuilder<Box<MessageModel>>(
        valueListenable:
            GetIt.I<RepositoryRoot>().messageRepository.listenable(),
        builder: (final BuildContext context, boxMessages, __) {
          final active = boxMessages.values
              .where((e) => e.isReceived)
              .toList(growable: false);
          active.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          return active.isEmpty
              ? Center(
                  child: Text(
                    'You don’t have any active messages',
                    textAlign: TextAlign.center,
                    style: textStyleSourceSansPro414,
                    softWrap: true,
                  ),
                )
              : ListView(
                  children: active
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
                          onDismissed: (_) => GetIt.I<GuardianController>()
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
        },
      );

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
