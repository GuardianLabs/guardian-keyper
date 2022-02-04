import 'package:flutter/material.dart';

import '../widgets/common.dart';
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
                    child: ListTileButton(
                      text: 'Intro',
                      trailing: 'assets/images/logo.png',
                      onPressed: () =>
                          Navigator.pushNamed(context, IntroView.routeName),
                    ),
                  ),
                  Padding(
                    padding: _paddingV5,
                    child: ListTileButton(
                      text: 'Connect wallet',
                      trailing: 'assets/images/icon_connect.png',
                      onPressed: () => Navigator.pushNamed(
                          context, WalletSelectView.routeName),
                    ),
                  ),
                  Padding(
                    padding: _paddingV5,
                    child: ListTileButton(
                      text: 'Create recovery group',
                      trailing: 'assets/images/logo.png',
                      onPressed: () => Navigator.pushNamed(
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
