import 'dart:async';
import 'package:flutter/widgets.dart';

import '/src/core/service/service_root.dart';
import '/src/core/data/repository_root.dart';

export 'package:provider/provider.dart';

class SettingsPresenter extends ChangeNotifier {
  SettingsPresenter({
    ServiceRoot? serviceRoot,
    RepositoryRoot? repositoryRoot,
  })  : _serviceRoot = serviceRoot ?? GetIt.I<ServiceRoot>(),
        _repositoryRoot = repositoryRoot ?? GetIt.I<RepositoryRoot>() {
    _updatesSubsrciption = _repositoryRoot.settingsRepository.stream
        .listen((_) => notifyListeners());
  }

  String get passCode => _repositoryRoot.settingsRepository.passCode;
  String get deviceName => _repositoryRoot.settingsRepository.deviceName;
  bool get hasBiometrics => _repositoryRoot.settingsRepository.hasBiometrics;
  bool get isBootstrapEnabled =>
      _repositoryRoot.settingsRepository.isBootstrapEnabled;
  bool get isBiometricsEnabled =>
      _repositoryRoot.settingsRepository.isBiometricsEnabled;
  PeerId get myPeerId => PeerId(
        token: _serviceRoot.networkService.myId,
        name: _repositoryRoot.settingsRepository.deviceName,
      );

  late final vibrate = _serviceRoot.platformService.vibrate;
  late final setPassCode = _repositoryRoot.settingsRepository.setPassCode;
  late final setDeviceName = _repositoryRoot.settingsRepository.setDeviceName;
  late final setIsBootstrapEnabled =
      _repositoryRoot.settingsRepository.setIsBootstrapEnabled;
  late final setIsBiometricsEnabled =
      _repositoryRoot.settingsRepository.setIsBiometricsEnabled;

  final ServiceRoot _serviceRoot;
  final RepositoryRoot _repositoryRoot;

  late final StreamSubscription<void> _updatesSubsrciption;

  @override
  void dispose() async {
    await _updatesSubsrciption.cancel();
    super.dispose();
  }
}
