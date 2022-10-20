import 'dart:async';

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
  static const pages = [
    DashboardPage(),
    VaultsPage(),
    ShardsPage(),
    MessagesPage(),
  ];

  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();

  static int getPageNumber<T>() {
    for (var i = 0; i < pages.length; i++) {
      if (pages[i] is T) return i;
    }
    return 0;
  }
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  late final StreamSubscription<BoxEvent> _subscription;
  bool _hasModal = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _subscription = context.read<DIContainer>().boxMessages.watch().listen(
      (event) async {
        if (_hasModal) return;
        if (event.deleted) return;
        final message = event.value as MessageModel;
        if (!message.isReceived) return;
        _hasModal = true;
        await Future.microtask(
          () => MessageListTile.showActiveMessage(context, message),
        ); // Give QrCodePage time to pop itself
        _hasModal = false;
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
          pagesCount: HomeView.pages.length,
          diContainer: context.read<DIContainer>(),
        ),
        child: Consumer<HomeController>(
          builder: (_, controller, __) => ScaffoldWidget(
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: controller.currentPage,
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
              onTap: (value) => controller.gotoScreen(value),
            ),
            child: HomeView.pages[controller.currentPage],
          ),
        ),
      );
}
