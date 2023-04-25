import 'dart:async';
import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/src/core/ui/page_presenter_base.dart';
import 'package:guardian_keyper/src/core/domain/entity/core_model.dart';

import '../domain/vault_interactor.dart';

part 'vault_secret_presenter_base.dart';
part 'vault_guardian_presenter_base.dart';

typedef Callback = void Function(MessageModel message);

abstract class VaultPresenterBase extends PagePresenterBase {
  late final getVaultById = _vaultInteractor.getVaultById;

  late final sendToGuardian = _vaultInteractor.sendToGuardian;

  late final networkSubscription = _vaultInteractor.messageStream.listen(null);

  late final logStartCreateVault = _vaultInteractor.logStartCreateVault;
  late final logFinishCreateVault = _vaultInteractor.logFinishCreateVault;

  late final logStartRestoreVault = _vaultInteractor.logStartRestoreVault;
  late final logFinishRestoreVault = _vaultInteractor.logFinishRestoreVault;

  Timer? timer;

  VaultPresenterBase({required super.pages, super.currentPage});

  bool get isWaiting => timer?.isActive == true;

  PeerId get myPeerId => _vaultInteractor.selfId;

  @override
  void dispose() {
    stopListenResponse(shouldNotify: false);
    networkSubscription.cancel();
    super.dispose();
  }

  void stopListenResponse({final bool shouldNotify = true}) {
    timer?.cancel();
    networkSubscription.onData(null);
    _vaultInteractor.wakelockDisable();
    if (shouldNotify) notifyListeners();
  }

  void startNetworkRequest(void Function([Timer?]) callback) async {
    await _vaultInteractor.wakelockEnable();
    timer = Timer.periodic(
      _vaultInteractor.requestRetryPeriod,
      callback,
    );
    callback();
    notifyListeners();
  }

  Future<VaultModel> createGroup(final VaultModel vault) async {
    final newVault = await _vaultInteractor.createGroup(vault);
    notifyListeners();
    return newVault;
  }

  final _vaultInteractor = GetIt.I<VaultInteractor>();
}
