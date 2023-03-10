import 'package:flutter/widgets.dart';

import '/src/core/controller/page_controller_base.dart';

export 'package:provider/provider.dart';

class HomeController extends PageControllerBase with WidgetsBindingObserver {
  HomeController({required super.diContainer, required super.pages}) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) {
      await diContainer.boxRecoveryGroups.flush();
      await diContainer.boxMessages.flush();
    }
  }
}
