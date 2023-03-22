import 'dart:async';
import 'package:flutter/material.dart';

import '/src/core/consts.dart';
import '/src/core/widgets/auth/auth.dart';
import '/src/core/service/service_root.dart';
import '/src/core/repository/repository_root.dart';
import '/src/core/controller/page_controller_base.dart';

export 'package:provider/provider.dart';

export '/src/core/model/core_model.dart';

class HomeController extends PageControllerBase {
  // TBD: remove
  late final messageStreamSubscription =
      _repositoryRoot.messageRepository.watch().listen(null);

  late final share = _serviceRoot.platformService.share;
  late final wakelockEnable = _serviceRoot.platformService.wakelockEnable;
  late final wakelockDisable = _serviceRoot.platformService.wakelockDisable;

  PeerId get myPeerId => _myPeerId;

  Map<GroupId, RecoveryGroupModel> get myVaults => _myVaults;
  Map<GroupId, RecoveryGroupModel> get guardedVaults => _guardedVaults;

  HomeController({required super.pages}) {
    _repositoryRoot.vaultRepository.watch().listen(_onVaultsUpdate);
    _repositoryRoot.settingsRepository.stream.listen(_onSettingsUpdate);
    _myPeerId = PeerId(
      token: _serviceRoot.networkService.myId,
      name: _repositoryRoot.settingsRepository.state.deviceName,
    );
    for (final vault in _repositoryRoot.vaultRepository.values) {
      vault.ownerId == _myPeerId
          ? _myVaults[vault.id] = vault
          : _guardedVaults[vault.id] = vault;
    }
  }

  final _serviceRoot = GetIt.I<ServiceRoot>();
  final _repositoryRoot = GetIt.I<RepositoryRoot>();

  final _myVaults = <GroupId, RecoveryGroupModel>{};
  final _guardedVaults = <GroupId, RecoveryGroupModel>{};

  late PeerId _myPeerId;

  Future<void> onStart(final BuildContext context) async {
    if (_repositoryRoot.settingsRepository.state.passCode.isEmpty) {
      await Navigator.of(context).pushNamed(routeIntro);
    } else {
      await demandPassCode(context);
      await pruneMessages();
    }

    await _serviceRoot.networkService.start();
  }

  Future<void> demandPassCode(final BuildContext context) => showDemandPassCode(
        context: context,
        onVibrate: _serviceRoot.platformService.vibrate,
        currentPassCode: _repositoryRoot.settingsRepository.state.passCode,
        localAuthenticate: _serviceRoot.platformService.localAuthenticate,
        useBiometrics: _repositoryRoot.settingsRepository.state.hasBiometrics &&
            _repositoryRoot.settingsRepository.state.isBiometricsEnabled,
      );

  Future<void> pruneMessages() async {
    if (_repositoryRoot.messageRepository.isEmpty) return;
    final expired = _repositoryRoot.messageRepository.values
        .where((e) =>
            e.isRequested &&
            (e.code == MessageCode.createGroup ||
                e.code == MessageCode.takeGroup) &&
            e.timestamp
                .isBefore(DateTime.now().subtract(const Duration(days: 1))))
        .toList(growable: false);
    await _repositoryRoot.messageRepository
        .deleteAll(expired.map((e) => e.aKey));
    await _repositoryRoot.messageRepository.compact();
  }

  /// Create ticket to join vault
  Future<MessageModel> createJoinVaultCode() async {
    final message = MessageModel(
      code: MessageCode.createGroup,
      peerId: myPeerId,
    );
    await _repositoryRoot.messageRepository.put(message.aKey, message);
    return message;
  }

  /// Create ticket to take vault
  Future<MessageModel> createTakeVaultCode(final GroupId? groupId) async {
    final message = MessageModel(code: MessageCode.takeGroup, peerId: myPeerId);
    await _repositoryRoot.messageRepository.put(
      message.aKey,
      message.copyWith(payload: RecoveryGroupModel(id: groupId)),
    );
    return message;
  }

  void _onSettingsUpdate(final SettingsModel settings) {
    _myPeerId = _myPeerId.copyWith(name: settings.deviceName);
    notifyListeners();
  }

  void _onVaultsUpdate(final BoxEvent event) {
    if (event.deleted) {
      _guardedVaults.remove(event.value);
      _myVaults.remove(event.value);
      notifyListeners();
    } else {
      final vault = event.value as RecoveryGroupModel;
      vault.ownerId == myPeerId
          ? _myVaults[vault.id] = vault
          : _guardedVaults[vault.id] = vault;
    }
  }
}
