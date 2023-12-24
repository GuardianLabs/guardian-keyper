import 'dart:async';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/app/routes.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/utils/screen_size.dart';
import 'package:guardian_keyper/ui/dialogs/qr_code_show_dialog.dart';

import 'package:guardian_keyper/feature/auth/data/auth_manager.dart';
import 'package:guardian_keyper/feature/network/data/network_manager.dart';
import 'package:guardian_keyper/feature/message/data/message_repository.dart';
import 'package:guardian_keyper/feature/message/domain/use_case/message_interactor.dart';

import 'package:guardian_keyper/feature/vault/ui/widgets/shards_list.dart';
import 'package:guardian_keyper/feature/vault/ui/widgets/vaults_list.dart';
import 'package:guardian_keyper/feature/message/ui/widgets/requests_list.dart';
import 'package:guardian_keyper/feature/auth/ui/dialogs/on_demand_auth_dialog.dart';
import 'package:guardian_keyper/feature/message/ui/dialogs/on_message_active_dialog.dart';

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
  final _authManager = GetIt.I<AuthManager>();
  final _networkManager = GetIt.I<NetworkManager>();
  final _messageInteractor = GetIt.I<MessageInteractor>();

  late final _navBarItems = buildNavbarItems(context);

  late final _isTitleVisible =
      MediaQuery.of(context).size.height >= ScreenMedium.height;

  late final StreamSubscription<MessageRepositoryEvent> _requestsStream;

  int _currentTab = 0;
  bool _canShowMessage = true;
  DateTime _lastExitTryAt = DateTime.timestamp();

  @override
  void initState() {
    super.initState();
    _requestsStream = _messageInteractor.watch().listen(_onRequest);
    Future.microtask(_onFirstStart);
  }

  @override
  Future<void> dispose() async {
    await _requestsStream.cancel();
    super.dispose();
  }

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

  void _onRequest(MessageRepositoryEvent event) {
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
  }

  Future<void> _onFirstStart() async {
    if (_authManager.passCode.isEmpty) {
      await Navigator.of(context).pushNamed(routeIntro);
    } else {
      unawaited(_messageInteractor.pruneMessages());
      await OnDemandAuthDialog.show(context);
    }
    await _networkManager.start();
  }

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
