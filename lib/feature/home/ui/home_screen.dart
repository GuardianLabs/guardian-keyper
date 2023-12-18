import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/app/routes.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/theme/brand_colors.dart';
import 'package:guardian_keyper/ui/dialogs/qr_code_show_dialog.dart';

import 'package:guardian_keyper/feature/auth/data/auth_manager.dart';
import 'package:guardian_keyper/feature/network/data/network_manager.dart';

import 'package:guardian_keyper/feature/vault/domain/use_case/vault_interactor.dart';
import 'package:guardian_keyper/feature/message/domain/use_case/message_interactor.dart';

import 'package:guardian_keyper/feature/message/ui/message_home_screen.dart';
import 'package:guardian_keyper/feature/auth/ui/dialogs/on_demand_auth_dialog.dart';
import 'package:guardian_keyper/feature/message/ui/dialogs/on_message_active_dialog.dart';

import 'pages/home_page.dart';
import 'pages/home_vault_page.dart';
import 'pages/home_shards_page.dart';
import 'widgets/notifications_icon.dart';

class HomeScreen extends StatefulWidget {
  static const _tabs = [
    HomePage(),
    HomeVaultsPage(),
    HomeShardsPage(),
    MessageHomeScreen(),
  ];

  static const _iconSize = 32.0;
  static const _homeSvg = 'assets/icons/home.svg';
  static const _vaultsSvg = 'assets/icons/home_vaults.svg';
  static const _shardsSvg = 'assets/icons/home_shards.svg';

  static List<BottomNavigationBarItem> _buildNavBarItems(Color color) {
    final colorFilter = ColorFilter.mode(color, BlendMode.srcIn);
    return [
      BottomNavigationBarItem(
        // Home
        label: 'Home',
        icon: SvgPicture.asset(_homeSvg, height: _iconSize, width: _iconSize),
        activeIcon: SvgPicture.asset(
          _homeSvg,
          colorFilter: colorFilter,
          height: _iconSize,
          width: _iconSize,
        ),
      ),
      // Vaults
      BottomNavigationBarItem(
        label: 'Vaults',
        icon: SvgPicture.asset(_vaultsSvg, height: _iconSize, width: _iconSize),
        activeIcon: SvgPicture.asset(
          _vaultsSvg,
          colorFilter: colorFilter,
          height: _iconSize,
          width: _iconSize,
        ),
      ),
      // Shards
      BottomNavigationBarItem(
        label: 'Shards',
        icon: SvgPicture.asset(_shardsSvg, height: _iconSize, width: _iconSize),
        activeIcon: SvgPicture.asset(
          _shardsSvg,
          colorFilter: colorFilter,
          height: _iconSize,
          width: _iconSize,
        ),
      ),
      // Notifications
      const BottomNavigationBarItem(
        label: 'Notifications',
        icon: NotificationsIcon(isSelected: false, iconSize: _iconSize),
        activeIcon: NotificationsIcon(isSelected: true, iconSize: _iconSize),
      ),
    ];
  }

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _currentTab = 0;
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
        GetIt.I<NetworkManager>().stop();
        GetIt.I<VaultInteractor>().flush();
        GetIt.I<MessageInteractor>().flush();

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
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentTab,
          items: HomeScreen._buildNavBarItems(
            Theme.of(context).extension<BrandColors>()!.highlightColor,
          ),
          onTap: (int page) => setState(() => _currentTab = page),
        ),
        // ignore: deprecated_member_use
        body: WillPopScope(
          onWillPop: () async {
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
          },
          child: SafeArea(
            child: Padding(
              padding: paddingH20,
              child: IndexedStack(
                index: _currentTab,
                children: HomeScreen._tabs,
              ),
            ),
          ),
        ),
      );
}
