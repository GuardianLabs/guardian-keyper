import '/src/core/widgets/common.dart';

import '/src/message/ui/widgets/active_messages_tab.dart';
import '/src/message/ui/widgets/resolved_messages_tab.dart';

class MessagesPage extends StatelessWidget {
  static const _tabs = [Tab(text: 'Active'), Tab(text: 'Resolved')];

  const MessagesPage({super.key});

  @override
  Widget build(final BuildContext context) => Padding(
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
                      ActiveMessagesTab(),
                      ResolvedMessagesTab(),
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
