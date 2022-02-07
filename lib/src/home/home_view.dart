import 'package:flutter/material.dart';

import '../widgets/common.dart';
import '../widgets/icon_of.dart';
import '../intro/intro_view.dart';
import '../wallet/wallet_select_view.dart';
import '../recovery_group/recovery_group_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  static const routeName = '/';
  static const _paddingV5 = EdgeInsets.only(top: 5, bottom: 5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        primary: true,
        body: Column(
          children: [
            // Header
            const HeaderBar(
              title: HeaderBarTitleLogo(),
              backButton: HeaderBarBackButton(),
              closeButton: HeaderBarCloseButton(),
            ),
            Expanded(
              child: ListView(
                restorationId: 'homeListView',
                padding: const EdgeInsets.all(20),
                children: [
                  Padding(
                    padding: _paddingV5,
                    child: ListTile(
                      title: const Text('Intro'),
                      trailing: const IconOf.app(),
                      onTap: () =>
                          Navigator.pushNamed(context, IntroView.routeName),
                    ),
                  ),
                  Padding(
                    padding: _paddingV5,
                    child: ListTile(
                      title: const Text('Connect wallet'),
                      trailing: const IconOf.connect(),
                      onTap: () => Navigator.pushNamed(
                          context, WalletSelectView.routeName),
                    ),
                  ),
                  Padding(
                    padding: _paddingV5,
                    child: ListTile(
                      title: const Text('Create recovery group'),
                      trailing: const IconOf.app(),
                      onTap: () => Navigator.pushNamed(
                          context, RecoveryGroupView.routeName),
                    ),
                  ),
                ],
              ),
            ),
            // Footer
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: FooterButton(text: 'Do nothing', onPressed: () {}),
            ),
            Container(height: 50),
          ],
        ));
  }
}
