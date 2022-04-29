import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/src/core/theme_data.dart';
import '/src/guardian/guardian_controller.dart';
import '/src/recovery_group/recovery_group_controller.dart';

class DashboardGroupsWidget extends StatelessWidget {
  const DashboardGroupsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final guardian = Provider.of<GuardianController>(context);
    final recoveryGroup = Provider.of<RecoveryGroupController>(context);
    return Container(
      decoration: BoxDecoration(borderRadius: borderRadius, color: clIndigo700),
      padding: paddingAll20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Recovery Groups',
            textAlign: TextAlign.left,
            style: textStylePoppinsBold16,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: borderRadius, color: clGreen),
                  height: 40,
                  padding: paddingAll8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('OWNER', style: textStyleSourceSansProBold12),
                      Text(
                        recoveryGroup.groups.length.toString(),
                        style: textStyleSourceSansProBold20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: borderRadius, color: clYellow),
                  height: 40,
                  padding: paddingAll8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('GUARDIAN', style: textStyleSourceSansProBold12),
                      Text(
                        guardian.secretShards.length.toString(),
                        style: textStyleSourceSansProBold20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
