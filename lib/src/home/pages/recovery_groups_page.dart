import 'package:flutter/material.dart';

import '../../core/theme_data.dart';
import '../../core/widgets/common.dart';
import '../../recovery_group/recovery_group_view.dart';
import '../../guardian/guardian_view.dart';

class RecoveryGroupsPage extends StatefulWidget {
  const RecoveryGroupsPage({Key? key}) : super(key: key);

  static const _tabs = [
    RecoveryGroupView(),
    GuardianView(),
  ];

  @override
  State<RecoveryGroupsPage> createState() => _RecoveryGroupsPageState();
}

class _RecoveryGroupsPageState extends State<RecoveryGroupsPage> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          const HeaderBar(caption: 'Recovery Groups'),
          // Switcher
          Container(
            decoration: BoxDecoration(
              color: clIndigo800,
              borderRadius: borderRadius,
            ),
            height: 40,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: _currentTab == 0 ? clGreen : null,
                      borderRadius: borderRadius,
                    ),
                    child: TextButton(
                      child: const Text('OWNER'),
                      onPressed: () => setState(() => _currentTab = 0),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: _currentTab == 1 ? clYellow : null,
                      borderRadius: borderRadius,
                    ),
                    child: TextButton(
                      child: const Text('GUARDIAN'),
                      onPressed: () => setState(() => _currentTab = 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: RecoveryGroupsPage._tabs[_currentTab],
          ),
        ],
      ),
    );
  }
}
