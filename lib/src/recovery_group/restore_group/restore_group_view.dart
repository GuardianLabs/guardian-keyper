import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../recovery_group_controller.dart';
import 'restore_group_controller.dart';

import 'pages/explainer_page.dart';
import 'pages/qr_code_page.dart';

class RestoreGroupView extends StatelessWidget {
  static const routeName = '/restore_recovery_group';
  static const _pages = [
    ExplainerPage(),
    QRCodePage(),
  ];

  const RestoreGroupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RestoreGroupController(
        pagesCount: _pages.length,
        p2pNetwork: context.read<RecoveryGroupController>().p2pNetwork.stream,
      ),
      child: Consumer<RestoreGroupController>(
        builder: (context, value, child) {
          return Scaffold(
            primary: true,
            resizeToAvoidBottomInset: false,
            body: SafeArea(child: _pages[value.currentPage]),
          );
        },
      ),
    );
  }
}
