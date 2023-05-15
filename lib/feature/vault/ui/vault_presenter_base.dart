import 'dart:async';
import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/ui/page_presenter_base.dart';
import 'package:guardian_keyper/domain/entity/message_model.dart';

import '../domain/vault_interactor.dart';

abstract class VaultPresenterBase extends PagePresenterBase {
  VaultPresenterBase({
    required super.pages,
    super.currentPage,
  });

  final requestCompleter = Completer<MessageModel>();

  bool get isWaiting => _timer?.isActive == true;

  bool get isNotWaiting => !isWaiting;

  @override
  void dispose() {
    stopListenResponse(shouldNotify: false);
    super.dispose();
  }

  void requestWorker([Timer? timer]);

  void responseHandler(MessageModel message);

  Future<MessageModel> startRequest() async {
    _networkSubscription.resume();
    await _vaultInteractor.wakelockEnable();
    _timer = Timer.periodic(
      _vaultInteractor.requestRetryPeriod,
      requestWorker,
    );
    requestWorker();
    notifyListeners();
    return requestCompleter.future;
  }

  void stopListenResponse({bool shouldNotify = true}) {
    _timer?.cancel();
    _networkSubscription.cancel();
    _vaultInteractor.wakelockDisable();
    if (shouldNotify) notifyListeners();
  }

  // Private
  final _vaultInteractor = GetIt.I<VaultInteractor>();

  late final _networkSubscription =
      _vaultInteractor.messageStream.listen(responseHandler);

  Timer? _timer;
}
