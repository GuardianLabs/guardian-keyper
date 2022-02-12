import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../core/utils.dart';
import '../theme_data.dart';
import '../widgets/common.dart';
import '../widgets/icon_of.dart';

import '../recovery_group/recovery_group_view.dart';
import '../recovery_group/create_group/create_group_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  static const routeName = '/';
  static const _paddingV5 = EdgeInsets.only(top: 5, bottom: 5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const HeaderBar(title: HeaderBarTitleLogo()),
          Expanded(
            child: ListView(
              restorationId: 'homeListView',
              padding: const EdgeInsets.all(20),
              children: [
                Padding(
                  padding: _paddingV5,
                  child: ListTile(
                    title: const Text('Show QR code'),
                    trailing: const IconOf.app(),
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        alignment: Alignment.center,
                        backgroundColor: Colors.white,
                        content: SizedBox(
                          height: 200,
                          width: 200,
                          child: QrImage(data: getRandomString()),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: clBlue,
        showSelectedLabels: false,
        unselectedItemColor: clWhite,
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
            case 1:
              Navigator.pushNamed(context, RecoveryGroupView.routeName);
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
