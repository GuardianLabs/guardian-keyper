import 'package:flutter/material.dart';

import '/src/core/theme_data.dart';
import '/src/guardian/pages/managed_secrets_page.dart';
import '/src/guardian/widgets/guardian_dashboard_button_widget.dart';
import '/src/recovery_group/pages/managed_groups_page.dart';
import '/src/recovery_group/widgets/recovery_group_dashboard_button_widget.dart';

import '../home_controller.dart';
import '../home_view.dart';

class DashboardGroupsWidget extends StatelessWidget {
  const DashboardGroupsWidget({super.key});

  @override
  Widget build(BuildContext context) => Container(
        decoration: boxDecoration,
        padding: paddingAll20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: paddingBottom12,
              child: Text(
                'Recovery Groups',
                textAlign: TextAlign.left,
                style: textStylePoppins616,
              ),
            ),
            Padding(
              padding: paddingBottom20,
              child: Text(
                'Create a Recovery Group to secure your secret with the help of your Guardians.',
                textAlign: TextAlign.left,
                style: textStyleSourceSansPro416.copyWith(color: clPurpleLight),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () => context
                      .read<HomeController>()
                      .gotoScreen(HomeView.getPageNumber<ManagedGroupsPage>()),
                  child: const RecoveryGroupDashboardButtonWidget(),
                )),
                const SizedBox(width: 10),
                Expanded(
                    child: GestureDetector(
                  onTap: () => context
                      .read<HomeController>()
                      .gotoScreen(HomeView.getPageNumber<ManagedSecretsPage>()),
                  child: const GuardianDashboardButtonWidget(),
                )),
              ],
            ),
          ],
        ),
      );
}
