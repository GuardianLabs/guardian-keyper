import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/add_secret_page.dart';
import 'pages/split_and_share_page.dart';
import 'pages/secret_transmitting_page.dart';

import 'add_secret_controller.dart';

class RecoveryGroupAddSecretView extends StatelessWidget {
  const RecoveryGroupAddSecretView({
    Key? key,
    required this.recoveryGroupName,
  }) : super(key: key);

  static const routeName = '/recovery_group_add_secret';
  static const _pages = [
    AddSecretPage(),
    SplitAndShareSecretPage(),
    SecretTransmittingPage(),
  ];

  final String recoveryGroupName;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddSecretController(
        pagesCount: _pages.length,
        groupName: recoveryGroupName,
      ),
      child: Consumer<AddSecretController>(
          builder: (context, value, child) => _pages[value.currentPage]),
    );
  }
}
