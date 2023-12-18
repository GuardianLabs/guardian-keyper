import 'package:flutter/material.dart';

import 'package:guardian_keyper/ui/widgets/icon_of.dart';
import 'package:guardian_keyper/feature/message/ui/widgets/message_notify_icon.dart';

class BottomNavbar extends StatelessWidget {
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

  const BottomNavbar({
    required this.currentPage,
    required this.onTap,
    super.key,
  });

  final int currentPage;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) => BottomNavigationBar(
        currentIndex: currentPage,
        items: _items,
        onTap: onTap,
      );
}
