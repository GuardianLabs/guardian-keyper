import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';
import 'package:guardian_keyper/feature/message/domain/use_case/message_interactor.dart';

import 'request_list_tile.dart';
import '../dialogs/on_message_archivate_dialog.dart';

class RequestsList extends StatelessWidget {
  const RequestsList({super.key});

  @override
  Widget build(BuildContext context) {
    final messagesInteractor = GetIt.I<MessageInteractor>();
    return StreamBuilder(
      stream: messagesInteractor.watch(),
      builder: (context, _) {
        final backgroundColor = Theme.of(context).colorScheme.background;
        final requests = messagesInteractor.messages.toList()
          ..sort((a, b) => b.timestamp.compareTo(a.timestamp))
          ..sort((a, b) {
            if (a.isReceived && b.isReceived) return 0;
            return a.isReceived ? -1 : 1;
          });
        return requests.isEmpty
            ? const Center(
                child: Text(
                  'You don’t have any requests',
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              )
            : ListView.separated(
                padding: paddingAll20,
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final request = requests[index];
                  return request.isReceived
                      ? Dismissible(
                          key: Key(request.aKey),
                          background: Container(
                            alignment: Alignment.centerLeft,
                            color: backgroundColor,
                            height: double.infinity,
                            padding: paddingH20,
                            child: const Text('Move to Resolved'),
                          ),
                          direction: DismissDirection.startToEnd,
                          confirmDismiss: (_) =>
                              OnMessageArchivateDialog.show(context),
                          onDismissed: (_) => messagesInteractor
                              .archivateMessage(request.copyWith(
                            status: MessageStatus.rejected,
                          )),
                          child: RequestListTile(message: request),
                        )
                      : RequestListTile(
                          key: Key(request.aKey),
                          message: request,
                        );
                },
                separatorBuilder: (_, __) => const Padding(padding: paddingT12),
              );
      },
    );
  }
}
