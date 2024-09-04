import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:guardian_keyper/app/routes.dart';
import 'package:guardian_keyper/feature/home/ui/dialogs/on_show_id_dialog.dart';
import 'package:guardian_keyper/ui/presenters/settings_presenter.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/vault/ui/widgets/shards_list.dart';
import 'package:guardian_keyper/feature/vault/ui/widgets/vaults_list.dart';
import 'package:guardian_keyper/feature/vault/domain/use_case/vault_interactor.dart';

import 'widgets/dev_drawer.dart';

class HomeScreen extends StatelessWidget {
  static final tabsCount = _tabs.length;

  static const _tabs = [
    VaultsList(key: PageStorageKey<String>('homeVaults')),
    ShardsList(key: PageStorageKey<String>('homeShards')),
  ];

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vaultInteractor = GetIt.I<VaultInteractor>();
    final theme = Theme.of(context);

    var swipeCount = 0;
    DateTime? lastSwipeTime;

    return DefaultTabController(
      length: tabsCount,
      child: PopScope(
        canPop: false,
        //Double swipe AppBar to close the App
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragEnd: (details) {
            final now = DateTime.now();
            if (details.primaryVelocity! > 0 &&
                details.primaryVelocity! > 1000) {
              if (lastSwipeTime == null ||
                  now.difference(lastSwipeTime!) > const Duration(seconds: 1)) {
                swipeCount = 1;
              } else {
                swipeCount += 1;
              }

              lastSwipeTime = now;

              if (swipeCount == 2) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Are you sure you want to close the app?'),
                    action: SnackBarAction(
                      label: 'Yes',
                      onPressed: SystemNavigator.pop,
                    ),
                  ),
                );
                swipeCount = 0;
              }
            }
          },
          child: ScaffoldSafe(
            //AppBar
            appBar: AppBar(
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(padding: paddingT20),
                  Selector<SettingsPresenter, String>(
                      builder: (context, value, child) => Text(
                            value,
                          ),
                      selector: (context, value) => value.name),
                  TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () => OnShowIdDialog.show(
                      context,
                      id: vaultInteractor.selfId.asHex,
                    ),
                    child: Text(
                      vaultInteractor.selfId.toHexShort(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: theme.colorScheme.onSurface,
                  ),
                  onPressed: () =>
                      Navigator.of(context).pushNamed(routeSettings),
                ),
              ],
              centerTitle: true,
              bottom: TabBar(
                padding: paddingH20,
                tabs: const [
                  Tab(text: 'Safes'),
                  Tab(text: 'Shards'),
                ],
                labelColor: theme.colorScheme.onSurface,
                dividerColor: theme.colorScheme.onSurface,
                indicatorColor: theme.colorScheme.onSurface,
              ),
            ),
            drawer: kDebugMode ? const DevDrawer() : null,
            child: const TabBarView(
              children: HomeScreen._tabs,
            ),
          ),
        ),
      ),
    );
  }
}
