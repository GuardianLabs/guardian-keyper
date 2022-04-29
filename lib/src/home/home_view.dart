import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/settings/settings_view.dart';
import '/src/recovery_group/create_group/create_group_view.dart';
import '/src/recovery_group/recovery_group_controller.dart';
// import '/src/settings/settings_controller.dart';

import 'pages/dashboard_page.dart';
import 'pages/recovery_groups_page.dart';
import 'pages/notifications_page.dart';
// import 'pages/login_page.dart';

class HomeView extends StatefulWidget {
  static const routeName = '/';
  static const pages = [
    DashboardPage(),
    RecoveryGroupsPage(),
    null,
    NotificationsPage(),
    SettingsView(),
  ];

  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final settingsController = Provider.of<SettingsController>(context);
    // if (settingsController.isLocked) return const LoginPage();

    final groupController = Provider.of<RecoveryGroupController>(context);
    groupController.runtimeType;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: HomeView.pages[_page],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: clBlue,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedItemColor: clWhite,
        currentIndex: _page,
        items: [
          BottomNavigationBarItem(
            icon: IconOf.bottomHome(
              size: 22,
              color: _page == 0 ? clBlue : clWhite,
              bgColor: theme.colorScheme.background,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: IconOf.bottomShield(
              size: 22,
              color: _page == 1 ? clBlue : clWhite,
              bgColor: theme.colorScheme.background,
            ),
            label: 'Recovery Groups',
          ),
          BottomNavigationBarItem(
            icon: Container(
              height: 40,
              width: 40,
              child: const Icon(Icons.add, color: clWhite),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF7BE7FF), Color(0xFF3AABF0)],
                ),
                shape: BoxShape.circle,
              ),
            ),
            label: 'Add Recovery Group',
          ),
          BottomNavigationBarItem(
            icon: IconOf.bottomBell(
              size: 22,
              color: _page == 3 ? clBlue : clWhite,
              bgColor: theme.colorScheme.background,
            ),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: IconOf.bottomSettings(
              size: 22,
              color: _page == 4 ? clBlue : clWhite,
              bgColor: theme.colorScheme.background,
            ),
            label: 'Settings',
          ),
        ],
        onTap: (value) {
          if (value == 2) {
            Navigator.pushNamed(context, CreateGroupView.routeName);
          } else {
            setState(() => _page = value);
          }
        },
      ),
    );
  }
}
