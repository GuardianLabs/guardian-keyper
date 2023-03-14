import 'package:double_back_to_close_app/double_back_to_close_app.dart';

import '/src/core/consts.dart';
import '/src/core/model/core_model.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

import '/src/guardian/pages/message_page.dart';
import '/src/guardian/widgets/message_list_tile.dart';
import '/src/core/service/p2p_network_service.dart';

import 'home_controller.dart';
import 'pages/dashboard_page.dart';
import 'pages/shards_page.dart';
import 'pages/vaults_page.dart';
import 'widgets/notification_icon.dart';

class HomeView extends StatefulWidget {
  static const routeName = routeHome;

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

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    GetIt.I<Box<MessageModel>>().watch().listen(
      (event) async {
        if (ModalRoute.of(context)?.isCurrent != true) return;
        if (event.deleted) return;
        final message = event.value as MessageModel;
        if (message.isNotReceived) return;
        await MessageListTile.showActiveMessage(context, message);
      },
    );
    GetIt.I<P2PNetworkService>().start();
  }

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
        create: (final BuildContext context) => HomeController(
          pages: HomeView._pages,
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
