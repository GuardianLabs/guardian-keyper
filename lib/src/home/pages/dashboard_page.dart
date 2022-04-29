import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/widgets/common.dart';
import '/src/recovery_group/widgets/recovery_group_tile_widget.dart';
import '/src/recovery_group/restore_group/restore_group_view.dart';
import '/src/recovery_group/recovery_group_controller.dart';

import '../widgets/dashboard_groups_widget.dart';
import '../widgets/my_qr_code_widget.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final groups = Provider.of<RecoveryGroupController>(context).groups;
    return ListView(
      primary: true,
      shrinkWrap: true,
      children: [
        // Header
        const HeaderBar(title: HeaderBarTitleLogo()),
        // Body
        const Padding(
          padding: paddingH20V5,
          child: DashboardGroupsWidget(),
        ),
        const Padding(
          padding: paddingH20V5,
          child: MyQRCodeWidget(),
        ),
        Padding(
          padding: paddingH20V5,
          child: ListTile(
            title: Text('Restore Group', style: textStylePoppinsBold16),
            trailing: const IconOf.restoreGroup(
                radius: 20, size: 24, bgColor: clIndigo600),
            onTap: () =>
                Navigator.of(context).pushNamed(RestoreGroupView.routeName),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 35, left: 20, bottom: 20),
          child: Text('My Recovery Groups', style: textStylePoppinsBold20),
        ),
        if (groups.isEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Container(
              decoration: boxDecoration,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 16),
                    child: IconOf.groups(radius: 20, size: 16),
                  ),
                  Padding(
                    padding: paddingBottom20,
                    child: Text(
                      'You don’t have any recovery groups',
                      style: textStyleSourceSansProRegular14,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          for (final group in groups.values)
            Padding(
                padding: paddingH20V1,
                child: RecoveryGroupTileWidget(group: group)),
      ],
    );
  }
}
