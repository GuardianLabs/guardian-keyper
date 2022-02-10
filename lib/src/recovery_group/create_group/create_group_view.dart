import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'create_group_controller.dart';
import 'pages/choose_type_page.dart';
import 'pages/input_name_page.dart';

class CreateGroupView extends StatelessWidget {
  const CreateGroupView({Key? key}) : super(key: key);

  static const routeName = '/recovery_group_create';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CreateGroupController(lastScreen: 1),
      child: Consumer<CreateGroupController>(
        builder: (context, value, child) {
          switch (value.currentScreen) {
            case 0:
              return const Scaffold(body: ChooseTypePage());
            case 1:
              return const Scaffold(
                resizeToAvoidBottomInset: false,
                body: InputNamePage(),
              );
          }
          return const Scaffold(); // Dumb
        },
      ),
    );
  }
}
