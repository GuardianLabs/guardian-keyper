import 'package:flutter/material.dart';

// import '../core/utils.dart';
import '../core/theme_data.dart';
// import '../core/widgets/common.dart';
// import '../core/widgets/icon_of.dart';
import '../dashboard/dashboard_view.dart';
import '../recovery_group/recovery_group_view.dart';
import '../recovery_group/create_group/create_group_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  static const routeName = '/';

  static const _pages = [
    DashboardView(),
    RecoveryGroupView(),
  ];

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: HomeView._pages[_page],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: clBlue,
        showSelectedLabels: false,
        unselectedItemColor: clWhite,
        currentIndex: _page,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.health_and_safety_outlined),
            label: 'Recovery Groups',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              child: Icon(Icons.add, color: clWhite),
              backgroundColor: clBlue,
            ),
            label: 'Add Recovery Group',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none_outlined),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
        onTap: (value) {
          switch (value) {
            case 0:
              setState(() => _page = 0);
              break;
            case 1:
              setState(() => _page = 1);
              // Navigator.pushNamed(context, RecoveryGroupView.routeName);
              break;
            case 2:
              Navigator.pushNamed(context, CreateGroupView.routeName);
              break;
            default:
          }
        },
      ),
    );
  }
}
