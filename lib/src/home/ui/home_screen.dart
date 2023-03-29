import 'dart:async';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

import '/src/core/consts.dart';
import '/src/core/ui/widgets/common.dart';
import '/src/core/ui/widgets/icon_of.dart';
import '/src/core/ui/widgets/auth/auth.dart';
import '/src/core/service/service_root.dart';
import '/src/core/data/repository_root.dart';
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
  final _serviceRoot = GetIt.I<ServiceRoot>();
  final _repositoryRoot = GetIt.I<RepositoryRoot>();

  late final StreamSubscription<BoxEvent> _messageStreamSubscription;

  bool _isLocked = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _messageStreamSubscription =
        _repositoryRoot.messageRepository.watch().listen((event) {
      if (ModalRoute.of(context)?.isCurrent != true) return;
      if (event.deleted) return;
      final message = event.value as MessageModel;
      if (message.isNotReceived) return;
      MessageActionBottomSheet.show(context, message);
    });

    Future.microtask(() async {
      if (_repositoryRoot.settingsRepository.passCode.isEmpty) {
        _isLocked = false;
        await Navigator.of(context).pushNamed(routeIntro);
      } else {
        await _demandPassCode(context);
      }
      await _serviceRoot.networkService.start();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (_isLocked) await _demandPassCode(context);
      await _serviceRoot.networkService.start();
    } else if (state != AppLifecycleState.inactive) {
      _isLocked = true;
      await _serviceRoot.networkService.pause();
      await _repositoryRoot.vaultRepository.flush();
      await _repositoryRoot.messageRepository.flush();
    }
  }

  @override
  void dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    await _serviceRoot.networkService.stop();
    await _messageStreamSubscription.cancel();
    await _repositoryRoot.vaultRepository.flush();
    await _repositoryRoot.messageRepository.flush();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => Selector<HomePresenter, int>(
        selector: (_, controller) => controller.currentPage,
        builder: (context, currentPage, _) => Scaffold(
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
            onTap: (value) => context.read<HomePresenter>().gotoScreen(value),
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
        onVibrate: _serviceRoot.platformService.vibrate,
        currentPassCode: _repositoryRoot.settingsRepository.passCode,
        localAuthenticate: _serviceRoot.platformService.localAuthenticate,
        useBiometrics: _repositoryRoot.settingsRepository.hasBiometrics &&
            _repositoryRoot.settingsRepository.isBiometricsEnabled,
      );
}
