import 'dart:async';

import 'package:guardian_keyper/consts.dart';
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
    HeaderBar(caption: 'Vaults'),
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

  late final _isTitleVisible =
      MediaQuery.of(context).size.height >= ScreenMedium.height;

  int _currentTab = 0;
  DateTime _lastExitTryAt = DateTime.timestamp();

  @override
  Widget build(BuildContext context) => ScaffoldSafe(
        header: _isTitleVisible ? _headers[_currentTab] : null,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentTab,
          items: _navBarItems,
          onTap: (page) => setState(() => _currentTab = page),
        ),
        // ignore: deprecated_member_use
        child: WillPopScope(
          onWillPop: _onWillPop,
          child: PageStorage(
            bucket: _tabsBucket,
            child: _tabs[_currentTab],
          ),
        ),
      );

  Future<bool> _onWillPop() async {
    final now = DateTime.timestamp();
    if (_lastExitTryAt.isAfter(now.subtract(snackBarDuration))) {
      return true;
    }
    _lastExitTryAt = now;
    showSnackBar(
      context,
      text: 'Tap back again to exit',
    );
    return false;
  }
}
