import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_guardian_controller.dart';
import 'pages/add_guardian_page.dart';
import 'pages/scan_qrcode_page.dart';
import 'pages/loading_page.dart';
import 'pages/add_tag_page.dart';
import 'pages/guardian_added_page.dart';

class AddGuardianView extends StatelessWidget {
  const AddGuardianView({
    Key? key,
    this.showLastPage = false,
    required this.groupName,
  }) : super(key: key);

  const AddGuardianView.showLastPage({
    Key? key,
    this.showLastPage = true,
    required this.groupName,
  }) : super(key: key);

  static const routeName = '/recovery_group_add_guardian';
  static const _pages = [
    AddGuardianPage(),
    ScanQRCodePage(),
    LoadingPage(),
    AddTagPage(),
    GuardianAddedPage(),
  ];

  final bool showLastPage;
  final String groupName;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddGuardianController(
        lastPage: _pages.length - 1,
        groupName: groupName,
        showLastPage: showLastPage,
      ),
      child: Consumer<AddGuardianController>(
        builder: (context, value, child) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: _pages[value.currentPage],
          );
        },
      ),
    );
  }
}
