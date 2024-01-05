import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/utils/screen_size.dart';

import 'package:guardian_keyper/feature/vault/ui/widgets/shards_list.dart';
import 'package:guardian_keyper/feature/vault/ui/widgets/vaults_list.dart';
import 'package:guardian_keyper/feature/message/ui/widgets/requests_list.dart';

import 'widgets/dashboard_list.dart';
import 'utils/build_navbar_items.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  static const _headers = [
    null,
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

  final _tabsBucket = PageStorageBucket();

  late final _navBarItems = buildNavbarItems(context);

  int _currentTab = 0;

  @override
  Widget build(BuildContext context) => ScaffoldSafe(
        header: MediaQuery.of(context).size.height >= ScreenMedium.height
            ? _headers[_currentTab]
            : null,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentTab,
          items: _navBarItems,
          onTap: (page) => setState(() => _currentTab = page),
        ),
        child: PageStorage(
          bucket: _tabsBucket,
          child: _tabs[_currentTab],
        ),
      );
}
