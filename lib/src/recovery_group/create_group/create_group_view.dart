import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'create_group_controller.dart';
import 'pages/choose_type_page.dart';
import 'pages/input_name_page.dart';

class CreateGroupView extends StatelessWidget {
  const CreateGroupView({Key? key}) : super(key: key);

  static const routeName = '/recovery_group_create';
  static const _pages = [
    ChooseTypePage(),
    InputNamePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CreateGroupController(pagesCount: _pages.length),
      child: Consumer<CreateGroupController>(
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
