import 'package:double_back_to_close_app/double_back_to_close_app.dart';

import 'package:guardian_keyper/ui/utils.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';
import 'package:guardian_keyper/feature/vault/ui/_shard_home/shard_home_screen.dart';
import 'package:guardian_keyper/feature/vault/ui/_vault_home/vault_home_screen.dart';
import 'package:guardian_keyper/feature/message/ui/message_home_screen.dart';

import 'home_presenter.dart';
import '../../dashboard/dashboard_screen.dart';
import 'widgets/notification_icon.dart';

class HomeScreen extends StatelessWidget {
  static const _pages = [
    DashboardScreen(),
    VaultHomeScreen(),
    ShardHomeScreen(),
    MessageHomeScreen(),
  ];

  const HomeScreen({super.key});

  @override
  Widget build(final BuildContext context) => ChangeNotifierProvider(
        create: (final BuildContext context) => HomePresenter(
          context: context,
          pages: HomeScreen._pages,
        ),
        child: Selector<HomePresenter, int>(
          selector: (_, presenter) => presenter.currentPage,
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
                  child: _pages[currentPage],
                ),
              ),
            ),
          ),
        ),
      );
}
