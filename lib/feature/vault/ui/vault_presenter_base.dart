import 'dart:async';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/presenters/page_presenter_base.dart';

import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';
import 'package:guardian_keyper/feature/vault/domain/use_case/vault_interactor.dart';

abstract base class VaultPresenterBase extends PagePresentererBase {
  VaultPresenterBase({
    required super.stepsCount,
    super.initialPage,
  });

  final requestCompleter = Completer<MessageModel>();

  final _vaultInteractor = GetIt.I<VaultInteractor>();

  late final _networkSubscription =
      _vaultInteractor.messageStream.listen(responseHandler);

  Timer? _timer;

  bool get isWaiting => _timer?.isActive ?? false;

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
      retryNetworkTimeout,
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
}
