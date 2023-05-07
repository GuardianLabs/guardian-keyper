import 'package:double_back_to_close_app/double_back_to_close_app.dart';

import 'package:guardian_keyper/src/core/ui/utils.dart';
import 'package:guardian_keyper/src/core/ui/widgets/common.dart';
import 'package:guardian_keyper/src/core/ui/widgets/icon_of.dart';
import 'package:guardian_keyper/src/vaults/ui/_dashboard/pages/shards_page.dart';
import 'package:guardian_keyper/src/vaults/ui/_dashboard/pages/vaults_page.dart';
import 'package:guardian_keyper/src/message/ui/_dashboard/pages/messages_page.dart';

import 'presenters/home_presenter.dart';
import 'pages/dashboard_page.dart';
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
  Widget build(final BuildContext context) => ChangeNotifierProvider(
        create: (final BuildContext context) => HomePresenter(
          context: context,
          pages: HomeScreen.pages,
        ),
        child: Selector<HomePresenter, int>(
          selector: (
            final BuildContext context,
            final HomePresenter presenter,
          ) =>
              presenter.currentPage,
          builder: (
            final BuildContext context,
            final int currentPage,
            final Widget? widget,
          ) =>
              Scaffold(
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
                  icon: MessagesIcon(isSelected: false),
                  activeIcon: MessagesIcon(isSelected: true),
                  label: 'Messages',
                ),
              ],
              onTap: (value) => context.read<HomePresenter>().gotoPage(value),
            ),
            body: DoubleBackToCloseApp(
              snackBar: buildSnackBar(text: 'Tap back again to exit'),
              child: SafeArea(
                child: Padding(
                  padding: paddingH20,
                  child: pages[currentPage],
                ),
              ),
            ),
          ),
        ),
      );
}
