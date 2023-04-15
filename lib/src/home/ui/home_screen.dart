import 'dart:async';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

import '/src/core/app/consts.dart';
import '/src/core/ui/widgets/common.dart';
import '/src/core/ui/widgets/icon_of.dart';

import '/src/message/domain/message_model.dart';
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

class _HomeScreenState extends State<HomeScreen> {
  late final _presenter = context.read<HomePresenter>();

  @override
  void initState() {
    super.initState();
    _presenter.onMessage((final event) {
      if (_presenter.canNotShowMessage) return;
      if (event.deleted) return;
      final message = event.value as MessageModel;
      if (message.isNotReceived) return;
      final routeName = ModalRoute.of(context)?.settings.name;
      if (routeName == '/' || routeName == routeShowQrCode) {
        _presenter.canShowMessage = false;
        Navigator.of(context).popUntil((r) => r.isFirst);
        MessageActionBottomSheet.show(context, message)
            .then((_) => _presenter.canShowMessage = true);
      }
    });

    Future.microtask(() async {
      if (_presenter.isFirstStart) {
        await Navigator.of(context).pushNamed(routeIntro);
      } else {
        await _presenter.demandPassCode(context);
      }
      _presenter.canShowMessage = true;
      await _presenter.start();
    });
  }

  @override
  Widget build(final BuildContext context) => Selector<HomePresenter, int>(
        selector: (_, presenter) => presenter.currentPage,
        builder: (_, final currentPage, __) => Scaffold(
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
            onTap: (value) => _presenter.gotoScreen(value),
          ),
          body: DoubleBackToCloseApp(
            snackBar: const SnackBar(
              content: Text('Tap back again to exit'),
            ),
            child: SafeArea(child: HomeScreen.pages[currentPage]),
          ),
        ),
      );
}
