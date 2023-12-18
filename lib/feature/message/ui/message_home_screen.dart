import 'package:guardian_keyper/ui/widgets/common.dart';

import 'message_home_presenter.dart';
import 'widgets/resolved_messages_tab.dart';
import 'widgets/active_messages_tab.dart';

class MessageHomeScreen extends StatelessWidget {
  static const _tabs = [
    ActiveMessagesTab(),
    ResolvedMessagesTab(),
  ];

  const MessageHomeScreen({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => MessageHomePresenter(),
        child: DefaultTabController(
          length: _tabs.length,
          child: Scaffold(
            primary: false,
            // Header
            appBar: AppBar(
              title: const Text('Notifications'),
              bottom: const TabBar(
                tabs: [Tab(text: 'Active'), Tab(text: 'Resolved')],
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
                const Expanded(child: TabBarView(children: _tabs)),
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
