import 'package:flutter/widgets.dart';

import '/src/core/model/core_model.dart';
import '/src/core/controller/page_controller_base.dart';

export 'package:provider/provider.dart';

class HomeController extends PageControllerBase with WidgetsBindingObserver {
  HomeController({required super.pages}) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state != AppLifecycleState.resumed) {
      await GetIt.I<Box<MessageModel>>().flush();
      await GetIt.I<Box<RecoveryGroupModel>>().flush();
    }
  }
}
