import 'package:flutter/foundation.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/utils/screen_size.dart';

import 'package:guardian_keyper/feature/vault/ui/widgets/shards_list.dart';
import 'package:guardian_keyper/feature/vault/ui/widgets/vaults_list.dart';
import 'package:guardian_keyper/feature/message/ui/widgets/requests_list.dart';

import 'home_presenter.dart';
import 'widgets/dev_drawer.dart';
import 'widgets/bottom_navbar.dart';
import 'widgets/dashboard_list.dart';

class HomeScreen extends StatefulWidget {
  static final tabsCount = _tabs.length;

  static const _headers = [
    Offstage(),
    HeaderBar(caption: 'Safes'),
    HeaderBar(caption: 'Shards'),
    HeaderBar(caption: 'Requests'),
  ];

  static const _tabs = [
    DashboardList(key: PageStorageKey<String>('homeDashboard')),
    VaultsList(key: PageStorageKey<String>('homeVaults')),
    ShardsList(key: PageStorageKey<String>('homeShards')),
    RequestsList(key: PageStorageKey<String>('homeRequests')),
  ];

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final presenter = context.read<HomePresenter>();
    return ScaffoldSafe(
      header: MediaQuery.of(context).size.height >= ScreenMedium.height
          ? Selector<HomePresenter, int>(
              selector: (context, presenter) => presenter.currentPage,
              builder: (context, index, _) => HomeScreen._headers[index],
            )
          : null,
      drawer: kDebugMode ? const DevDrawer() : null,
      bottomNavigationBar: const BottomNavBar(),
      child: PageView(
        key: const Key('HomePageView'),
        controller: presenter,
        onPageChanged: presenter.jumpToPage,
        children: HomeScreen._tabs,
      ),
    );
  }
}
