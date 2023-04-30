import 'dart:async';
import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/src/core/ui/page_presenter_base.dart';
import 'package:guardian_keyper/src/core/domain/entity/core_model.dart';

import '../domain/vault_interactor.dart';

part 'vault_secret_presenter_base.dart';
part 'vault_guardian_presenter_base.dart';

typedef Callback = void Function(MessageModel message);

abstract class VaultPresenterBase extends PagePresenterBase {
  VaultPresenterBase({required super.pages, super.currentPage});

  late final networkSubscription = _vaultInteractor.messageStream.listen(null);

  bool get isWaiting => _timer?.isActive == true;

  @override
  void dispose() {
    stopListenResponse(shouldNotify: false);
    networkSubscription.cancel();
    super.dispose();
  }

  Future<void> startNetworkRequest(void Function([Timer?]) callback) async {
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
