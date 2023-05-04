import 'dart:async';
import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/src/core/ui/page_presenter_base.dart';
import 'package:guardian_keyper/src/core/domain/entity/core_model.dart';

import '../../domain/vault_interactor.dart';

abstract class VaultPresenterBase extends PagePresenterBase {
  VaultPresenterBase({required super.pages, super.currentPage});

  final requestCompleter = Completer<MessageModel>();

  StreamSubscription<MessageModel> get networkSubscription;

  bool get isWaiting => _timer?.isActive == true;

  bool get isNotWaiting => !isWaiting;

  @override
  void dispose() {
    stopListenResponse(shouldNotify: false);
    networkSubscription.cancel();
    super.dispose();
  }

  void callback([Timer? _]);

  Future<void> startNetworkRequest() async {
    await _vaultInteractor.wakelockEnable();
    _timer = Timer.periodic(
      _vaultInteractor.requestRetryPeriod,
      callback,
    );
    callback();
    notifyListeners();
  }

  void stopListenResponse({final bool shouldNotify = true}) {
    _timer?.cancel();
    networkSubscription.onData(null);
    _vaultInteractor.wakelockDisable();
    if (shouldNotify) notifyListeners();
  }

  final _vaultInteractor = GetIt.I<VaultInteractor>();

  Timer? _timer;
}
