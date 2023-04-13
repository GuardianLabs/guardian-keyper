import 'dart:async';
import 'package:get_it/get_it.dart';

import '/src/core/data/platform_manager.dart';
import '/src/core/ui/page_presenter_base.dart';
import '/src/core/service/network/network_service.dart';
import '/src/core/infrastructure/analytics_service.dart';
import '/src/settings/data/settings_repository.dart';
import '/src/message/data/message_repository.dart';
import '/src/vaults/data/vault_repository.dart';

part 'vault_secret_presenter.dart';
part 'vault_guardian_presenter.dart';

typedef Callback = void Function(MessageModel message);

abstract class VaultPresenterBase extends PagePresenterBase {
  final networkService = GetIt.I<NetworkService>();
  final platformManager = GetIt.I<PlatformManager>();
  final analyticsService = GetIt.I<AnalyticsService>();
  final settingsRepository = GetIt.I<SettingsRepository>();
  final messageRepository = GetIt.I<MessageRepository>();
  final vaultRepository = GetIt.I<VaultRepository>();

  late final myPeerId = networkService.myPeerId.copyWith(
    name: settingsRepository.settings.deviceName,
  );
  late final networkSubscription = networkService.messageStream.listen(null);

  Timer? timer;

  VaultPresenterBase({required super.pages, super.currentPage});

  bool get isWaiting => timer?.isActive == true;

  @override
  void dispose() {
    timer?.cancel();
    networkSubscription.cancel();
    platformManager.wakelockDisable();
    super.dispose();
  }

  void stopListenResponse() {
    timer?.cancel();
    platformManager.wakelockDisable();
    notifyListeners();
  }

  void startNetworkRequest(void Function([Timer?]) callback) async {
    await platformManager.wakelockEnable();
    timer = Timer.periodic(
      networkService.messageTTL,
      callback,
    );
    callback();
    notifyListeners();
  }

  Future<void> sendToGuardian(final MessageModel message) =>
      networkService.sendTo(
        isConfirmable: false,
        peerId: message.peerId,
        message: message.copyWith(peerId: myPeerId),
      );

  VaultModel? getVaultById(final VaultId groupId) =>
      vaultRepository.get(groupId.asKey);

  Future<VaultModel> createGroup(final VaultModel group) async {
    await vaultRepository.put(group.aKey, group);
    notifyListeners();
    return group;
  }

  Future<VaultModel> addGuardian(
    final VaultId vaultId,
    final PeerId guardian,
  ) async {
    var vault = vaultRepository.get(vaultId.asKey)!;
    vault = vault.copyWith(
      guardians: {...vault.guardians, guardian: ''},
    );
    await vaultRepository.put(vaultId.asKey, vault);
    return vault;
  }
}
