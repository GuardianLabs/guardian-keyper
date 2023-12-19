import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/utils/screen_size.dart';

import 'message_home_presenter.dart';
import 'widgets/resolved_messages_tab.dart';
import 'widgets/active_messages_tab.dart';

class MessageHomeScreen extends StatelessWidget {
  static const _tabs = [
    ActiveMessagesTab(),
    ResolvedMessagesTab(),
  ];

  static const PreferredSizeWidget _tabBar = TabBar(
    dividerHeight: 0,
    tabs: [
      Tab(text: 'Active'),
      Tab(text: 'Resolved'),
    ],
  );

  const MessageHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTitleVisible =
        MediaQuery.of(context).size.height >= ScreenMedium.height;
    final filledPading = Container(
      height: 20,
      color: theme.colorScheme.background,
    );
    return ChangeNotifierProvider(
      create: (_) => MessageHomePresenter(),
      child: DefaultTabController(
        length: _tabs.length,
        child: ScaffoldSafe(
          // Header
          header: isTitleVisible
              ? AppBar(
                  bottom: _tabBar,
                  title: Text(
                    'Notifications',
                    style: theme.textTheme.titleMedium,
                  ),
                )
              : _tabBar,
          // Body
          child: Column(
            children: [
              const Divider(height: 2),
              filledPading,
              const Expanded(child: TabBarView(children: _tabs)),
              filledPading,
            ],
          ),
        ),
      ),
    );
  }
}
