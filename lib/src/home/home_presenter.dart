import 'dart:async';
import 'package:flutter/material.dart';

import '/src/core/consts.dart';
import '/src/core/widgets/auth/auth.dart';
import '/src/core/service/service_root.dart';
import '/src/core/repository/repository_root.dart';
import '/src/core/controller/page_controller_base.dart';

export 'package:provider/provider.dart';

class HomePresenter extends PageControllerBase {
  HomePresenter({required super.pages});
  final _serviceRoot = GetIt.I<ServiceRoot>();
  final _repositoryRoot = GetIt.I<RepositoryRoot>();

  late final _settingsSubscription =
      _repositoryRoot.settingsRepository.stream.listen(null);

  late final messageStreamSubscription =
      _repositoryRoot.messageRepository.watch().listen(null);

  late final wakelockEnable = _serviceRoot.platformService.wakelockEnable;
  late final wakelockDisable = _serviceRoot.platformService.wakelockDisable;

  late var _myPeerId = PeerId(
    token: _serviceRoot.networkService.myId,
    name: _repositoryRoot.settingsRepository.state.deviceName,
  );

  PeerId get myPeerId => _myPeerId;

  Future<void> init(final BuildContext context) async {
    _settingsSubscription.onData((settings) {
      _myPeerId = _myPeerId.copyWith(name: settings.deviceName);
      notifyListeners();
    });

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
}
