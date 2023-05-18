import 'package:double_back_to_close_app/double_back_to_close_app.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/utils/utils.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';

import 'package:guardian_keyper/feature/dashboard/ui/dashboard_screen.dart';
import 'package:guardian_keyper/feature/auth/ui/dialogs/on_demand_auth_dialog.dart';
import 'package:guardian_keyper/feature/vault/ui/_shard_home/shard_home_screen.dart';
import 'package:guardian_keyper/feature/vault/ui/_vault_home/vault_home_screen.dart';
import 'package:guardian_keyper/feature/message/ui/dialogs/on_message_active_dialog.dart';
import 'package:guardian_keyper/feature/message/ui/widgets/message_notify_icon.dart';
import 'package:guardian_keyper/feature/message/ui/message_home_screen.dart';

import 'home_presenter.dart';

class HomeScreen extends StatefulWidget {
  static const _pages = [
    DashboardScreen(),
    VaultHomeScreen(),
    ShardHomeScreen(),
    MessageHomeScreen(),
  ];

  static const _items = [
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
      icon: MessageNotifyIcon(isSelected: false),
      activeIcon: MessageNotifyIcon(isSelected: true),
      label: 'Messages',
    ),
  ];

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late final _presenter = context.read<HomePresenter>();

  @override
  void initState() {
    super.initState();

    _presenter.messagesSubscription.onData((event) {
      final routeName = ModalRoute.of(context)?.settings.name;
      if (routeName == '/' || routeName == routeQrCodeShow) {
        _presenter.canShowMessage = false;
        Navigator.of(context).popUntil((r) => r.isFirst);
        OnMessageActiveDialog.show(context, message: event.value!)
            .then((_) => _presenter.canShowMessage = true);
      }
    });

    Future.microtask(() async {
      if (_presenter.isFirstStart) {
        await Navigator.of(context).pushNamed(routeIntro);
      } else {
        _presenter.serveStorage();
        await OnDemandAuthDialog.show(context);
      }
      await _presenter.start();
    });
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        key: const Key('HomePresenter'),
        create: (_) => HomePresenter(pageCount: HomeScreen._pages.length),
        child: Selector<HomePresenter, int>(
          selector: (_, presenter) => presenter.currentPage,
          builder: (context, currentPage, __) => Scaffold(
            backgroundColor: clIndigo900,
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: currentPage,
              items: HomeScreen._items,
              onTap: (page) => context.read<HomePresenter>().gotoPage(page),
            ),
            body: DoubleBackToCloseApp(
              snackBar: buildSnackBar(text: 'Tap back again to exit'),
              child: SafeArea(
                child: Padding(
                  padding: paddingH20,
                  child: HomeScreen._pages[currentPage],
                ),
              ),
            ),
          ),
        ),
      );
}
