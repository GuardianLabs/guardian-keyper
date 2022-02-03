import 'package:flutter/material.dart';

import 'view/intro_page1_view.dart';
import 'view/intro_page2_view.dart';

class IntroView extends StatefulWidget {
  const IntroView({Key? key}) : super(key: key);

  static const routeName = '/intro';

  @override
  State<IntroView> createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {
  int _step = 0;

  @override
  Widget build(BuildContext context) {
    Widget? body;
    switch (_step) {
      case 0:
        body = IntroPage1View(onPressed: () => setState(() => _step++));
        break;
      case 1:
        body = IntroPage2View(onPressed: () => Navigator.pop(context));
        break;
    }
    return Scaffold(
      primary: true,
      restorationId: 'intro',
      body: body,
    );
  }
}
