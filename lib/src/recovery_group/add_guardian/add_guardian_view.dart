import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../recovery_group_model.dart';
import 'add_guardian_controller.dart';
import 'pages/add_guardian_page.dart';
import 'pages/scan_qrcode_page.dart';
import 'pages/loading_page.dart';
import 'pages/add_tag_page.dart';
import 'pages/guardian_added_page.dart';

class AddGuardianView extends StatelessWidget {
  // const AddGuardianView({Key? key, required this.group}) : super(key: key);
  AddGuardianView({required this.group});

  static const routeName = '/recovery_group_add_guardian';

  final RecoveryGroupModel group;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddGuardianController(lastScreen: 4, group: group),
      child: Consumer<AddGuardianController>(
        builder: (context, value, child) {
          switch (value.currentScreen) {
            case 0:
              return const Scaffold(body: AddGuardianPage());
            case 1:
              return const Scaffold(body: ScanQRCodePage());
            case 2:
              return const Scaffold(body: LoadingPage());
            case 3:
              return const Scaffold(
                  resizeToAvoidBottomInset: false, body: AddTagPage());
            case 4:
              return const Scaffold(body: GuardianAddedPage());
          }
          return const Scaffold(); // Dumb
        },
      ),
    );
  }
}
