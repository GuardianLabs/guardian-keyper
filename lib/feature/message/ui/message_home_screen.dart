import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/utils/screen_size.dart';

import 'message_home_presenter.dart';
import 'widgets/resolved_messages_tab.dart';
import 'widgets/active_messages_tab.dart';

class MessageHomeScreen extends StatelessWidget {
  static const _tabBarView = TabBarView(children: [
    ActiveMessagesTab(),
    ResolvedMessagesTab(),
  ]);

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
    return ChangeNotifierProvider(
      create: (_) => MessageHomePresenter(),
      child: DefaultTabController(
        length: _tabBarView.children.length,
        child: Scaffold(
          // Header
          appBar: isTitleVisible
              ? AppBar(
                  bottom: _tabBar,
                  title: const Text('Notifications'),
                  titleTextStyle: theme.textTheme.titleMedium,
                )
              : _tabBar,
          // Body
          body: Container(
            decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              )),
            ),
            padding: paddingV20,
            child: _tabBarView,
          ),
        ),
      ),
    );
  }
}
