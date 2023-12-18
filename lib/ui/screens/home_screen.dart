import 'dart:async';
import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/utils/utils.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';
import 'package:guardian_keyper/ui/dialogs/qr_code_show_dialog.dart';

import 'package:guardian_keyper/feature/network/data/network_manager.dart';
import 'package:guardian_keyper/feature/dashboard/ui/dashboard_screen.dart';

import 'package:guardian_keyper/feature/auth/data/auth_manager.dart';
import 'package:guardian_keyper/feature/auth/ui/dialogs/on_demand_auth_dialog.dart';

import 'package:guardian_keyper/feature/vault/domain/use_case/vault_interactor.dart';
import 'package:guardian_keyper/feature/vault/ui/_shard_home/shard_home_screen.dart';
import 'package:guardian_keyper/feature/vault/ui/_vault_home/vault_home_screen.dart';

import 'package:guardian_keyper/feature/message/domain/use_case/message_interactor.dart';
import 'package:guardian_keyper/feature/message/ui/dialogs/on_message_active_dialog.dart';
import 'package:guardian_keyper/feature/message/ui/widgets/message_notify_icon.dart';
import 'package:guardian_keyper/feature/message/ui/message_home_screen.dart';

class HomeScreen extends StatefulWidget {
  static const _pages = [
    DashboardScreen(),
    VaultHomeScreen(),
    ShardHomeScreen(),
    MessageHomeScreen(),
  ];

  static const _tabs = [
    BottomNavigationBarItem(
      icon: IconOf.navBarHome(),
      activeIcon: IconOf.navBarHomeSelected(),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: IconOf.navBarKey(),
      activeIcon: IconOf.navBarKeySelected(),
      label: 'Vaults',
    ),
    BottomNavigationBarItem(
      icon: IconOf.navBarShield(),
      activeIcon: IconOf.navBarShieldSelected(),
      label: 'Shards',
    ),
    BottomNavigationBarItem(
      icon: MessageNotifyIcon(isSelected: false),
      activeIcon: MessageNotifyIcon(isSelected: true),
      label: 'Messages',
    ),
  ];

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _currentPage = 0;
  bool _canShowMessage = true;
  DateTime _lastExitTryAt = DateTime.timestamp();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    GetIt.I<MessageInteractor>().watch().listen((event) {
      if (event.isDeleted) return;
      if (!_canShowMessage) return;
      if (event.message!.isNotReceived) return;
      final routeName = ModalRoute.of(context)?.settings.name;
      if (routeName == '/' || routeName == QRCodeShowDialog.route) {
        _canShowMessage = false;
        Navigator.of(context).popUntil((r) => r.isFirst);
        OnMessageActiveDialog.show(context, message: event.message!)
            .then((_) => _canShowMessage = true);
      }
    });

    Future.microtask(() async {
      if (GetIt.I<AuthManager>().passCode.isEmpty) {
        await Navigator.of(context).pushNamed(routeIntro);
      } else {
        unawaited(GetIt.I<MessageInteractor>().pruneMessages());
        await OnDemandAuthDialog.show(context);
      }
      await GetIt.I<NetworkManager>().start();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        GetIt.I<NetworkManager>().start();

      case AppLifecycleState.paused:
        GetIt.I<MessageInteractor>().flush();
        GetIt.I<VaultInteractor>().flush();
        GetIt.I<NetworkManager>().stop();

      case _:
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: clIndigo900,
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentPage,
          items: HomeScreen._tabs,
          onTap: _gotoPage,
        ),
        // ignore: deprecated_member_use
        body: WillPopScope(
          onWillPop: () async {
            final now = DateTime.timestamp();
            if (_lastExitTryAt.isAfter(now.subtract(snackBarDuration))) {
              return true;
            }
            _lastExitTryAt = now;
            ScaffoldMessenger.of(context).showSnackBar(
              buildSnackBar(text: 'Tap back again to exit'),
            );
            return false;
          },
          child: SafeArea(
            child: Padding(
              padding: paddingH20,
              child: IndexedStack(
                index: _currentPage,
                children: HomeScreen._pages,
              ),
            ),
          ),
        ),
      );

  void gotoVaults() =>
      _gotoPage(HomeScreen._pages.indexWhere((e) => e is VaultHomeScreen));

  void gotoShards() =>
      _gotoPage(HomeScreen._pages.indexWhere((e) => e is ShardHomeScreen));

  void _gotoPage(int page) => setState(() => _currentPage = page);
}
