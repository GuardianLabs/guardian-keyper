import 'package:guardian_keyper/ui/widgets/common.dart';

import 'message_home_presenter.dart';
import 'widgets/resolved_messages_tab.dart';
import 'widgets/active_messages_tab.dart';

class MessageHomeScreen extends StatelessWidget {
  const MessageHomeScreen({super.key});

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
        create: (final BuildContext context) => MessageHomePresenter(),
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            // Header
            appBar: AppBar(
              title: const Text('Messages'),
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Active'),
                  Tab(text: 'Resolved'),
                ],
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
