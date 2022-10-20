import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';
import '/src/core/di_container.dart';
import '/src/core/model/core_model.dart';

import '../guardian_controller.dart';
import '../widgets/message_list_tile.dart';

class MessagesPage extends StatelessWidget {
  static const _tabs = [Tab(text: 'Active'), Tab(text: 'Resolved')];

  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: paddingH20,
        child: DefaultTabController(
          length: _tabs.length,
          child: Scaffold(
            // Header
            appBar: AppBar(
              title: const Text('Messages'),
              bottom: const TabBar(
                tabs: _tabs,
                splashBorderRadius: borderRadiusTop,
              ),
            ),
            // Body
            body: Column(
              children: [
                const Divider(color: clIndigo500, height: 2, thickness: 2),
                Container(
                  height: 20,
                  color: Theme.of(context).colorScheme.background,
                ),
                const Expanded(
                  child: TabBarView(
                    children: [
                      _ActiveTabWidget(),
                      _ResolvedTabWidget(),
                    ],
                  ),
                ),
                Container(
                  height: 20,
                  color: Theme.of(context).colorScheme.background,
                ),
              ],
            ),
          ),
        ),
      );
}

class _ActiveTabWidget extends StatelessWidget {
  const _ActiveTabWidget();

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<Box<MessageModel>>(
        valueListenable: context.read<DIContainer>().boxMessages.listenable(),
        builder: (context, boxMessages, __) {
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
                        (msg) => Padding(
                          padding: paddingV6,
                          child: Dismissible(
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
                            confirmDismiss: (_) => showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => BottomSheetWidget(
                                titleString: 'Are you sure?',
                                textString:
                                    'This Request will be moved to Resolved'
                                    ' and you will not able to Approve it!',
                                footer: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text('No'),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: PrimaryButton(
                                        text: 'Yes',
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onDismissed: (_) => context
                                .read<GuardianController>()
                                .archivateMessage(msg),
                            child: MessageListTile(message: msg),
                          ),
                        ),
                      )
                      .toList(),
                );
        },
      );
}

class _ResolvedTabWidget extends StatelessWidget {
  const _ResolvedTabWidget();

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<Box<MessageModel>>(
        valueListenable: context.read<DIContainer>().boxMessages.listenable(),
        builder: (context, boxMessages, __) {
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
