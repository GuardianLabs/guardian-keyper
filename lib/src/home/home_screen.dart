import 'package:double_back_to_close_app/double_back_to_close_app.dart';

import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

import '/src/guardian/pages/message_page.dart';

import 'home_presenter.dart';
import 'widgets/locker.dart';
import 'widgets/notification_icon.dart';
import 'pages/dashboard_page.dart';
import 'pages/shards_page.dart';
import 'pages/vaults_page.dart';

class HomeScreen extends StatelessWidget {
  static const pages = [
    DashboardPage(),
    VaultsPage(),
    ShardsPage(),
    MessagesPage(),
  ];

  const HomeScreen({super.key});

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
        create: (_) => HomePresenter(pages: HomeScreen.pages),
        child: Selector<HomePresenter, int>(
          selector: (context, controller) => controller.currentPage,
          builder: (context, currentPage, lockerWidget) => Stack(
            children: [
              lockerWidget!,
              ScaffoldWidget(
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
                      context.read<HomePresenter>().gotoScreen(value),
                ),
                child: DoubleBackToCloseApp(
                  snackBar: const SnackBar(
                    content: Text('Tap back again to exit'),
                  ),
                  child: HomeScreen.pages[currentPage],
                ),
              ),
            ],
          ),
          child: const Locker(),
        ),
      );
}
