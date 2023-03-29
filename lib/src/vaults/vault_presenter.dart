import 'dart:async';

import '/src/core/service/service_root.dart';
import '/src/core/data/repository_root.dart';
import '/src/core/ui/page_presenter_base.dart';

part 'vault_secret_presenter.dart';
part 'vault_guardian_presenter.dart';

typedef Callback = void Function(MessageModel message);

abstract class VaultPresenterBase extends PagePresenterBase {
  final serviceRoot = GetIt.I<ServiceRoot>();
  final repositoryRoot = GetIt.I<RepositoryRoot>();

  late final myPeerId = serviceRoot.networkService.myPeerId.copyWith(
    name: repositoryRoot.settingsRepository.deviceName,
  );
  late final networkSubscription =
      serviceRoot.networkService.messageStream.listen(null);

  Timer? timer;

  VaultPresenterBase({required super.pages, super.currentPage});

  bool get isWaiting => timer?.isActive == true;

  @override
  void dispose() {
    timer?.cancel();
    networkSubscription.cancel();
    serviceRoot.platformService.wakelockDisable();
    super.dispose();
  }

  void stopListenResponse() {
    timer?.cancel();
    serviceRoot.platformService.wakelockDisable();
    notifyListeners();
  }

  void startNetworkRequest(void Function([Timer?]) callback) async {
    await serviceRoot.platformService.wakelockEnable();
    timer = Timer.periodic(
      serviceRoot.networkService.messageTTL,
      callback,
    );
    callback();
    notifyListeners();
  }

  Future<void> sendToGuardian(final MessageModel message) =>
      serviceRoot.networkService.sendTo(
        isConfirmable: false,
        peerId: message.peerId,
        message: message.copyWith(peerId: myPeerId),
      );

  VaultModel? getVaultById(final VaultId groupId) =>
      repositoryRoot.vaultRepository.get(groupId.asKey);

  Future<VaultModel> createGroup(final VaultModel group) async {
    await repositoryRoot.vaultRepository.put(group.aKey, group);
    notifyListeners();
    return group;
  }

  Future<VaultModel> addGuardian(
    final VaultId vaultId,
    final PeerId guardian,
  ) async {
    var vault = repositoryRoot.vaultRepository.get(vaultId.asKey)!;
    vault = vault.copyWith(
      guardians: {...vault.guardians, guardian: ''},
    );
    await repositoryRoot.vaultRepository.put(vaultId.asKey, vault);
    return vault;
  }
}
