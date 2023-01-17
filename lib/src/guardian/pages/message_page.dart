import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';

import '../widgets/active_tab_widget.dart';
import '../widgets/resolved_tab_widget.dart';

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
                      ActiveTabWidget(),
                      ResolvedTabWidget(),
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
