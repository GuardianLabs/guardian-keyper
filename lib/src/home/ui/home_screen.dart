import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

import '/src/core/consts.dart';
import '/src/core/ui/widgets/common.dart';
import '/src/core/ui/widgets/icon_of.dart';
import '/src/core/ui/widgets/auth/auth.dart';
import '/src/vaults/data/vault_repository.dart';
import '/src/message/data/message_repository.dart';
import '/src/settings/data/settings_repository.dart';
import '/src/message/ui/widgets/message_action_bottom_sheet.dart';

import 'home_presenter.dart';
import 'pages/shards_page.dart';
import 'pages/vaults_page.dart';
import 'pages/messages_page.dart';
import 'pages/dashboard_page.dart';
import 'widgets/notification_icon.dart';

class HomeScreen extends StatefulWidget {
  static const pages = [
    DashboardPage(),
    VaultsPage(),
    ShardsPage(),
    MessagesPage(),
  ];

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final _settingsRepository = GetIt.I<SettingsRepository>();
  final _messageRepository = GetIt.I<MessageRepository>();
  final _vaultRepository = GetIt.I<VaultRepository>();

  late final _presenter = context.read<HomePresenter>();
  late final StreamSubscription<BoxEvent> _messageStreamSubscription;

  // bool _isLocked = true;
  bool _canShowMessage = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _messageStreamSubscription = _messageRepository.watch().listen((event) {
      if (!_canShowMessage) return;
      if (event.deleted) return;
      final message = event.value as MessageModel;
      if (message.isNotReceived) return;
      final routeName = ModalRoute.of(context)?.settings.name;
      if (routeName == '/' || routeName == routeShowQrCode) {
        _canShowMessage = false;
        Navigator.of(context).popUntil((r) => r.isFirst);
        MessageActionBottomSheet.show(context, message)
            .then((_) => _canShowMessage = true);
      }
    });

    Future.microtask(() async {
      if (_settingsRepository.settings.passCode.isEmpty) {
        // _isLocked = false;
        await Navigator.of(context).pushNamed(routeIntro);
      } else {
        await _demandPassCode(context);
      }
      _canShowMessage = true;
      await _presenter.startNetwork();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // if (_isLocked) await _demandPassCode(context);
      await _presenter.startNetwork();
    } else {
      // _isLocked = true;
      await _presenter.pauseNetwork();
      await _vaultRepository.flush();
      await _messageRepository.flush();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _presenter.stopNetwork();
    _messageStreamSubscription.cancel();
    _vaultRepository.flush();
    _messageRepository.flush();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => Selector<HomePresenter, int>(
        selector: (_, presenter) => presenter.currentPage,
        builder: (_, final currentPage, __) => Scaffold(
          primary: true,
          resizeToAvoidBottomInset: true,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentPage,
            items: const [
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
                icon: MessagesIcon(),
                activeIcon: MessagesIcon.selected(),
                label: 'Messages',
              ),
            ],
            onTap: (value) => _presenter.gotoScreen(value),
          ),
          body: DoubleBackToCloseApp(
            snackBar: const SnackBar(
              content: Text('Tap back again to exit'),
            ),
            child: SafeArea(child: HomeScreen.pages[currentPage]),
          ),
        ),
      );

  Future<void> _demandPassCode(final BuildContext context) =>
      showDemandPassCode(
        context: context,
        onVibrate: _presenter.vibrate,
        currentPassCode: _settingsRepository.settings.passCode,
        localAuthenticate: _presenter.localAuthenticate,
        useBiometrics: _presenter.hasBiometrics &&
            _settingsRepository.settings.isBiometricsEnabled,
      );
}
