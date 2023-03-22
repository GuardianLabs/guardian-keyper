import 'package:double_back_to_close_app/double_back_to_close_app.dart';

import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

import '../app_helper.dart';
import 'home_presenter.dart';
import 'shards_page.dart';
import 'vaults_page.dart';
import 'messages_page.dart';
import 'dashboard_page.dart';
import 'widgets/notification_icon.dart';

class HomeScreen extends StatelessWidget {
  static const pages = [
    DashboardPage(),
    VaultsPage(),
    ShardsPage(),
    MessagesPage(),
  ];

  const HomeScreen({super.key});

  @override
  Widget build(final BuildContext context) => AppHelper(
        child: ChangeNotifierProvider(
          create: (_) => HomePresenter(pages: HomeScreen.pages),
          child: Selector<HomePresenter, int>(
            selector: (_, controller) => controller.currentPage,
            builder: (context, currentPage, _) => Scaffold(
              key: Key('Home.Page.$currentPage'),
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
                onTap: (value) =>
                    context.read<HomePresenter>().gotoScreen(value),
              ),
              body: DoubleBackToCloseApp(
                snackBar: const SnackBar(
                  content: Text('Tap back again to exit'),
                ),
                child: SafeArea(child: HomeScreen.pages[currentPage]),
              ),
            ),
          ),
        ),
      );
}
