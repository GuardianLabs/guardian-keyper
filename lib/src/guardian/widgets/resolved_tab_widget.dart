import '/src/core/widgets/common.dart';
import '/src/core/repository/repository_root.dart';

import 'message_list_tile.dart';

class ResolvedTabWidget extends StatelessWidget {
  const ResolvedTabWidget({super.key});

  @override
  Widget build(final BuildContext context) =>
      ValueListenableBuilder<Box<MessageModel>>(
        valueListenable:
            GetIt.I<RepositoryRoot>().messageRepository.listenable(),
        builder: (_, boxMessages, __) {
          final resolved = boxMessages.values
              .where((e) => e.isResolved)
              .toList(growable: false);
          resolved.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          return resolved.isEmpty
              ? Center(
                  child: Text(
                    'You don’t have any resolved messages',
                    textAlign: TextAlign.center,
                    style: textStyleSourceSansPro414,
                    softWrap: true,
                  ),
                )
              : ListView(
                  children: resolved
                      .map((e) => Padding(
                            padding: paddingV6,
                            child: MessageListTile(message: e),
                          ))
                      .toList(),
                );
        },
      );
}
