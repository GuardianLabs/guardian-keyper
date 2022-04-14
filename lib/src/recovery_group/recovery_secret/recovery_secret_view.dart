import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../recovery_group_controller.dart';
import 'recovery_secret_controller.dart';

import 'pages/discovering_peers_page.dart';
import 'pages/show_secret_page.dart';

class RecoveryGroupRecoverySecretView extends StatelessWidget {
  const RecoveryGroupRecoverySecretView({
    Key? key,
    required this.recoveryGroupName,
  }) : super(key: key);

  static const routeName = '/recovery_group/recovery_secret';
  static const _pages = [
    DiscoveryPeersPage(),
    ShowSecretPage(),
  ];

  final String recoveryGroupName;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RecoverySecretController(
        pagesCount: _pages.length,
        groupName: recoveryGroupName,
        p2pNetwork: context.read<RecoveryGroupController>().p2pNetwork.stream,
      ),
      child:
          Consumer<RecoverySecretController>(builder: (context, value, child) {
        return Scaffold(
          primary: true,
          resizeToAvoidBottomInset: false,
          body: SafeArea(child: _pages[value.currentPage]),
        );
      }),
    );
  }
}
