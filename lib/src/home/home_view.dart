import 'dart:async';

import '/src/core/di_container.dart';
import '/src/core/model/core_model.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

import '/src/guardian/pages/message_page.dart';
import '/src/guardian/pages/managed_secrets_page.dart';
import '/src/guardian/widgets/message_list_tile_widget.dart';
import '/src/guardian/widgets/notification_icon_widget.dart';
import '/src/recovery_group/pages/managed_groups_page.dart';

import 'home_controller.dart';
import 'pages/dashboard_page.dart';

class HomeView extends StatefulWidget {
  static const routeName = '/home';
  static const pages = [
    DashboardPage(),
    ManagedGroupsPage(),
    ManagedSecretsPage(),
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
  late final StreamSubscription<NewMessageProcessedEvent> _subscription;
  bool _hasModal = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _subscription = context
        .read<DIContainer>()
        .eventBus
        .on<NewMessageProcessedEvent>()
        .listen((NewMessageProcessedEvent event) {
      if (_hasModal || !event.message.isProcessed) return;
      _hasModal = true;
      MessageListTile.showActiveMessage(context, event.message)
          .then((_) => _hasModal = false);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) {
      final diContainer = context.read<DIContainer>();
      await diContainer.boxSettings.flush();
      await diContainer.boxSecretShards.flush();
      await diContainer.boxRecoveryGroup.flush();
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
                  label: 'My secrets',
                ),
                BottomNavigationBarItem(
                  icon: IconOf.navBarShield(),
                  activeIcon: IconOf.navBarShieldSelected(),
                  label: 'Shards',
                ),
                BottomNavigationBarItem(
                  icon: NotificationIconWidget(),
                  activeIcon: NotificationIconWidget.selected(),
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
