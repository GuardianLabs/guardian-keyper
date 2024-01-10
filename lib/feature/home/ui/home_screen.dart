import 'package:flutter/foundation.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/app/routes.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/utils/screen_size.dart';

import 'package:guardian_keyper/feature/vault/ui/widgets/shards_list.dart';
import 'package:guardian_keyper/feature/vault/ui/widgets/vaults_list.dart';
import 'package:guardian_keyper/feature/message/ui/widgets/requests_list.dart';
import 'package:guardian_keyper/feature/auth/ui/dialogs/on_demand_auth_dialog.dart';

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

class HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late final _presenter = context.read<HomePresenter>();

  DateTime _lastExitTryAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() async {
      if (_presenter.isFirstStart) {
        await Navigator.of(context).pushNamed(
          buildV3 ? routeOnboarding : routeIntro,
        );
      } else if (_presenter.isNotFirstStart) {
        await OnDemandAuthDialog.show(context);
      }
      await _presenter.onStart();
    });
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        await _presenter.onResumed();
        if (_presenter.needPasscode && mounted) {
          await OnDemandAuthDialog.show(context);
        }
        await _presenter.onStart();
      case AppLifecycleState.inactive:
        await _presenter.onInactive();
      case AppLifecycleState.paused:
        await _presenter.onPaused();
      case _:
    }
  }

  @override
  Future<bool> didPopRoute() {
    final now = DateTime.now();
    if (_lastExitTryAt.isBefore(now.subtract(snackBarDuration))) {
      _lastExitTryAt = now;
      showSnackBar(context, text: 'Tap back again to exit');
      return Future.value(true);
    }
    return super.didPopRoute();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        controller: _presenter,
        onPageChanged: _presenter.jumpToPage,
        children: HomeScreen._tabs,
      ),
    );
  }
}
