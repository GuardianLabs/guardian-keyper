import 'dart:async';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

import '/src/core/di_container.dart';
import '/src/core/model/core_model.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

import '/src/guardian/pages/message_page.dart';
import '/src/guardian/widgets/message_list_tile.dart';

import 'home_controller.dart';
import 'pages/dashboard_page.dart';
import 'pages/shards_page.dart';
import 'pages/vaults_page.dart';
import 'widgets/notification_icon.dart';

class HomeView extends StatefulWidget {
  static const routeName = '/home';
  static const _pages = [
    DashboardPage(),
    VaultsPage(),
    ShardsPage(),
    MessagesPage(),
  ];

  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  late final StreamSubscription<BoxEvent> _subscription;
  bool _hasModal = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final diContainer = context.read<DIContainer>();
    Future.microtask(
      () => diContainer.authService.checkPassCode(
        context: context,
        onUnlock: () {
          Navigator.of(context).pop();
          diContainer.networkService.start();
        },
        canCancel: false,
      ),
    );
    _subscription = diContainer.boxMessages.watch().listen(
      (event) {
        if (_hasModal) return;
        if (event.deleted) return;
        final message = event.value as MessageModel;
        if (!message.isReceived) return;
        _hasModal = true;
        // Give QrCodePage time to pop itself
        Future.microtask(
          () async {
            _hasModal = false;
            await MessageListTile.showActiveMessage(context, message);
          },
        );
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) {
      final diContainer = context.read<DIContainer>();
      await diContainer.boxSettings.flush();
      await diContainer.boxRecoveryGroups.flush();
      await diContainer.boxMessages.flush();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => HomeController(
          pages: HomeView._pages,
          diContainer: context.read<DIContainer>(),
        ),
        child: Selector<HomeController, int>(
          selector: (_, controller) => controller.currentPage,
          builder: (context, currentPage, __) => ScaffoldWidget(
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
              onTap: (value) =>
                  context.read<HomeController>().gotoScreen(value),
            ),
            child: DoubleBackToCloseApp(
              snackBar: const SnackBar(content: Text('Tap back again to exit')),
              child: HomeView._pages[currentPage],
            ),
          ),
        ),
      );
}
