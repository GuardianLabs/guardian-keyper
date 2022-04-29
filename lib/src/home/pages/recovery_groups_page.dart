import 'package:flutter/material.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/recovery_group/recovery_group_view.dart';
import '/src/guardian/guardian_view.dart';

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
      padding: paddingH20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          const HeaderBar(caption: 'Recovery Groups'),
          // Switcher
          Container(
            decoration:
                BoxDecoration(color: clIndigo800, borderRadius: borderRadius),
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
                      child: Text('OWNER', style: textStyleSourceSansProBold12),
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
                      child:
                          Text('GUARDIAN', style: textStyleSourceSansProBold12),
                      onPressed: () => setState(() => _currentTab = 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 40,
            color: Theme.of(context).colorScheme.background,
          ),
          // Body
          Expanded(child: RecoveryGroupsPage._tabs[_currentTab]),
        ],
      ),
    );
  }
}
