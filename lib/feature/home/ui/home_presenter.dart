import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/data/network_manager.dart';
import 'package:guardian_keyper/ui/presenters/page_presenter_base.dart';

import 'package:guardian_keyper/feature/settings/domain/settings_interactor.dart';
import 'package:guardian_keyper/feature/message/domain/use_case/message_interactor.dart';

export 'package:provider/provider.dart';

class HomePresenter extends PagePresenterBase {
  HomePresenter({required super.pageCount});

  late final messagesSubscription = _messagesInteractor.watch().where((event) {
    if (canShowMessage) return false;
    if (event.isDeleted) return false;
    if (event.value!.isNotReceived) return false;
    return true;
  }).listen(null);

  bool canShowMessage = true;

  bool get isFirstStart => _settingsInteractor.passCode.isEmpty;

  @override
  void dispose() {
    messagesSubscription.cancel();
    super.dispose();
  }

  Future<void> start() => _networkManager.start();

  Future<void> serveStorage() => _messagesInteractor.pruneMessages();

  void gotoVaults() => gotoPage(1);

  void gotoShards() => gotoPage(2);

  // Private
  final _networkManager = GetIt.I<NetworkManager>();
  final _messagesInteractor = GetIt.I<MessageInteractor>();
  final _settingsInteractor = GetIt.I<SettingsInteractor>();
}
