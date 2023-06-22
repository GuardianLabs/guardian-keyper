import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/utils/utils.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/network/data/network_manager.dart';
import 'package:guardian_keyper/feature/dashboard/ui/dashboard_screen.dart';

import 'package:guardian_keyper/feature/auth/data/auth_manager.dart';
import 'package:guardian_keyper/feature/auth/ui/dialogs/on_demand_auth_dialog.dart';

import 'package:guardian_keyper/feature/vault/ui/_shard_home/shard_home_screen.dart';
import 'package:guardian_keyper/feature/vault/ui/_vault_home/vault_home_screen.dart';

import 'package:guardian_keyper/feature/message/domain/use_case/message_interactor.dart';
import 'package:guardian_keyper/feature/message/ui/dialogs/on_message_active_dialog.dart';
import 'package:guardian_keyper/feature/message/ui/message_home_screen.dart';

import 'widgets/bottom_navbar.dart';

class HomeScreen extends StatefulWidget {
  static const _pages = [
    DashboardScreen(),
    VaultHomeScreen(),
    ShardHomeScreen(),
    MessageHomeScreen(),
  ];

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final _networkManager = GetIt.I<NetworkManager>();
  final _messagesInteractor = GetIt.I<MessageInteractor>();

  int _currentPage = 0;
  bool _canShowMessage = true;
  DateTime _lastExitTryAt = DateTime.now();

  @override
  void initState() {
    super.initState();

    _messagesInteractor.watch().listen((event) {
      if (event.isDeleted) return;
      if (!_canShowMessage) return;
      if (event.message!.isNotReceived) return;
      final routeName = ModalRoute.of(context)?.settings.name;
      if (routeName == '/' || routeName == routeQrCodeShow) {
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
        _messagesInteractor.pruneMessages();
        await OnDemandAuthDialog.show(context);
      }
      await _networkManager.start();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: clIndigo900,
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: BottomNavbar(
          key: Key('HomePage_$_currentPage'),
          currentPage: _currentPage,
          onTap: _gotoPage,
        ),
        body: WillPopScope(
          onWillPop: _onWillPop,
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

  Future<bool> _onWillPop() async {
    final now = DateTime.now();
    if (_lastExitTryAt.isAfter(now.subtract(snackBarDuration))) return true;

    _lastExitTryAt = now;
    ScaffoldMessenger.of(context).showSnackBar(
      buildSnackBar(text: 'Tap back again to exit'),
    );
    return false;
  }

  void _gotoPage(int page) => setState(() => _currentPage = page);

  void gotoVaults() =>
      _gotoPage(HomeScreen._pages.indexWhere((e) => e is VaultHomeScreen));

  void gotoShards() =>
      _gotoPage(HomeScreen._pages.indexWhere((e) => e is ShardHomeScreen));
}
